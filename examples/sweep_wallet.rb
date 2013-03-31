require 'hoova'
# Sweep a standard bitcoin-qt/bitcoind
# wallet to a specific bitcoin address

# Setup the Source
rpc_username = 'testnetu'
rpc_password = 'testnetp'
rpc_host = '127.0.0.1'
rpc_port = 19001
rpc_ssl = false
@source = Hoova::BitcoinWallet.new(rpc_username, rpc_password, rpc_host, rpc_port, rpc_ssl)

# Setup the Destination

# Bitcoin Destination Address where all funds will be swept to (paid to)
destination_address = "miA6bqrz9thieUpd5rZmHe1XpTmY6DLjot"
@destination = Hoova::BitcoinAddress.new(destination_address)

# Setup the Sweeper and Sweep!

# Sweep the Wallet One Time and Exit
Hoova::Sweeper.new(@source, @destination).sweep_once

# Sweep the Wallet Continuously checking for new Balance several times a minute
Hoova::Sweeper.new(@source, @destination).sweep_forever
