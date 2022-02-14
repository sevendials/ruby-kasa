# frozen_string_literal: true

require 'socket'
require 'json'
require 'timeout'
require 'base64'
require_relative 'kasa/version'
require_relative 'kasa/protocol'

# Control local Kasa devices
class Kasa
  attr_reader :devices

  ON = 1
  OFF = 0

  def initialize
    @devices = {}
  end

  # Populate devices hash with Kasa devices
  def refresh
    threads = []
    ip_range.each do |ip|
      threads << Thread.new do
        @devices[ip.to_s] = sysinfo(ip.to_s)
      rescue StandardError => e
      end
    end
    threads.each(&:join)
    nil
  end

  # Generate array of IP addresses from local subnet
  def ip_range
    primary_intf = Socket.getifaddrs.detect { |intf| intf.addr.ipv4_private? }
    cidr = "#{primary_intf.addr.ip_address}/#{primary_intf.netmask.ip_address}"
    IPAddr.new(cidr).to_range.to_a.map(&:to_s)
  end

  # Get system information
  def sysinfo(ip)
    Kasa::Protocol.get(ip, '/system/get_sysinfo')
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
