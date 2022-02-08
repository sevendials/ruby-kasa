# frozen_string_literal: true

require 'socket'
require 'json'
require_relative 'kasa/version'

# Control local Kasa devices
class Kasa
  attr_accessor :ip

  START_KEY = 171
  # Your code goes here...
  def initialize(ip)
    @ip = ip
  end

  def sysinfo
    my_string = '{"system": {"get_sysinfo": null}}'

    x = Socket.tcp(@ip, 9999) do |s|
      s.write encode my_string

      lenstr = s.recv(4).unpack1('I>')
      dope = ''
      while lenstr.positive?
        dope += s.recv(1024)
        lenstr -= 1024
      end
      dope
    end

    JSON.parse(decode(x))
  end

  def encode(line)
    key = START_KEY

    cypherbytes = line.unpack('C*').map do |byte|
      key = key ^ byte
      key
    end
    ([cypherbytes.length] + cypherbytes).pack('I>C*')
  end

  def decode(line)
    key = START_KEY
    line.unpack('C*').map do |cypherbyte|
      byte = key ^ cypherbyte
      key = cypherbyte
      byte
    end.pack('C*')
  end
end
