# frozen_string_literal: true

require 'oystercard'

describe Oystercard do
  let(:entry_station) { double(:entry_station) }
  let(:exit_station) { double(:exit_station) }

  it 'starts with an empty list of journeys' do
    expect(subject.journeys).to eq []
  end

  it 'has a balance' do
    expect(subject.balance).to eq(Oystercard::DEFAULT_BALANCE)
  end

  it 'tops up balance with' do
    expect { subject.top_up(10) }.to change { subject.balance }.by 10
  end

  it 'errors with over limit' do
    limit = Oystercard::TOP_UP_LIMIT
    expect { subject.top_up(limit + 1) } .to raise_error "Error, card has limit of #{limit}"
  end

  describe '#in_journey?' do
    it 'should return false' do
      expect(subject).not_to be_in_journey
    end
  end

  context 'no top up' do
    describe '#touch_in' do
      it "should raise_error 'No money' if balance is below min_fare" do
        expect { subject.touch_in(entry_station) }.to raise_error('No money')
      end
    end
  end

  context 'top_up 5' do
    before do
      subject.top_up(5)
      subject.touch_in(entry_station)
    end

    describe '#touch_in' do
      it 'should change #in_journey to true' do
        expect(subject).to be_in_journey
      end

    end
      

    describe '#touch_out' do
      it 'should change #in_journey to false' do
        subject.touch_out(exit_station)
        expect(subject).not_to be_in_journey
      end
      it 'should deduct the minimum fare from the card' do
        min_fare = Oystercard::MINIMUM_FARE
        expect { subject.touch_out(exit_station) }.to change { subject.balance }.by(-min_fare)
      end
      it 'should remove the entry station on touch_out' do
        subject.touch_out(exit_station)
        expect(subject.entry_station).to eq(nil)
      end
      it 'should store entry and exit stations in a hash when touch_out' do
        subject.touch_out(exit_station)
        expect(subject.journeys).to include({entry_station: entry_station, exit_station: exit_station})
      end
    end
  end
end
