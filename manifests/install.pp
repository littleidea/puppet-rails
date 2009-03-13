define rails::install($servername) {
    file{ "/var/rails":
          ensure => directory,
          owner => root,
          group => www-data,
          mode => 775
    }

    # Create the system
    exec { "Create $name rails site":
        command => "/usr/bin/rails $name",
        cwd => "/var/rails",
        user => www-data,
        creates => "/var/rails/$name/config",
        alias => rails-create,
        require => File['/var/www']
    }

    # Now create the db config
    file { "/var/rails/$name/config/database.yml":
        content => template("rails/dbconfig.erb"),
        require => Exec['rails-create']
    }

    file { "/etc/apache2/sites-available/$name":
        content => template("rails/vhost.erb"),
        require => Package['apache2'],
        alias => vhost
    }

    apache2::site{ $name:
        ensure => present,
        require => File['vhost']
    }
}
