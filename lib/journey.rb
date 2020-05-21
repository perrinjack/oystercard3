class Journey

 attr_reader :current_journey

 def initialize
   @current_journey = nil
 end

 def start_journey(entry_station)
   @entry_station = entry_station
 end

 def finish_journey(exit_station)
   @exit_station = exit_station
   @current_journey = { entry_station: @entry_station, exit_station: @exit_station }
   @entry_station = nil
 end

 def in_journey?
   !!@entry_station
 end

end