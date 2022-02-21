# frozen_string_literal: true

require 'json'
require 'socket'

class Kasa
  # TP link protocol
  class Protocol
    START_KEY = 171
    TIMEOUT = 2
    KASA_PORT = 9999

    # get result from request
    def self.get(ip, location:, value: nil, extra: {})
      request = request_to_hash location, value
      request.merge! extra

      encoded_response = Timeout.timeout(TIMEOUT) do
        transport(ip, encode(request.to_json))
      end

      response = strip_location(location, decode(encoded_response))
      validate response

      response
    end

    # examine error code
    def self.validate(response)
      raise response.to_s unless response['err_code'].zero?
    end

    # strip away the request location from the response
    def self.strip_location(location, response)
      location = location.split('/').reject(&:empty?)
      response = JSON.parse response
      location.each do |j|
        response = (response[j] or response)
      end

      response
    end

    # convert location and value to a hash
    def self.request_to_hash(location, value)
      request = value
      location = location.split('/').reject(&:empty?).reverse
      location.each do |e|
        request = { e => request }
      end

      request
    end

    # Open socket and send request and response
    def self.transport(ip, request)
      Socket.tcp(ip, KASA_PORT) do |s|
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

    # Encrypt and encode
    def self.encode(plain)
      key = START_KEY

      enc_bytes = plain.unpack('C*').map do |byte|
        key = key ^ byte
        key
      end
      ([enc_bytes.length] + enc_bytes).pack('I>C*')
    end

    # Decrypt and decode
    def self.decode(line)
      key = START_KEY

      line.unpack('C*').map do |enc_byte|
        byte = key ^ enc_byte
        key = enc_byte
        byte
      end.pack('C*')
    end
  end
end
