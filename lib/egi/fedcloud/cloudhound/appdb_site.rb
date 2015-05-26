#
class Egi::Fedcloud::Cloudhound::AppdbSite

  attr_reader :type, :name, :gocdb_link, :status, :infrastructure
  attr_reader :services

  #
  def initialize(element)
    @services = self.extract_services(element)
    @gocdb_link = self.extract_gocdb_link(element)
    @name = element.name
    @type = @services.empty? ? 'grid' : 'cloud'
    @status = element.status
    @infrastructure = element.infrastructure
  end

  class << self

    #
    def extract_services(element)
      services = (element.locate('service') || [])
      services.map { |service| "#{service.type} -- #{service.host}" }
    end

    #
    def extract_gocdb_link(element)
      urls = (element.locate('url') || [])
      portals = urls.select { |url| url.text && url.type('portal') }
      portals.first ? portals.first.text : nil
    end

  end

end
