class Oystercard

TOP_UP_LIMIT = 90
MINIMUM_FARE = 1
DEFAULT_BALANCE = 0

  attr_reader :balance, :entry_station

  def initialize(balance = DEFAULT_BALANCE)
    @balance = balance
  end

  def top_up(value)
    fail "Error, card has limit of #{TOP_UP_LIMIT}" if over_limit?(value)
    @balance += value
  end

  def touch_in(entry_station)
    raise "No money" if insufficient_funds?
    @entry_station = entry_station
  end

  def touch_out
    deduct(MINIMUM_FARE)
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
