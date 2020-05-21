# frozen_string_literal: true

require_relative 'journey.rb'
class Oystercard
  TOP_UP_LIMIT = 100
  MINIMUM_BALANCE = 1
  DEFAULT_BALANCE = 0
  PENALTY_FARE = Journey::PENALTY_FARE

  attr_reader :balance, :journeys, :journey, :journey_instance

  def initialize(balance = DEFAULT_BALANCE, journey_instance = Journey)
    @balance = balance
    @journeys = []
    @journey_instance = journey_instance
  end

  def top_up(value)
    raise "Error, card has limit of #{TOP_UP_LIMIT}" if over_limit?(value)

    @balance += value
  end

  def touch_in(entry_station)
    raise 'No money' if insufficient_funds?

    deduct(journey.calculate_fare) unless journey.nil?
    @journey = journey_instance.new(entry_station)
  end

  def touch_out(exit_station)
    journey.nil? ? deduct(PENALTY_FARE) : finish_journey_process(exit_station)
  end

  private

  def finish_journey_process(exit_station)
    @journeys << journey.finish_journey(exit_station)
    deduct(journey.calculate_fare)
    @journey = nil
  end

  def deduct(fare)
    @balance -= fare
  end

  def insufficient_funds?
    balance < MINIMUM_BALANCE
  end

  def over_limit?(value)
    value + balance > TOP_UP_LIMIT
  end
end
