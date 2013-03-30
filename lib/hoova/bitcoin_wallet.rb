module Hoova
  class BitcoinWallet
    def initialize(username, password, host, port, ssl)
      @bitcoind = Bitcoin::Client.new(username, password, :host => host, :port => port, :ssl => ssl)
      @default_txfee = 0.0005
      update_balance
    end

    def update_balance
      acct = "*"
      minconf = 1
      @balance = @bitcoind.getbalance(acct, minconf)
    end

    def balance
      @balance
    end

    def sweep_to(destination)
      force_txfee
      send_to_address(destination.address, balance_minus_fee)
      update_balance
    end

    def updated_balance_available?
      update_balance
      balance_available?
    end

    def balance_available?
      puts balance_minus_fee
      puts @balance
      balance_minus_fee > @default_txfee
    end

    def balance_minus_fee
      @balance - @default_txfee
    end

    def force_txfee(txfee=@default_txfee)
      @bitcoind.settxfee(txfee)
    end

    def send_to_address(address, amount)
      begin
        puts 'Attempting to send #{amount} from balance of {@balance} to #{address}'
        @bitcoind.sendtoaddress(address, amount)

      rescue => e
        error = JSON.parse(e.response)['error']
        puts "Error while trying to send #{amount} from balance of #{@balance} to #{address}"
        puts error
        case error['code']
          when -4  # Needs higher txfee
            required_txfee = extract_required_txfee(error['message'])

            send_to_address(address, (@balance - required_txfee ))
          else
            puts "Unhandled error, document and implement."
        end

      end
    end

    def extract_required_txfee(message)
      #"Error: This transaction requires a transaction fee of at least 0.60 because of its amount, complexity, or use of recently received funds!"
      required_txfee = message.match(/least (.*) because/)[1].to_f
      puts "Detected required txfee request from wallet of #{required_txfee}"
      required_txfee
    end

    def available_balance
      (@balance - @default_txfee) > 0 ? (@balance - @default_txfee) : nil
    end


  end
end


