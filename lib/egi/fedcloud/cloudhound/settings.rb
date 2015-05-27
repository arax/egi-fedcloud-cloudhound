require 'settingslogic'

#
class Egi::Fedcloud::Cloudhound::Settings < Settingslogic
  GEM_ROOT = File.expand_path '../../../../..', __FILE__

  source "#{ENV['HOME']}/.egi-fedcloud-cloudhound" if File.readable?("#{ENV['HOME']}/.egi-fedcloud-cloudhound")
  source "#{GEM_ROOT}/config/settings.yml"

  namespace ((ENV['DEBUG'] == '1') ? 'development' : 'production')
end
