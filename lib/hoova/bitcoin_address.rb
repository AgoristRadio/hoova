module Hoova
  class BitcoinAddress
    def initialize(address)
      @address = address
    end

    def address
      @address
    end

    def balance
      @balance
    end

    def balance=(amount)
      @balance = amount.to_f
    end

    def credit(amount)
      @balance += amount
    end
  end
end