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

  def get_sysinfo
    my_string = '{"system": {"get_sysinfo": null}}'
    key = START_KEY

    plainbytes = my_string.unpack('C*').map do |x|
      key = key ^ x
      key
    end

    payload = ([plainbytes.length] + plainbytes).pack('I>C*')
    x = Socket.tcp(@ip, 9999) do |s|
      s.write payload

      lenstr = s.recv(4).unpack1('I>')
      dope = ''
      while lenstr.positive?
        dope += s.recv(1024)
        lenstr -= 1024
      end
      dope
    end

    key = START_KEY
    JSON.parse(x.unpack('C*').map do |cypherbyte|
      plainbyte = key ^ cypherbyte
      key = cypherbyte
      plainbyte
    end.pack('C*'))
  end
end
