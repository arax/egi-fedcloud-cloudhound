require 'terminal-table'

#
class Egi::Fedcloud::Cloudhound::Formatter

  class << self
    #
    def as_table(data = {})
      # TODO: use terminal-table
      data.to_s
    end
  end

end
