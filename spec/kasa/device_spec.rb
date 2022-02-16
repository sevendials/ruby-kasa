# frozen_string_literal: true

RSpec.describe Kasa::Factory do
  context 'when power strip' do
    let :device do
      described_class.new('192.168.1.118')
    end

    context 'when sysinfo called' do
      it 'has a version number' do
        expect(Kasa::VERSION).not_to be nil
      end

      it 'returns correct model' do
        expect(device.sysinfo['model']).to eq('HS300(US)')
      end

      it 'has children' do
        expect(device.sysinfo['children'].class).to eq(Array)
      end
    end

    context 'when device is turned on with valid index' do
      it 'succeeds' do
        expect(device.on(1)).to eq({ foo: 2 })
      end
    end

    context 'when device is turned on with invalid index' do
      it 'succeeds' do
        expect(device.on(7)).to eq({ foo: 3 })
      end
    end
  end
end
