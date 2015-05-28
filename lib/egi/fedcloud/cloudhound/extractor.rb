require 'ipaddr'

#
class Egi::Fedcloud::Cloudhound::Extractor

  LOOKUP_ORDER = %w(certified_production_sites production_sites sites)

  class << self

    def init(options)
      @@gocdb ||= Egi::Fedcloud::Cloudhound::Gocdb.new(options)
      @@appdb ||= Egi::Fedcloud::Cloudhound::Appdb.new(options)
    end

    #
    def find_by_ip(ip, options = {})
      init options

      Egi::Fedcloud::Cloudhound::Log.debug "[#{self}] Searching for contacts by IP: #{ip.inspect}"
      found = []
      LOOKUP_ORDER.each do |lookup_type|
        found << @@gocdb.send(lookup_type).select { |site| site.in_range?(ip) }
        found.flatten!
        found.compact!

        Egi::Fedcloud::Cloudhound::Log.debug "[#{self}] Found #{found.inspect} in #{lookup_type.inspect}"
        break unless found.blank?
      end

      found.collect { |site| site.contacts }
    end

    #
    def find_by_appuri(uri, options = {})
      init options

      Egi::Fedcloud::Cloudhound::Log.debug "[#{self}] Searching for contacts by MPURI: #{uri.inspect}"
      sites = @@appdb.appliance(uri).sites.collect { |site| site['name'] }

      Egi::Fedcloud::Cloudhound::Log.debug "[#{self}] Querying #{sites.inspect} for contact details"
      found = []
      sites.each do |affected_site|
        LOOKUP_ORDER.each do |lookup_type|
          found << @@gocdb.send(lookup_type).select { |site| site.name == affected_site }
          found.flatten!
          found.compact!

          Egi::Fedcloud::Cloudhound::Log.debug "[#{self}] Found #{found.inspect} in #{lookup_type.inspect}"
          break unless found.blank?
        end
      end

      found.collect { |site| site.contacts }
    end
  end

end
