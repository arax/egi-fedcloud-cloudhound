require 'terminal-table'

#
class Egi::Fedcloud::Cloudhound::Formatter

  class << self
    #
    def as_table(data = {})
      # TODO: use terminal-table
      Egi::Fedcloud::Cloudhound::Log.debug "[#{self}] Transforming #{data.inspect} into a table"
      data.to_s
    end
  end

end
