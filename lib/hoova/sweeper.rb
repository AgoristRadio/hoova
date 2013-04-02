module Hoova
  class Sweeper
    def initialize(source, destination)
      @source = source
      @destination = destination
      @sweep_poll_delay = 10
    end

=begin
    def sweep_forever
      loop do
        sweep_once
        sleep @sweep_poll_delay
      end
    end
=end

    def sweep_once
      if @source.updated_balance_available?
        result = sweep
        puts "REZULT"
        puts result
        return "OK: #{result}"
      else
        return "OK: No balance detected."
      end
    end

    def sweep
      @source.sweep_to(@destination)
    end

  end
end