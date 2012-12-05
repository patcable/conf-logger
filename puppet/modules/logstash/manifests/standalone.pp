# = Class: logstash::shipper
#
# Description of logstash::shipper
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
#
class logstash::standalone (
  $ircchan = hiera("ircchan"),
  $ircserv = hiera("ircserv"),
  $ircnick = hiera("ircnick"),
  $ircport = hiera("ircport"),
  $twtags = hiera("twtags"),
  $twuser = hiera("twuser"),
  $twpass = hiera("twpass"),
  $logstash_server ='localhost',
  $verbose = 'no',
  $jarname ='logstash-1.1.0-monolithic.jar',
) {

  # make sure the logstash::config & logstash::package classes are declared before logstash::shipper
  Class['logstash::config'] -> Class['logstash::standalone']
  Class['logstash::package'] -> Class['logstash::standalone']

  # create the config file based on the transport we are using (this could also be extended to use different configs)
  case  $logstash::config::logstash_transport {
    /^none$/:  { $shipper_conf_content = template('logstash/standalone-input.conf.erb',
                                                  'logstash/standalone-filter.conf.erb',
                                                  'logstash/standalone-output.conf.erb') }
    default:   { $shipper_conf_content = undef }
  }


  file {'/etc/logstash/standalone.conf':
    ensure  => 'file',
    group   => '0',
    mode    => '0644',
    owner   => '0',
    content => $shipper_conf_content
  }

  # make sure the logstash::config class is declared before logstash::indexer
  Class['logstash::config'] -> Class['logstash::standalone']

  User  <| tag == 'logstash' |>
  Group <| tag == 'logstash' |>

  # startup script
  logstash::javainitscript { 'logstash-standalone':
    serviceuser    => 'root',
    servicegroup   => 'root',
    servicehome    => $logstash::config::logstash_home,
    servicelogfile => "$logstash::config::logstash_log/standalone.log",
    servicejar     => $logstash::package::jar,
    serviceargs    => " agent -f /etc/logstash/standalone.conf -l $logstash::config::logstash_log/standalone.log",
    java_home      => $logstash::config::java_home,
  }

  service { 'logstash-standalone':
    ensure    => 'running',
    hasstatus => true,
    enable    => true,
    require   => Logstash::Javainitscript['logstash-standalone'],
  }

}

