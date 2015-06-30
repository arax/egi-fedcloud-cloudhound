require 'terminal-table'

#
class Egi::Fedcloud::Cloudhound::Formatter

  FORMATS = %w(table json plain).freeze

  class << self
    #
    def as_table(data = [])
      Egi::Fedcloud::Cloudhound::Log.debug "[#{self}] Transforming #{data.inspect} into a table"

      data ||= []
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
      Egi::Fedcloud::Cloudhound::Log.debug "[#{self}] Transforming #{data.inspect} into a JSON document"
      return '{}' if data.blank?

      JSON.generate(data)
    end

    #
    def as_plain(data = [])
      Egi::Fedcloud::Cloudhound::Log.debug "[#{self}] Transforming #{data.inspect} into plain text"
      return '' if data.blank?

      plain = []
      data.each do |site|
        Egi::Fedcloud::Cloudhound::Log.warn "[#{self}] #{site[:name]} doesn't " \
                                            "have a CSIRT e-mail!" if site[:csirt].blank?
        next if site[:csirt].blank?
        plain << "#{site[:name]} <#{site[:csirt]}>"
      end

      plain.join ', '
    end
  end

end
