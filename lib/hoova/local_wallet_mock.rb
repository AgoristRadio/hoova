module Hoova
  class LocalWalletMock
    def initialize(rpcuser, rpcpass)
      @rpcuser = rpcuser
      @rpcpass = rpcpass
      @default_txfee = 0.0005
    end

    def balance
      @balance
    end

    def balance=(balance)
      @balance = balance.to_f # TODO look into better type f might not be best
    end

    def send_balance_to(destination)
      send_to_address(destination, balance_minus_fee)
      debit(@balance)
    end

    def balance_available?
      balance_minus_fee < @balance
    end

    def balance_minus_fee
      (@balance - @default_txfee) #.round(8)
    end


    def send_to_address(destination, amount)
      destination.credit(amount)
    end

    def debit(amount)
      @balance = @balance - amount
    end

  end
end