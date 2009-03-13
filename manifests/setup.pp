define rails::setup ($version = "2.2.2") {
    package{ rails: ensure => $version
             provider => gem
    }
}
