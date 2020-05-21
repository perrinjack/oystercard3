# frozen_string_literal: true

class Journey
  attr_reader :exit_station, :entry_station
  PENALTY_FARE = 5
  MINIMUM_FARE = 1

  def initialize(entry_station)
    @entry_station = entry_station
  end

  def finish_journey(exit_station)
    @exit_station = exit_station
    self
  end

  def complete?
    !!@exit_station
  end


  def calculate_fare
  return PENALTY_FARE unless complete?
  MINIMUM_FARE
  end


end
