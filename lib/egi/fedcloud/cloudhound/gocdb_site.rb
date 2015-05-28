require 'ipaddr'

#
class Egi::Fedcloud::Cloudhound::GocdbSite

  INVALID_RANGES = %w(255.255.255.255/0.0.0.0 0.0.0.0/0.0.0.0)

  attr_reader :name, :csirt_email, :contact_email, :ngi, :ip_ranges

  #
  def initialize(element)
    Egi::Fedcloud::Cloudhound::Log.debug "[#{self.class}] Initializing with #{element.inspect}"
    @name = self.class.extract_text(element.locate('SHORT_NAME'))
    @csirt_email = self.class.extract_text(element.locate('CSIRT_EMAIL'))
    @contact_email = self.class.extract_text(element.locate('CONTACT_EMAIL'))
    @ngi = self.class.extract_text(element.locate('ROC'))

    Egi::Fedcloud::Cloudhound::Log.debug "[#{self.class}] Extracting IP ranges for site #{@name}"
    @ip_ranges = self.class.extract_ranges(self.class.extract_text(element.locate('SITE_IP')))
  end

  #
  def in_range?(ip)
    ip = ip.to_s if ip.kind_of?(IPAddr)

    Egi::Fedcloud::Cloudhound::Log.debug "[#{self.class}] Checking #{ip.inspect} against #{name}'s ranges"
    ip_ranges.each do |my_range|
      Egi::Fedcloud::Cloudhound::Log.debug "[#{self.class}] -- #{my_range.inspect}"
      return true if my_range.include?(ip)
    end
    false
  end

  class << self
    #
    def extract_ranges(text_ranges)
      ranges = text_ranges.split(/[,;]/).reject { |el| el.blank? || !el.include?('/') || INVALID_RANGES.include?(el) }

      Egi::Fedcloud::Cloudhound::Log.debug "[#{self}] -- Ranges: #{ranges.inspect}"
      ranges.map! do |range|
        begin
          IPAddr.new(range)
        rescue
          Egi::Fedcloud::Cloudhound::Log.warn "[#{self}] -- Invalid range #{range.inspect}"
          nil
        end
      end
      ranges.compact!

      ranges
    end

    #
    def extract_text(element)
      (element && element.first) ? element.first.text : ''
    end
  end

end
