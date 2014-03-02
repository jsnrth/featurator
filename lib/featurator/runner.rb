class Featurator

  class Runner
    def initialize(config_value)
      @config_value = config_value
      @handlers = {}
    end

    def on(*feature_values, &block)
      feature_values.each do |value|
        @handlers[value] = block
      end
    end

    def on_default(&block)
      @on_default = block
    end

    def on_error(&block)
      @on_error = block
    end

    def run
      handler = @handlers.fetch(@config_value) { @on_default }
      if !handler.nil?
        handler.call(@config_value)
      else
        raise UnhandledOption, "unhandled feature option: #{@config_value.inspect}"
      end
    rescue => e
      if !@on_error.nil?
        @on_error.call(e)
      else
        raise
      end
    end
  end

  class UnhandledOption < StandardError
  end

end
