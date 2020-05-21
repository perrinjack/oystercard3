# frozen_string_literal: true

class Journey
  attr_reader :exit_station, :entry_station

  def initialize(entry_station)
    # @current_journey = nil
    @entry_station = entry_station
  end

  def finish_journey(exit_station)
    @exit_station = exit_station
    # @current_journey = { entry_station: @entry_station, exit_station: @exit_station }
    # @entry_station = nil
  end

  def in_journey?
    !@exit_station
  end
end
