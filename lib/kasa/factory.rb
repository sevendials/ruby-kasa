# frozen_string_literal: true

require_relative 'devices'
require_relative 'protocol'

class Kasa
  # Common methods across kasa devices
  class Factory
    # Factory
    def self.new(ip)
      model = Kasa::Protocol.get(ip, '/system/get_sysinfo')['model']
      object = if model.eql? 'HS220(US)'
                 Kasa::Dimmable.allocate
               else
                 Kasa::NonDimmable.allocate
               end
      object.send :initialize, ip
      object
    end
  end
end
