module Hoova
  class Sweeper
    def initialize(wallet, destination)
      @wallet = wallet
      @destination = destination
      @sweep_poll_delay = 10
    end

    def sweep_forever
      loop do
        sweep_once
        sleep @sweep_poll_delay
      end
    end

    def sweep_once
      sweep if @wallet.updated_balance_available?
    end

    def sweep
      @wallet.send_balance_to(@destination)
    end

  end
end