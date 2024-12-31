# Lottery Contract on Stacks Blockchain

This decentralized lottery contract allows users to participate in a fair, transparent lottery on the Stacks blockchain. The contract manages lottery rounds, participant entries, and prize distribution. The contract includes various administrative functions for configuring ticket prices, maximum participants, and managing lottery rounds.

## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Setup and Deployment](#setup-and-deployment)
- [Contract Functions](#contract-functions)
- [Lottery Management](#lottery-management)
- [Player Participation](#player-participation)
- [Winner Selection](#winner-selection)
- [Accessing Information](#accessing-information)
- [Error Codes](#error-codes)
- [Contract Architecture](#contract-architecture)
- [License](#license)

## Overview

This contract facilitates a decentralized, trustless lottery system. The contract allows the administrator to configure the lottery's settings (ticket price and maximum participants), and players can buy tickets to enter. Once the lottery is complete, the contract randomly selects a winner and distributes the prize pool to the winner.

## Features

- **Decentralized Lottery**: Anyone can participate and the lottery is entirely governed by smart contract rules.
- **Ticket Purchases**: Players can buy tickets to enter the lottery by transferring STX.
- **Admin Functions**: The admin can initialize, start, stop, and select a winner for the lottery.
- **Fairness**: A random winner is selected from the participants using a pseudo-random selection method based on the block height and hash.
- **Prize Pool**: Accumulated funds (STX) are distributed to the winner of the lottery.

## Setup and Deployment

### Pre-Requisites
- A Stacks account to deploy the contract.
- A compatible wallet for interacting with the contract.

### Deployment Steps
1. **Install Stacks CLI**: You need the Stacks CLI installed to interact with the blockchain.
2. **Deploy the Contract**: 
   Use the Stacks CLI to deploy the contract to the Stacks blockchain.

   ```bash
   stacks-cli deploy lottery-contract.clar
   ```

3. **Interact with the Contract**: After deployment, interact with the contract using the provided public functions for purchasing tickets, selecting winners, and checking lottery status.

## Contract Functions

### Admin Functions

- **`initialize-lottery(ticket-price uint, max-entries uint)`**
  - Starts a new lottery round with a specified ticket price and maximum number of participants.
  - Only the admin can execute this.

- **`emergency-stop()`**
  - Stops the lottery in case of an emergency.
  - Only the admin can execute this.

- **`select-winner()`**
  - Selects a random winner from the current participants and transfers the prize pool.
  - This function is executed by the admin when the lottery ends.

### Player Participation

- **`buy-ticket()`**
  - Players can buy a lottery ticket by paying the ticket price in STX.
  - Players are added to the participant list and the prize pool is updated.

### Accessing Information

- **`get-ticket-cost()`**
  - Returns the current ticket price in STX.

- **`get-lottery-status()`**
  - Returns the current status of the lottery (active or inactive), along with prize pool, participant count, and max participants.

- **`get-round-details(round-id uint)`**
  - Fetches historical details about a completed lottery round by round ID.

- **`get-player-tickets(player principal)`**
  - Returns the number of tickets a player has purchased (either 1 or 0).

## Error Codes

- **`err-only-admin`**: Only the admin can perform this action.
- **`err-lottery-inactive`**: The lottery is not active.
- **`err-lottery-active`**: The lottery is already active.
- **`err-invalid-ticket-price`**: Ticket price must be greater than 0.
- **`err-max-participants-reached`**: The maximum number of participants for the lottery has been reached.
- **`err-already-participated`**: The player has already purchased a ticket.
- **`err-winner-selected`**: The winner has already been selected for this round.
- **`err-no-participants`**: No participants available to select a winner.
- **`err-stx-transfer-failed`**: STX transfer failed.

## Contract Architecture

### Core Components

- **Lottery State Variables**: 
  - `ticket-cost`: The price of a single ticket in STX.
  - `max-participants`: The maximum number of participants in a lottery round.
  - `lottery-active`: The current status of the lottery.
  - `prize-pool`: The total amount of STX accumulated as the prize for the round.
  - `participant-count`: The current count of participants.

- **Data Maps**:
  - `participants`: Maps the current round ID to a list of participants.
  - `round-history`: Stores history for each lottery round, including winner, prize awarded, end block, and participant count.
  - `player-tickets`: Tracks the number of tickets purchased by each player.

- **Private Helper Functions**:
  - `select-random-winner()`: Selects a random winner based on the block hash and height.
  - `transfer-stx()`: Transfers STX to a specified recipient.

### How the Lottery Works

1. **Initialization**: The admin initializes the lottery round with a ticket price and maximum participants.
2. **Player Participation**: Players can buy tickets until the maximum participant count is reached.
3. **Winner Selection**: Once the lottery is filled, the admin selects a winner, and the prize pool is awarded to the winner.

## License

MIT License
