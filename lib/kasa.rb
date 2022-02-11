# frozen_string_literal: true

require 'socket'
require 'json'
require 'base64'
require_relative 'kasa/version'

# Control local Kasa devices
class Kasa
  attr_accessor :ip

  START_KEY = 171
  ON = 1
  OFF = 0
  # Your code goes here...
  def initialize(ip)
    @ip = ip
  end

  def sysinfo
    get('/system/get_sysinfo')['system']['get_sysinfo']
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

  def get(location, value = nil)
    request = value
    location = location.split('/').reject(&:empty?).reverse
    location.each do |e|
      request = { e => request }
    end

    JSON.parse decode(transport(encode(request.to_json)))
  end

  def transport(request)
    Socket.tcp(@ip, 9999) do |s|
      s.write request

      result_length = s.recv(4).unpack1('I>')
      result = ''
      while result_length.positive?
        result += s.recv(1024)
        result_length -= 1024
      end
      result
    end
  end

  def encode(plain)
    key = START_KEY

    enc_bytes = plain.unpack('C*').map do |byte|
      key = key ^ byte
      key
    end
    ([enc_bytes.length] + enc_bytes).pack('I>C*')
  end

  def decode(line)
    key = START_KEY

    line.unpack('C*').map do |enc_byte|
      byte = key ^ enc_byte
      key = enc_byte
      byte
    end.pack('C*')
  end
end
