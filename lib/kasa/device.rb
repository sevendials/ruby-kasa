# frozen_string_literal: true

class Kasa
  # kasa device
  class Device
    # initialize
    def initialize(ip)
      @ip = ip
      @sysinfo = sysinfo
    end

    # Get system information
    def sysinfo
      Kasa::Protocol.get(@ip, '/system/get_sysinfo')
    end

    # Turn on light
    def on
      relay ON
    end

    # Turn off light
    def off
      relay OFF
    end

    # Get brightness
    def brightness
      sysinfo['brightness']
    end

    # Set brightness
    def brightness=(level)
      Kasa::Protocol.get(@ip, '/smartlife.iot.dimmer/set_brightness/brightness', level)
    end

    private

    def relay(state)
      Kasa::Protocol.get(@ip, '/system/set_relay_state/state', state)
    end
  end
end
