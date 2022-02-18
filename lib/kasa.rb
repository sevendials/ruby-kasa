# frozen_string_literal: true

require 'timeout'
require 'base64'
require 'logger'
require_relative 'kasa/version'
require_relative 'kasa/factory'

# Control local Kasa devices
class Kasa
  attr_reader :devices

  # initialize
  def initialize(discover: true, discover_interface_override: false, debug: false)
    @logger = Logger.new($stdout)
    @logger.level = debug ? Logger::DEBUG : Logger::INFO
    @devices = []
    @discover_interface_override = discover_interface_override
    refresh if discover
  end

  # Populate devices hash with Kasa devices
  def refresh
    threads = []
    ip_range.each do |ip|
      threads << Thread.new do
        @devices << Kasa::Factory.new(ip)
      rescue StandardError => e
        @logger.debug e
      end
    end
    threads.each(&:join)
    @devices
  end

  private

  # Return CIDR of first IPv4 interface or user-specified interface
  def cidr
    interface = Socket.getifaddrs.detect do |intf|
      intf.addr.ipv4_private? && (@discover_interface_override ? intf.name.eql?(@discover_interface_override) : true)
    end

    raise 'Interface does not exist' if interface.nil?

    "#{interface.addr.ip_address}/#{interface.netmask.ip_address}"
  end

  # Generate array of IP addresses from local subnet
  def ip_range
    IPAddr.new(cidr).to_range.to_a.map(&:to_s)
  end
end
