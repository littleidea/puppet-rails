define rails::site($path, $servername = $fqdn, $rails_version) {
    include ruby
    include gems
    include apache2
    include passenger
    include mysql
    mysql::database { ["${name}_test", "${name}_production", "${name}_development"]:
        ensure => present 
    }
        
    include ruby::mysql

    rails::setup { $name: version => $rails_version}

    rails::install { $name:
        path => $path,
        servername => $servername
    }
}
