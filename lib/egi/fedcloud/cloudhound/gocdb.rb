require 'ox'

#
class Egi::Fedcloud::Cloudhound::Gocdb < Egi::Fedcloud::Cloudhound::Connector

  GOCDB_SITES_URL = '/gocdbpi/private/?method=get_site'
  GOCDB_PROD_SITES_URL = "#{GOCDB_SITES_URL}&production_status=Production"
  GOCDB_CERT_PROD_SITES_URL = "#{GOCDB_PROD_SITES_URL}&certification_status=Certified"

  CLOUD_SERVICE_TYPES = [
    "eu.egi.cloud.vm-management.occi",
    "eu.egi.cloud.storage-management.cdmi",
    "eu.egi.cloud.accounting",
    "eu.egi.cloud.information.bdii",
    "eu.egi.cloud.vm.metadata-vmcatcher",
  ]

  #
  def initialize(opts = {})
    super
    self.class.base_uri opts[:gocdb_base_url]
  end

  #
  def sites
    get_and_parse GOCDB_SITES_URL, 'sites'
  end

  #
  def production_sites
    get_and_parse GOCDB_PROD_SITES_URL, 'prod_sites'
  end

  #
  def certified_production_sites
    get_and_parse GOCDB_CERT_PROD_SITES_URL, 'cert_prod_sites'
  end

  private

  #
  def get_and_parse(url, type)
    return instance_variable_get("@cached_#{type}") if instance_variable_defined?("@cached_#{type}")

    results = Ox.parse retrieve(url)
    results = results.locate('results/*').map { |site| Egi::Fedcloud::Cloudhound::GocdbSite.new(site) }
    instance_variable_set("@cached_#{type}", results)

    results
  end
end
