# frozen_string_literal: true

RSpec.describe Kasa::Factory do
  it 'has a version number' do
    expect(Kasa::VERSION).not_to be nil
  end

  context 'when dimmer switch' do
    let :device do
      described_class.new('192.168.1.145')
    end

    it 'creates the correct class object' do
      expect(device.class).to be Kasa::Dimmable
    end

    context 'when sysinfo called' do
      it 'returns correct model' do
        expect(device.sysinfo['model']).to eq('HS220(US)')
      end

      it 'has no children' do
        expect(device.sysinfo.key?('children')).to be false
      end
    end

    context 'when device is turned on' do
      before do
        device.on
      end

      it 'appears on' do
        expect(device.relay_state).to be 1
      end
    end

    context 'when device is turned off' do
      before do
        device.off
      end

      it 'reports as off' do
        expect(device.relay_state).to be 0
      end
    end
  end

  context 'when power strip' do
    let :device do
      described_class.new('192.168.1.118')
    end

    it 'creates the correct class object' do
      expect(device.class).to be Kasa::SmartStrip
    end

    context 'when sysinfo called' do
      it 'returns correct model' do
        expect(device.sysinfo['model']).to eq('HS300(US)')
      end

      it 'has children' do
        expect(device.sysinfo['children'].class).to eq(Array)
      end
    end

    context 'when device is turned on with valid index' do
      it 'succeeds' do
        expect(device.on(1)).to eq({ 'err_code' => 0 })
      end
    end

    context 'when device is turned on with invalid index' do
      it 'succeeds' do
        expect(device.on(7)).to eq({ 'err_code' => -14, 'err_msg' => 'entry not exist' })
      end
    end
  end
end
