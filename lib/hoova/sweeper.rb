module Hoova
  class Sweeper
    def initialize(source, destination)
      @source = source
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
      sweep if @source.updated_balance_available?
    end

    def sweep
      @source.sweep_to(@destination)
    end

  end
end