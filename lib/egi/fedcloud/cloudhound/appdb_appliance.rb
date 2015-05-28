#
class Egi::Fedcloud::Cloudhound::AppdbAppliance

  attr_reader :identifier, :version, :url,
              :checksum, :format, :owner,
              :published, :mpuri
  attr_reader :sites

  #
  def initialize(element)
    Egi::Fedcloud::Cloudhound::Log.debug "[#{self.class}] Initializing with #{element.inspect}"

    @identifier = element['identifier']
    @version = element['version']
    @url = element['url']
    @checksum = element['checksum']
    @format = element['format']
    @owner = element['addedby'] ? element['addedby']['permalink'] : 'unknown'
    @published = element['published']
    @mpuri = element['mpuri']

    # and now the difficult part
    @sites = self.class.extract_sites(element['sites'])
  end

  class << self
    #
    def extract_sites(element)
      return [] if element.blank?

      element.collect do |site|
        st = {}
        st['name'] = site['name']
        st['gocdb_link'] = site['url'] ? site['url']['portal'] : 'unknown'
        st['vos'] = extract_site_vos(site['services'])
        st
      end
    end

    #
    def extract_site_vos(element)
      return [] if element.blank?

      vos = []
      element.each do |service|
        vos << service['vos'].collect { |vo| vo['name'] }
      end
      vos.flatten!
      vos.compact!
      vos.uniq!

      vos
    end
  end

end
