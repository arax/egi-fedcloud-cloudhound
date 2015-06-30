require 'ox'

#
class Egi::Fedcloud::Cloudhound::Gocdb < Egi::Fedcloud::Cloudhound::Connector

  GOCDB_SERVICE_ENDPOINT = '/gocdbpi/public/?method=get_service_endpoint'
  GOCDB_SITES_URL = '/gocdbpi/private/?method=get_site'
  GOCDB_PROD_SITES_URL = "#{GOCDB_SITES_URL}&production_status=Production"
  GOCDB_CERT_PROD_SITES_URL = "#{GOCDB_PROD_SITES_URL}&certification_status=Certified"

  CLOUD_SERVICE_TYPES = [
    "eu.egi.cloud.vm-management.occi",
    "eu.egi.cloud.storage-management.cdmi",
#    "eu.egi.cloud.accounting",
#    "eu.egi.cloud.information.bdii",
    "eu.egi.cloud.vm.metadata-vmcatcher",
  ]

  #
  def initialize(opts = {}, password = nil)
    super
    Egi::Fedcloud::Cloudhound::Log.debug "[#{self.class}] With GOCDB instance at #{opts[:gocdb_base_url].inspect}"
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

  #
  def cloud_sites
    sites.select { |site| cloud_site_names.include?(site.name) }
  end

  #
  def production_cloud_sites
    production_sites.select { |site| cloud_site_names.include?(site.name) }
  end

  #
  def certified_production_cloud_sites
    certified_production_sites.select { |site| cloud_site_names.include?(site.name) }
  end

  private

  #
  def get_and_parse(url, type)
    return instance_variable_get("@cached_#{type}") if instance_variable_defined?("@cached_#{type}")

    Egi::Fedcloud::Cloudhound::Log.debug "[#{self.class}] Pulling site data from #{url.inspect}"
    results = Ox.parse retrieve(url)
    results = results.locate('results/*').map { |site| Egi::Fedcloud::Cloudhound::GocdbSite.new(site) }
    instance_variable_set("@cached_#{type}", results)

    results
  end

  #
  def cloud_site_names
    return @cached_cloud_site_names if instance_variable_defined?('@cached_cloud_site_names')
    site_names = Set.new

    Egi::Fedcloud::Cloudhound::Log.debug "[#{self.class}] Pulling service endpoints from #{GOCDB_SERVICE_ENDPOINT.inspect}"
    xmldoc_service_endpoints = Ox.parse retrieve(GOCDB_SERVICE_ENDPOINT)
    xmldoc_service_endpoints.locate("results/*").each do |service_endpoint|
      service_endpoint.locate("SERVICE_TYPE").each do |service_type|
        next unless service_type && CLOUD_SERVICE_TYPES.include?(service_type.text)
        service_endpoint.locate("SITENAME").each { |service_site_name| site_names << service_site_name.text }
      end
    end
    instance_variable_set('@cached_cloud_site_names', site_names.to_a)

    @cached_cloud_site_names
  end
end
