require 'featurator/version'
require 'featurator/runner'

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

  def run(feature_name)
    runner = Runner.new(@config.fetch(feature_name))
    yield(runner)
    runner.run
  end

  class FeatureNotDefined < StandardError
  end

end
