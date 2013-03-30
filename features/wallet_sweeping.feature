# As a bitcoin merchant
# I want to be able to automatically sweep balances from one wallet to another
# So that I can move balances from hot wallets to cold storage for greater security

Feature: Sweeping an Entire Wallet to another Bitcoin Address

  Scenario: Sweeping a Local Wallet Mock
    Given a local mock wallet with a balance of "100" and user "rpcuser" and pass "rpcpass"
    And a destination bitcoin address of "123" with a balance of 0
    When I sweep the wallet to the destination address
    Then the wallet balance should be 0
    And the destination address balance should be "99.9995"

  Scenario: Sweeping a Local TestNet Wallet
    Given A local testnet sweep wallet with a balance
    And a destination bitcoin address of "miA6bqrz9thieUpd5rZmHe1XpTmY6DLjot"
    When I sweep the wallet to the destination address
    Then the wallet balance should be 0
    #And the destination address balance should be "99.9995"



