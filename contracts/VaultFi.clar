;; Title: VaultFi - Decentralized Collateralized Lending Protocol
;; Summary: Advanced DeFi lending platform enabling secure Bitcoin collateralization
;;          with dynamic risk management and automated liquidation mechanisms
;; Description: VaultFi revolutionizes decentralized finance by providing a robust
;;              infrastructure for collateral-backed lending. Users can leverage their
;;              Bitcoin holdings to access instant liquidity while maintaining exposure
;;              to their digital assets. The protocol features intelligent risk assessment,
;;              real-time collateral monitoring, and automated liquidation protection to
;;              ensure market stability and user security. Built with enterprise-grade
;;              security standards and optimized for scalability.

;; CONSTANTS & ERROR CODES

(define-constant CONTRACT-OWNER tx-sender)

;; Error codes for contract operations
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-INSUFFICIENT-COLLATERAL (err u101))
(define-constant ERR-BELOW-MINIMUM (err u102))
(define-constant ERR-INVALID-AMOUNT (err u103))
(define-constant ERR-ALREADY-INITIALIZED (err u104))
(define-constant ERR-NOT-INITIALIZED (err u105))
(define-constant ERR-INVALID-LIQUIDATION (err u106))
(define-constant ERR-LOAN-NOT-FOUND (err u107))
(define-constant ERR-LOAN-NOT-ACTIVE (err u108))
(define-constant ERR-INVALID-LOAN-ID (err u109))
(define-constant ERR-INVALID-PRICE (err u110))
(define-constant ERR-INVALID-ASSET (err u111))

;; Supported collateral assets
(define-constant VALID-ASSETS (list "BTC" "STX"))

;; STATE VARIABLES

;; Platform initialization status
(define-data-var platform-initialized bool false)

;; Risk management parameters
(define-data-var minimum-collateral-ratio uint u150) ;; 150% minimum collateral ratio
(define-data-var liquidation-threshold uint u120) ;; 120% liquidation trigger
(define-data-var platform-fee-rate uint u1) ;; 1% platform fee

;; Platform metrics
(define-data-var total-btc-locked uint u0)
(define-data-var total-loans-issued uint u0)

;; DATA STRUCTURES

;; Loan registry with comprehensive loan data
(define-map loans
  { loan-id: uint }
  {
    borrower: principal,
    collateral-amount: uint,
    loan-amount: uint,
    interest-rate: uint,
    start-height: uint,
    last-interest-calc: uint,
    status: (string-ascii 20),
  }
)

;; User loan tracking for portfolio management
(define-map user-loans
  { user: principal }
  { active-loans: (list 10 uint) }
)

;; Dynamic price feed for collateral valuation
(define-map collateral-prices
  { asset: (string-ascii 3) }
  { price: uint }
)

;; PRIVATE UTILITY FUNCTIONS

;; Calculate collateral-to-loan ratio for risk assessment
(define-private (calculate-collateral-ratio
    (collateral uint)
    (loan uint)
    (btc-price uint)
  )
  (let (
      (collateral-value (* collateral btc-price))
      (ratio (* (/ collateral-value loan) u100))
    )
    ratio
  )
)

;; Calculate compound interest based on block height
(define-private (calculate-interest
    (principal uint)
    (rate uint)
    (blocks uint)
  )
  (let (
      (interest-per-block (/ (* principal rate) (* u100 u144))) ;; Daily interest / blocks per day
      (total-interest (* interest-per-block blocks))
    )
    total-interest
  )
)

;; Automated liquidation check and execution
(define-private (check-liquidation (loan-id uint))
  (let (
      (loan (unwrap! (map-get? loans { loan-id: loan-id }) ERR-LOAN-NOT-FOUND))
      (btc-price (unwrap! (get price (map-get? collateral-prices { asset: "BTC" }))
        ERR-NOT-INITIALIZED
      ))
      (current-ratio (calculate-collateral-ratio (get collateral-amount loan)
        (get loan-amount loan) btc-price
      ))
    )
    (if (<= current-ratio (var-get liquidation-threshold))
      (liquidate-position loan-id)
      (ok true)
    )
  )
)

;; Execute liquidation procedure
(define-private (liquidate-position (loan-id uint))
  (let (
      (loan (unwrap! (map-get? loans { loan-id: loan-id }) ERR-LOAN-NOT-FOUND))
      (borrower (get borrower loan))
    )
    (begin
      (map-set loans { loan-id: loan-id } (merge loan { status: "liquidated" }))
      (map-delete user-loans { user: borrower })
      (ok true)
    )
  )
)

;; Validate loan ID range and existence
(define-private (validate-loan-id (loan-id uint))
  (and
    (> loan-id u0)
    (<= loan-id (var-get total-loans-issued))
  )
)

;; Validate supported asset types
(define-private (is-valid-asset (asset (string-ascii 3)))
  (is-some (index-of VALID-ASSETS asset))
)