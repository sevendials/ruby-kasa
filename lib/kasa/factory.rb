# frozen_string_literal: true

require_relative 'devices'
require_relative 'protocol'

class Kasa
  DEVICE_TYPES = {
    Dimmable => [
      'HS220(US)'
    ],
    NonDimmable => [
      'HS200(US)',
      'HS105(US)',
      'HS210(US)'
    ],
    SmartStrip => [
      'HS300(US)',
      'KP303(US)',
      'KP400(US)'
    ]
  }.freeze

  # Common methods across kasa devices
  class Factory
    # Factory
    def self.new(ip)
      model = Kasa::Protocol.get(ip, '/system/get_sysinfo')['model']
      begin
        object = DEVICE_TYPES.detect { |_k, v| v.include? model }.first.allocate
      rescue StandardError => _e
        raise "#{model} not supported"
      end
      object.send :initialize, ip
      object
    end
  end
end
