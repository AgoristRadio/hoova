# TODO Implement proper debugging output, kill puts
class Unauthorized < StandardError;
end
class InvalidWallet < StandardError;
end
class ConnectionTimeout < StandardError;
end

module Hoova
  class BitcoinWallet
    def initialize(username, password, host, port, ssl)
      @bitcoind = Bitcoin::Client.new(username, password, :host => host, :port => port, :ssl => ssl)
      @default_txfee = 0.0005

      begin
        update_balance

      rescue Errno::ETIMEDOUT
        raise ConnectionTimeout
      rescue => e
        if e.message.match(/401 Unauthorized/)
          raise Unauthorized
        elsif e.message.match(/wrong status line:/)
          raise InvalidWallet
        else
          puts 'Unhandled exception...'
          puts e.inspect
          puts e.message
        end
      end
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
      result = send_to_address(destination.address, balance_minus_fee)
      update_balance
      result
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
      @bitcoind.settxfee txfee
    end

    def send_to_address(address, amount)
      # TODO this is skanky ugly
      begin
        puts "Attempting to send #{amount} from balance of #{@balance} to #{address}"
        result = @bitcoind.sendtoaddress(address, amount)
        if result.size == 64 # Transaction Size in Characters
          result = "Swept #{amount} from balance of #{@balance}"
        end

      rescue => e
        error = JSON.parse(e.response)['error']
        puts "Error while trying to send #{amount} from balance of #{@balance} to #{address}"
        puts error
        puts error['code'].inspect
        case error['code']
          when -4 # Needs higher txfee
            case error['message']
              when 'Insufficient funds'
                # this could be because of immature transactions
                # Trap this like this:
                # - list recent transactions
                # - look for any transaction with category 'immature'
                # "account" : "",
                # "address" : "mqeyho5zKuSXsYnbbWWhPR3CdNxPWfkyx9",
                # "category" : "immature",
                # "amount" : 50.00000000,
                # "confirmations" : 2,
                # "generated" : true,
                # "blockhash" : "0000000040af50fc5c4da6ac2bb44190a3655973e3b78716da43056d6dbc10cf",
                # "blockindex" : 0,
                # "blocktime" : 1364764219,
                # "txid" : "45b83f0a71611fcc33c26ceb39d938d2ca208fdde885c78fde4fcd536c21cb2a",
                # "time" : 1364764211,
                # "timereceived" : 1364764211
                #}
                # - Get the amount
                # - subtract amount from 'balance available to send'
                # - send balance - transaction fee - these immature ones
                # TODO - edge case since most people dont mine.
                # I just ran into this on testnet
                puts @bitcoind.getinfo

                # CRITICAL TODO, everything is crapping out.
                # HACK, until immature coins are 'good' hack balance to return - 50


                result = send_to_address(address, (amount - @default_txfee))
                #return error['message']
                return result
            end

            required_txfee = extract_required_txfee(error['message'])

            result = send_to_address(address, (@balance - required_txfee))
          else
            result = "Unhandled error, document and implement."
            puts result
        end

      end
      result
    end

    def extract_required_txfee(message)
      # TODO this is ugly
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


