require 'ox'

#
class Egi::Fedcloud::Cloudhound::Appdb < Egi::Fedcloud::Cloudhound::Connector

  APPDB_SITES_URL = '/rest/1.0/sites?flt=+=&site.supports:1'

  #
  def initialize(opts = {})
    super
    @appdb_base_url = opts[:appdb_base_url].chomp '/'
  end

  #
  def sites
    @cached_sites if @cached_sites

    sites = Ox.parse retrieve("#{@appdb_base_url}#{APPDB_SITES_URL}")
    @cached_sites = sites.locate('appdb/*').map { |site| Egi::Fedcloud::Cloudhound::AppdbSite.new(site) }
  end

  #
  def production_sites
    sites.select { |site| site.infrastructure == 'Production' }
  end

  #
  def certified_production_sites
    production_sites.select { |site| site.status == 'Certified' }
  end

  #
  def cloud_sites
    sites.select { |site| site.type == 'cloud' }
  end

  #
  def production_cloud_sites
    cloud_sites.select { |site| site.infrastructure == 'Production' }
  end

  #
  def certified_production_cloud_sites
    production_cloud_sites.select { |site| site.status == 'Certified' }
  end

  #
  def appliance(uri)
    raw_appliance = JSON.parse retrieve("#{uri}/json")
    Egi::Fedcloud::Cloudhound::AppdbAppliance.new raw_appliance
  end

  #
  def site_gocdb(site_name)
    found = sites.select { |site| site.name == site_name }
    found.first ? found.first.gocdb_link : nil
  end
end
