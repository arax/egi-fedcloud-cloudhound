require 'ox'

#
class Egi::Fedcloud::Cloudhound::Appdb < Egi::Fedcloud::Cloudhound::Connector

  #
  def initialize(opts = {})
    super
    self.class.base_uri opts[:appdb_base_url]
  end
end
