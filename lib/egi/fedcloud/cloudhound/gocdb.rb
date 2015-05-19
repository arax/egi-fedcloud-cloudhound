require 'ox'

#
class Egi::Fedcloud::Cloudhound::Gocdb < Egi::Fedcloud::Cloudhound::Connector

  #
  def initialize(opts = {})
    super
    self.class.base_uri opts[:gocdb_base_url]
  end
end
