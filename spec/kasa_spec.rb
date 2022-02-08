# frozen_string_literal: true

RSpec.describe Kasa do
  let :package do
    described_class.new '192.168.1.118'
  end

  it 'has a version number' do
    expect(Kasa::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(package.get_sysinfo['system']['get_sysinfo']['alias']).to eq('TP-LINK_Power Strip_DD06')
  end
end
