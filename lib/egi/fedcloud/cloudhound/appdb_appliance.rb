#
class Egi::Fedcloud::Cloudhound::AppdbAppliance

  attr_reader :identifier, :version, :url,
              :checksum, :format, :owner,
              :published, :mpuri
  attr_reader :vos, :sites

  #
  def initialize(element)
    Egi::Fedcloud::Cloudhound::Log.debug "[#{self.class}] Initializing with #{element.inspect}"

    @identifier = element['identifier']
    @version = element['version']
    @url = element['url']
    @checksum = element['checksum']
    @format = element['format']
    @owner = element['addedby']['permalink']
    @published = element['published']
    @mpuri = element['mpuri']

    @vos = element['vo'].collect { |vo| vo['name'] }
    @sites = element['sites'].collect do |site|
      st = {}
      st['name'] = site['name']
      st['gocdb_link'] = site['url']['portal']
      st
    end
  end

end
