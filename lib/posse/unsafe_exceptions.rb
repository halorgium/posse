module Posse
  def self.raise_if_unsafe(exception)
    if [NoMemoryError, SignalException, Interrupt, SystemExit].include?(exception.class)
      raise exception
    end
  end
end
