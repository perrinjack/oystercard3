# frozen_string_literal: true

require 'journey'

describe Journey do
  let(:entry_station) { double(:entry_station) }
  let(:exit_station) { double(:exit_station) }
  let(:journey) { Journey.new(entry_station) }

  it 'sets entry station' do
    expect(journey.entry_station).to eq(entry_station)
  end

  it 'sets exit station' do
    journey.finish_journey(exit_station)
    expect(journey.exit_station).to eq(exit_station)
  end

  it 'knows its in journey' do
    expect(journey).to_not be_complete
  end

  it 'returns itself when exiting a journey' do
    expect(journey.finish_journey(exit_station)).to eq(journey)
  end

  it 'returns penalty fare if journey not complete' do
    expect(journey.calculate_fare).to eq(Journey::PENALTY_FARE)
  end

  it 'returns minimum fare if journey complete' do
    journey.finish_journey(exit_station)
    expect(journey.calculate_fare).to eq(Journey::MINIMUM_FARE)
  end
end
