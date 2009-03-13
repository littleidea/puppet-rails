define rails::install($path, $servername) {
    # Create the system
    exec { "Create $name rails site":
        command => "/usr/bin/rails --database $dbtype $path",
        creates => "$path/config"
        alias => rails-create
    }

    # Now create the db config
    file { "$path/config/database.yml":
        content => template("rails/dbconfig.erb"),
        require => Exec['rails-create']
    }

    file { "/etc/apache2/sites-available/$name":
        content => template("rails/vhost.erb"),
        require => Class['apache2']
        alias => vhost
    }

    apache2::site{ $name:
        ensure => present,
        require => File['vhost']
    }
}
