require 'terminal-table'

#
class Egi::Fedcloud::Cloudhound::Formatter

  class << self
    #
    def as_table(data = [])
      # TODO: use terminal-table
      Egi::Fedcloud::Cloudhound::Log.debug "[#{self}] Transforming #{data.inspect} into a table"
      table = Terminal::Table.new

      table.add_row [' >>> Site Name <<< ', ' >>> NGI Name <<< ', ' >>> CSIRT Contact(s) <<< ']
      table.add_separator
      data.each do |site|
        table.add_separator
        table.add_row [site[:name], site[:ngi], site[:csirt]]
      end

      table
    end

    #
    def as_json(data = [])
      data ? JSON.generate(data) : '{}'
    end
  end

end
