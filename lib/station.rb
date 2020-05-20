class Station

  attr_reader :station_info

  def initialize(name, zone)
    @station_info = {:name => name, :zone => zone}
  end
end
