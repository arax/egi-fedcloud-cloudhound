require 'httparty'
require 'highline/import'

#
class Egi::Fedcloud::Cloudhound::Connector
  include HTTParty

  #
  def initialize(opts = {})
    self.class.pem File.read(opts[:credentials]), opts[:password]
    self.class.ssl_ca_path opts[:ca_path]
    self.class.debug_output $stderr if opts[:debug]
  end

  #
  def retrieve(url = '/')
    response = self.class.get url
    raise "Failed to get a response from '#{url}' [#{response.code}]" unless response.code.between?(200,299)

    response.body
  end
end
