# frozen_string_literal: true

class Kasa
  # Common methods across kasa devices
  class Device
    ON = 1
    OFF = 0

    attr_reader :ip

    # initialize
    def initialize(ip)
      @ip = ip
      @sysinfo = sysinfo
    end

    # Get system information
    def sysinfo
      Kasa::Protocol.get(@ip, location: '/system/get_sysinfo')
    end

    # Turn on light
    def on
      relay ON
    end

    # Turn off light
    def off
      relay OFF
    end

    private

    def relay(state)
      Kasa::Protocol.get(@ip, location: '/system/set_relay_state/state', value: state)
    end
  end

  # Most devices are not dimmable
  class NonDimmable < Device
  end

  # add dimmable device
  class Dimmable < NonDimmable
    # Get brightness
    def brightness
      sysinfo['brightness']
    end

    # Set brightness
    def brightness=(level)
      Kasa::Protocol.get(@ip, location: '/smartlife.iot.dimmer/set_brightness/brightness', value: level)
    end
  end

  # add dimmable device
  class SmartStrip < NonDimmable
    # Turn on light
    def on(index)
      relay ON, index
    end

    # Turn off light
    def off(index)
      relay OFF, index
    end

    private

    def relay(state, index)
      child_id = sysinfo['children'].map { |c| c['id'] }[index]
      Kasa::Protocol.get(@ip, location: '/system/set_relay_state/state', value: state,
                              extra: { context: { child_ids: [child_id] } })
    end
  end
end
