# frozen_string_literal: true

require 'oystercard'

describe Oystercard do
  let(:entry_station) { double(:entry_station) }
  let(:exit_station) { double(:exit_station) }
  let(:journey) { double(:Journey) }

  let(:zero_card) { Oystercard.new }
  let(:new_card) { Oystercard.new(10, journey) }

  it 'starts with an empty list of journeys' do
    expect(new_card.journeys).to eq []
  end

  it 'has a balance' do
    expect(Oystercard.new.balance).to eq(Oystercard::DEFAULT_BALANCE)
  end

  it 'tops up balance with' do
    expect { new_card.top_up(10) }.to change { new_card.balance }.by 10
  end

  it 'errors with over limit' do
    message = "Error, card has limit of #{Oystercard::TOP_UP_LIMIT}"
    expect { new_card.top_up(Oystercard::TOP_UP_LIMIT + 1) } .to raise_error message
  end

  it "should raise_error 'No money' if balance is below min_fare" do
    expect { zero_card.touch_in(entry_station) }.to raise_error('No money')
  end

  before do
    allow(journey).to receive(:new) { journey }
    allow(journey).to receive(:calculate_fare) { Oystercard::PENALTY_FARE }
  end

  it 'deducts from balance when you forget to touch out' do
    new_card.touch_in(entry_station)
    expect { new_card.touch_in(entry_station) }.to change { new_card.balance }.by -Oystercard::PENALTY_FARE
  end

  it 'deducts from balance when you forget to touch in' do
    allow(journey).to receive(:nil?) { true }
    new_card.touch_in(entry_station)
    new_card.touch_out(exit_station)
    expect { new_card.touch_out(exit_station) }.to change { new_card.balance }.by -Oystercard::PENALTY_FARE
  end
end
