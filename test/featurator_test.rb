require 'bundler/setup'
require 'minitest/autorun'
require 'featurator'

class FeaturatorTest < Minitest::Spec

  describe 'boolean features' do
    specify 'has #enabled? and #disabled? predicates for boolean features' do
      features = Featurator.new(foo: true)
      assert features.enabled?(:foo)
      refute features.disabled?(:foo)
    end

    specify 'non boolean features are always #disabled?' do
      features = Featurator.new(foo: :bar)
      refute features.enabled?(:foo)
      assert features.disabled?(:foo)
    end

    specify 'blows up for non-features' do
      assert_raises(Featurator::FeatureNotDefined, 'feature not defined: :bar') do
        Featurator.new(foo: true).enabled?(:bar)
      end
    end
  end

  describe 'block dsl' do
    specify 'yields to an #on handler' do
      assert_output('FEATURE IS ON') do
        Featurator.new(foo: true).with_feature(:foo) do |feature|
          feature.on(true) { print 'FEATURE IS ON' }
          feature.on(false) { print 'nope' }
        end
      end
    end

    specify 'supports multiple options in #on handlers' do
      assert_output('The feature is B') do
        Featurator.new(foo: :B).with_feature(:foo) do |feature|
          feature.on(:A) { print 'not A' }
          feature.on(:B, :C) { |option| print "The feature is #{option}" }
        end
      end
    end

    specify 'yields to an #on_default handler when unhandled' do
      assert_output('Is actually Q') do
        Featurator.new(foo: :Q).with_feature(:foo) do |feature|
          feature.on_default { |option| print "Is actually #{option}"}
        end
      end
    end

    specify 'yields to an #on_error handler' do
      assert_output('unhandled feature option: :Q') do
        Featurator.new(foo: :Q).with_feature(:foo) do |feature|
          feature.on_error { |error| print error.message }
        end
      end
    end

    specify 'raises an unhandled error' do
      assert_raises(Featurator::UnhandledOption, 'unhandled feature option: :Q') do
        Featurator.new(foo: :Q).with_feature(:foo) { |feature| :nothing }
      end
    end
  end

end
