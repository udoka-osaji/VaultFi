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