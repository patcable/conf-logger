# = Class: logstash::redis
#
# Manage installation & configuration of a redis server (to be used by logstash)
#
# == Parameters:
#
# $param::   description of parameter. default value if any.
#
# == Actions:
#
# Describe what this class does. What gets configured and how.
#
# == Requires:
#
# Requirements. This could be packages that should be made available.
#
# == Sample Usage:
#
# == Todo:
#
# * Update documentation
# * Add support for other ways providing redis?
#
class logstash::redis (
) {

  # make sure the logstash::config class is declared before logstash::server
  Class['logstash::config'] -> Class['logstash::redis']

  if $logstash::config::redis_provider == 'package' {

    # build a package-version if we need to
    $redis_package = $logstash::config::redis_version ? {
      /\d+./  => "${logstash::config::redis_package}-${logstash::config::redis_version}",
      default => $logstash::config::redis_package,
    }

    package { $redis_package:
      ensure => present,
    }

    # where is the redis config file?
    $redis_conf = $operatingsystem ? {
      ubuntu => '/etc/redis/redis.conf',
      centos => '/etc/redis.conf',
      redhat => '/etc/redis.conf',
      default => undef,
    }

    # our redis config file
    file { "$redis_conf":
      ensure  => present,
      content => template('logstash/redis.conf.erb'),
      require => Package[$redis_package],
    }

    # What's the service name on this platform?
    $redis_service = $operatingsystem ? {
      ubuntu => 'redis-server',
      centos => 'redis',
      redhat => 'redis',
      default => undef,
    }
    # make sure the service is defined & running
    service { "$redis_service":
      ensure    => 'running',
      hasstatus => true,
      enable    => true,
      subscribe => File[$redis_conf],
      require   => File[$redis_conf],
    }
  }
}

