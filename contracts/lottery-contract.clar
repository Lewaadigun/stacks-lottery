;; Lottery Contract on Stacks Blockchain
;; This contract facilitates a decentralized, fair lottery where users can buy tickets to participate.
;; The admin can configure ticket price and maximum participants, and the contract will select a winner at random.

;; Constants - Admin and Error Codes
(define-constant admin tx-sender) ;; Admin of the contract with exclusive rights to manage lottery settings
(define-constant err-only-admin (err u100)) ;; Error: Only the admin can perform this action
(define-constant err-lottery-inactive (err u101)) ;; Error: Lottery must be active to perform this action
(define-constant err-lottery-active (err u102)) ;; Error: Lottery is already active
(define-constant err-invalid-ticket-price (err u103)) ;; Error: Ticket price must be greater than 0
(define-constant err-max-participants-reached (err u104)) ;; Error: Maximum participants reached
(define-constant err-already-participated (err u105)) ;; Error: Player has already bought a ticket
(define-constant err-winner-selected (err u106)) ;; Error: Winner already selected
(define-constant err-no-participants (err u107)) ;; Error: No participants available for selection
(define-constant err-stx-transfer-failed (err u108)) ;; Error: STX transfer failed

;; Data Variables - Core Lottery State
(define-data-var current-round-id uint u1) ;; Unique identifier for the current lottery round
(define-data-var ticket-cost uint u0) ;; Cost of a lottery ticket in STX
(define-data-var max-participants uint u0) ;; Maximum number of participants allowed per round
(define-data-var lottery-active bool false) ;; Current status of the lottery
(define-data-var prize-pool uint u0) ;; Accumulated prize pool in STX
(define-data-var participant-count uint u0) ;; Number of participants in the current round

;; Data Maps - Tracking Participants and Round Details
(define-map participants uint (list 100 principal)) ;; Maps the round ID to the list of participants
(define-map round-history
    uint
    {
        winner: (optional principal), ;; Winner address if a winner was selected
        prize-awarded: uint,         ;; Prize awarded to the winner
        end-block: uint,             ;; Block height when the round ended
        participant-total: uint      ;; Number of participants in the round
    }
)
(define-map player-tickets principal uint) ;; Maps each player to the number of tickets held (1 if entered)

;; Private Helper Functions

(define-private (select-random-winner)
    ;; Generates a pseudo-random winner index based on block hash and height.
    (let
        (
            (prev-block-hash (unwrap-panic (get-block-info? id-header-hash (- block-height u1))))
            (winner-index (mod (+ (len prev-block-hash) block-height) (var-get participant-count)))
        )
        winner-index
    )
)

(define-private (transfer-stx (amount uint) (recipient principal))
    ;; Transfers the specified STX amount to the recipient. Returns success or failure.
    (match (stx-transfer? amount tx-sender recipient)
        success (ok success)
        error (err err-stx-transfer-failed)
    )
)

;; Public Functions for Admin Management

(define-public (initialize-lottery (ticket-price uint) (max-entries uint))
    ;; Starts a new lottery round with a given ticket price and maximum number of participants.
    (begin
        (asserts! (is-eq tx-sender admin) err-only-admin)
        (asserts! (not (var-get lottery-active)) err-lottery-active)
        (asserts! (> ticket-price u0) err-invalid-ticket-price)
        (asserts! (> max-entries u0) err-invalid-ticket-price)

        ;; Initialize lottery parameters
        (var-set ticket-cost ticket-price)
        (var-set max-participants max-entries)
        (var-set lottery-active true)
        (var-set prize-pool u0)
        (var-set participant-count u0)

        (ok true)
    )
)
