class Featurator

  class Runner
    def initialize(config_value)
      @config_value = config_value
      @handlers = {}
      @enforce_all_options = false
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

    def enforce_all_options!
      @enforce_all_options = true
    end

    def enforce_all_options?
      @enforce_all_options
    end

    def run
      handler = @handlers.fetch(@config_value) { @on_default }
      if !handler.nil?
        handler.call(@config_value)
      elsif enforce_all_options?
        raise UnhandledOption, "unhandled feature option: #{@config_value.inspect}"
      else
        # ignore
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
