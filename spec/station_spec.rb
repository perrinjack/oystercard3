# frozen_string_literal: true

require_relative '../lib/station'

describe Station do
  let(:station) { Station.new('Waterloo', 1) }

  it 'should have a name' do
    expect(station.station_info[:name]).to eq('Waterloo')
  end

  it 'should have a zone' do
    expect(station.station_info[:zone]).to eq(1)
  end
end
