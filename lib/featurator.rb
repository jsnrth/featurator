require "featurator/version"

class Featurator

  def initialize(config = {})
    @config = config
  end

  def enabled?(feature_name)
    @config.fetch(feature_name) == true || false
  rescue KeyError => e
    raise FeatureNotDefined, "feature not defined: #{feature_name.inspect}"
  end

  def disabled?(feature_name)
    !enabled?(feature_name)
  end

  def with_feature(feature_name)
    feature = Feature.new(@config.fetch(feature_name))
    yield(feature)
    feature.run
  end

  class FeatureNotDefined < StandardError
  end

  class UnhandledOption < StandardError
  end

  class Feature
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
end
