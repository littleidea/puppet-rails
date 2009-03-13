define rails::site($servername = $fqdn, $rails_version) {
    include ruby
    include gems
    include apache2
    passenger::enable{ passenger: version => "2.0.6" }

    include mysql
    mysql::database { ["${name}_test", "${name}_production", "${name}_development"]:
        ensure => present
    }

    include ruby::mysql

    rails::setup { $name:
        version => $rails_version,
        require => Class['gems']
    }

    rails::install { $name:
        servername => $servername,
        servername => $servername,
        require => [Package['rails'], Exec["Mysql: create ${name}_production db"], Exec["Mysql: create ${name}_test db"], Exec["Mysql: create ${name}_development db"]]
    }
}
