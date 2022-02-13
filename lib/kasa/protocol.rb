# frozen_string_literal: true

class Kasa
  # TP link protocol
  class Protocol
    START_KEY = 171
    TIMEOUT = 2

    def self.get(ip, location, value = nil)
      request = request_to_hash location, value

      encoded_response = Timeout.timeout(TIMEOUT) do
        transport(ip, encode(request.to_json))
      end

      strip_location(location, decode(encoded_response))
    end

    def self.strip_location(location, response)
      location = location.split('/').reject(&:empty?)
      response = JSON.parse response
      location.each do |j|
        response = (response[j] or response)
      end

      response
    end

    def self.request_to_hash(location, value)
      request = value
      location = location.split('/').reject(&:empty?).reverse
      location.each do |e|
        request = { e => request }
      end

      request
    end

    def self.transport(ip, request)
      Socket.tcp(ip, 9999) do |s|
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

    def self.encode(plain)
      key = START_KEY

      enc_bytes = plain.unpack('C*').map do |byte|
        key = key ^ byte
        key
      end
      ([enc_bytes.length] + enc_bytes).pack('I>C*')
    end

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
