# frozen_string_literal: true

class Oystercard
  TOP_UP_LIMIT = 100
  MINIMUM_FARE = 4
  DEFAULT_BALANCE = 3

  attr_reader :balance, :entry_station, :journeys

  def initialize(balance = DEFAULT_BALANCE)
    @balance = balance
    @journeys = []
  end

  def top_up(value)
    raise "Error, card has limit of #{TOP_UP_LIMIT}" if over_limit?(value)

    @balance += value
  end

  def touch_in(entry_station)
    raise 'No money' if insufficient_funds?

    @entry_station = entry_station
  end

  def touch_out(exit_station)
    deduct(MINIMUM_FARE)
    @journeys << { entry_station: entry_station, exit_station: exit_station }
    @entry_station = nil
  end

  def in_journey?
    !!@entry_station
  end

  private

  def deduct(fare)
    @balance -= fare
  end

  def insufficient_funds?
    balance < MINIMUM_FARE
  end

  def over_limit?(value)
    value + balance > TOP_UP_LIMIT
  end
end
