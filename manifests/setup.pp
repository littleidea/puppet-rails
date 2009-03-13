define rails::setup ($version = "2.2.2") {
    include gems
    package{ rails: ensure => $version, require => Class['gems']}
}
