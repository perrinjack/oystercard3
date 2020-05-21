# frozen_string_literal: true

require 'oystercard'

describe Oystercard do
  let(:entry_station) { double(:entry_station) }
  let(:exit_station) { double(:exit_station) }
  let(:journey) { double(:Journey) }

  let(:new_card) { Oystercard.new }
  let(:high_balance_card) { Oystercard.new(30) }

  let(:test_instance_card) { Oystercard.new(10, journey) }

  it 'starts with an empty list of journeys' do
    expect(new_card.journeys).to eq []
  end

  it 'has a balance' do
    expect(new_card.balance).to eq(Oystercard::DEFAULT_BALANCE)
  end

  it 'tops up balance with' do
    expect { new_card.top_up(10) }.to change { new_card.balance }.by 10
  end

  it 'errors with over limit' do
    limit = Oystercard::TOP_UP_LIMIT
    expect { subject.top_up(limit + 1) } .to raise_error "Error, card has limit of #{limit}"
  end

  it 'should return false' do
    expect(subject).not_to be_in_journey
  end

  it "should raise_error 'No money' if balance is below min_fare" do
    expect { subject.touch_in(entry_station) }.to raise_error('No money')
  end

  context 'top_up 5' do
    before do
      high_balance_card.touch_in(entry_station)
    end

    it 'should change #in_journey to true' do
      expect(high_balance_card).to be_in_journey
    end

    it 'should change #in_journey to false' do
      high_balance_card.touch_out(exit_station)
      expect(high_balance_card).not_to be_in_journey
    end

    it 'should deduct the minimum fare from the card' do
      expect { high_balance_card.touch_out(exit_station) }.to change { high_balance_card.balance }.by(-Oystercard::MINIMUM_FARE)
    end

    it 'should store a journey instance when touch_out' do
      high_balance_card.touch_out(exit_station)
      expect(high_balance_card.journeys).to include(journey)
    end
  end
end
