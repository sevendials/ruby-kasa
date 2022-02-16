# frozen_string_literal: true

require 'kasa'
require 'fileutils'
require 'yaml'

class Kasa
  class Protocol
    def self.get(ip, location:, value: nil, extra: {})
      example_path = RSpec.current_example.example_group.to_s.gsub('::', '/').sub('RSpec/ExampleGroups',
                                                                                  'spec/fixtures/record')
      example_test = RSpec.current_example.description.gsub(/[^[:word:]*]/, '_')
      encoded_args = Base64.urlsafe_encode64((ip + location + value.to_s + extra.to_s), padding: false)
      example = "#{example_path}/#{example_test}/#{encoded_args}.yml"

      if File.exist? example
        YAML.load_file example
      else
        request = request_to_hash location, value
        request.merge! extra

        encoded_response = Timeout.timeout(TIMEOUT) do
          transport(ip, encode(request.to_json))
        end

        result = strip_location(location, decode(encoded_response))

        FileUtils.mkdir_p File.dirname example
        File.write(example, result.to_yaml)

        result
      end
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
