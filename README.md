[![Build Status](https://secure.travis-ci.org/arax/egi-fedcloud-cloudhound.png)](http://travis-ci.org/arax/egi-fedcloud-cloudhound)
[![Dependency Status](https://gemnasium.com/arax/egi-fedcloud-cloudhound.png)](https://gemnasium.com/arax/egi-fedcloud-cloudhound)
[![Gem Version](https://fury-badge.herokuapp.com/rb/egi-fedcloud-cloudhound.png)](https://badge.fury.io/rb/egi-fedcloud-cloudhound)
[![Code Climate](https://codeclimate.com/github/arax/egi-fedcloud-cloudhound.png)](https://codeclimate.com/github/arax/egi-fedcloud-cloudhound)

# EGI FedCloud CloudHound

A proof-of-concept utility for locating cloud sites and corresponding CSIRT/CERT contacts in EGI Federated Cloud.

## Installation
### Dependencies
* __Debian-based__
```bash
$ sudo apt-get install ruby ruby-dev libxml2 build-essential
```
* __RHEL-based__
```bash
$ sudo yum install ruby ruby-devel libxml2
```

### From RubyGems.org
```bash
$ gem install egi-fedcloud-cloudhound
$ egi-fedcloud-cloudhound --help
```

### From Source
```bash
$ git clone https://github.com/arax/egi-fedcloud-cloudhound.git
$ cd egi-fedcloud-cloudhound
$ gem install bundler
$ bundle install
$ bundle exec bin/egi-fedcloud-cloudhound --help
```

## Usage
```bash
$ egi-fedcloud-cloudhound help
Commands:
  egi-fedcloud-cloudhound all             # Prints information for all available cloud sites
  egi-fedcloud-cloudhound appuri URI      # Prints information based on the provided Appliance MPURI
  egi-fedcloud-cloudhound help [COMMAND]  # Describe available commands or one specific command
  egi-fedcloud-cloudhound ip IP_ADDRESS   # Prints information based on the provided IP address or IP address range
```

```bash
$ egi-fedcloud-cloudhound help all

$ egi-fedcloud-cloudhound all
$ egi-fedcloud-cloudhound all --format=plain
$ egi-fedcloud-cloudhound all --format=json
```

```bash
$ egi-fedcloud-cloudhound help appuri

$ MPURI="https://appdb.egi.eu/store/vo/image/ac34bc96-4d78-583a-b73b-a9102aeec206:403/"
$ egi-fedcloud-cloudhound appuri $MPURI
$ egi-fedcloud-cloudhound appuri $MPURI --format=plain
$ egi-fedcloud-cloudhound appuri $MPURI --format=json
```

```bash
$ egi-fedcloud-cloudhound help ip

$ IP_ADDRESS="192.168.5.0/24" # range or host IP
$ egi-fedcloud-cloudhound ip $IP_ADDRESS
$ egi-fedcloud-cloudhound ip $IP_ADDRESS --format=plain
$ egi-fedcloud-cloudhound ip $IP_ADDRESS --format=json
```

## Contributing

1. Fork it ( https://github.com/arax/egi-fedcloud-cloudhound/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
