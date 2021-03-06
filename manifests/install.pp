# == Class bmcremote::install
#
# This class is called from bmcremote for install.
#
class bmcremote::install (
  ) inherits bmcremote::params {

  # directory to hold the created scripts
  file { "/usr/local/bmcremote":
    ensure => "directory",
    owner  => "root",
    group  => "root",
    mode   => 750,
  }


  case $::osfamily {

    'RedHat' : {

      package { $::bmcremote::package_names:
          ensure => present,
      }

      ########################################
      # Create the repo
      ########################################
      yumrepo { 'dell-omsa-indep':
        descr          => 'Dell OMSA repository - Hardware     independent',
        enabled        => 1,
        mirrorlist     => $bmcremote::params::repo_indep_mirrorlist,
        gpgcheck       => 1,
        gpgkey         => $bmcremote::params::repo_indep_gpgkey,
        failovermethod => 'priority',
#        require        => Package['dell-omsa-repository'],
      }


      ########################################
      # GPG-KEY Management
      ########################################
      file { '/etc/pki/rpm-gpg/RPM-GPG-KEY-dell':
        ensure => 'present',
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
        source => 'puppet:///modules/bmcremote/RPM-GPG-KEY-dell',
      }
      exec { 'dell-RPM-GPG-KEY-dell':
        command     => '/bin/rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-dell',
        subscribe   => File['/etc/pki/rpm-gpg/RPM-GPG-KEY-dell'],
        refreshonly => true,
      }

    }
  }
}
