require 'buildpacks'
require 'fakefs/spec_helpers'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  def wrap_env(envs = {})
    original_envs = ENV.select{ |k, _| envs.has_key? k }
    envs.each{ |k, v| ENV[k] = v }

    yield
  ensure
    envs.each{ |k, _| ENV.delete k }
    original_envs.each{ |k, v| ENV[k] = v }
  end
end
