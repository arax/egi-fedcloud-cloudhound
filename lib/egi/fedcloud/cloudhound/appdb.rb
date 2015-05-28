require 'ox'

#
class Egi::Fedcloud::Cloudhound::Appdb < Egi::Fedcloud::Cloudhound::Connector

  APPDB_SITES_URL = '/rest/1.0/sites?flt=+=&site.supports:1'

  #
  def initialize(opts = {})
    super
    Egi::Fedcloud::Cloudhound::Log.debug "[#{self.class}] With AppDB instance at #{opts[:appdb_base_url].inspect}"
    @appdb_base_url = opts[:appdb_base_url].chomp '/'
  end

  #
  def sites
    return @cached_sites if @cached_sites

    Egi::Fedcloud::Cloudhound::Log.debug "[#{self.class}] Pulling site data from \"#{@appdb_base_url}#{APPDB_SITES_URL}\""
    sites = Ox.parse retrieve("#{@appdb_base_url}#{APPDB_SITES_URL}")
    @cached_sites = sites.locate('appdb/*').map { |site| Egi::Fedcloud::Cloudhound::AppdbSite.new(site) }
  end

  #
  def production_sites
    production sites
  end

  #
  def certified_production_sites
    certified production_sites
  end

  #
  def cloud_sites
    sites.select { |site| site.type == 'cloud' }
  end

  #
  def production_cloud_sites
    production cloud_sites
  end

  #
  def certified_production_cloud_sites
    certified production_cloud_sites
  end

  #
  def appliance(uri)
    Egi::Fedcloud::Cloudhound::Log.debug "[#{self.class}] Pulling appliance data from \"#{uri}/json\""
    raw_appliance = JSON.parse retrieve("#{uri}/json")
    Egi::Fedcloud::Cloudhound::AppdbAppliance.new raw_appliance
  end

  #
  def site_gocdb(site_name)
    found = sites.select { |site| site.name == site_name }
    found.first ? found.first.gocdb_link : nil
  end

  private

  def production(sites)
    sites.select { |site| site.infrastructure == 'Production' }
  end

  def certified(sites)
    sites.select { |site| site.status == 'Certified' }
  end
end
