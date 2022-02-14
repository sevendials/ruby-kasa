# frozen_string_literal: true

require 'socket'
require 'json'
require 'timeout'
require 'base64'
require_relative 'kasa/version'
require_relative 'kasa/factory'

# Control local Kasa devices
class Kasa
  attr_reader :devices

  # initialize
  def initialize
    @devices = []
    refresh
  end

  # Populate devices hash with Kasa devices
  def refresh
    threads = []
    ip_range.each do |ip|
      threads << Thread.new do
        @devices << Kasa::Factory.new(ip)
      rescue StandardError => e
        puts e
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
end
