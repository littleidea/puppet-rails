define rails::install($servername) {
    file{ "/var/www":
          ensure => directory,
          owner => root,
          group => www-date,
          mode => 775
    }

    # Create the system
    exec { "Create $name rails site":
        command => "/usr/bin/rails $name",
        cwd => "/var/rails",
        user => www-data,
        creates => "/var/rails/$name/config",
        alias => rails-create
    }

    # Now create the db config
    file { "/var/rails/$name/config/database.yml":
        content => template("rails/dbconfig.erb"),
        require => Exec['rails-create']
    }

    file { "/etc/apache2/sites-available/$name":
        content => template("rails/vhost.erb"),
        require => Class['apache2'],
        alias => vhost
    }

    apache2::site{ $name:
        ensure => present,
        require => File['vhost']
    }
}
