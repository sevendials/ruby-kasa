# frozen_string_literal: true

require 'kasa'
require 'fileutils'
require 'yaml'

# Monkey patch to capture and retrieve output from get() , similar to VCR
class Kasa
  class Protocol
    old_method = singleton_method(:get)
    define_singleton_method(:get) do |ip, location:, value: nil, extra: {}|
      example_path = RSpec.current_example.example_group.to_s.gsub('::', '/').sub('RSpec/ExampleGroups',
                                                                                  'spec/fixtures/record')
      example_test = RSpec.current_example.description.gsub(/[^[:word:]*]/, '_')
      encoded_args = Base64.urlsafe_encode64((ip + location + value.to_s + extra.to_s), padding: false)
      example = "#{example_path}/#{example_test}/#{encoded_args}.yml"
      # If output was captured then use that
      result = {}
      if File.exist? example
        result = YAML.load_file example
      else
        result = begin
          old_method.call(ip, location: location, value: value, extra: extra)
        rescue StandardError => e
          JSON.parse e.message
        end

        FileUtils.mkdir_p File.dirname example
        File.write(example, result.to_yaml)
      end
      raise result.to_json if result.is_a?(Hash) && result['err_code']&.negative?

      result
    end
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
