# frozen_string_literal: true
require_relative 'journey.rb'
class Oystercard
  TOP_UP_LIMIT = 100
  MINIMUM_FARE = 4
  DEFAULT_BALANCE = 3

  attr_reader :balance, :journeys

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
    @journey = @journey_instance.new(entry_station)
  end

  def touch_out(exit_station)
    deduct(MINIMUM_FARE)
    @journey.finish_journey(exit_station)
    @journeys << @journey
  end

  def in_journey?
    return false if @journey.nil?
    @journey.in_journey?
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
