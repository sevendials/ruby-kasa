# frozen_string_literal: true

require 'socket'
require 'json'
require 'timeout'
require 'base64'
require_relative 'kasa/version'
require_relative 'kasa/protocol'

# Control local Kasa devices
class Kasa
  attr_accessor :ip

  START_KEY = 171
  ON = 1
  OFF = 0
  TIMEOUT = 2

  def initialize(ip)
    @ip = ip
  end

  def sysinfo
    Kasa::Protocol.get(@ip, '/system/get_sysinfo')['system']['get_sysinfo']
  end

  def on
    relay ON
  end

  def off
    relay OFF
  end

  def brightness
    sysinfo['brightness']
  end

  def brightness=(level)
    get('/smartlife.iot.dimmer/set_brightness/brightness', level)
  end

  private

  def relay(state)
    get('/system/set_relay_state/state', state)
  end
end
# primary_intf = Socket.getifaddrs.detect { |intf| intf.addr.ipv4_private? }
# IPAddr.new("#{primary_intf.addr.ip_address}/#{primary_intf.netmask.ip_address}").to_range.to_a.each do |ip|
