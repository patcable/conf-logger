# = Class: logstash
#
# Manage installation & configuration of logstash.
# Everything is done in sub-classes.
# (lets call this the lazy monarch?)
#
# == Parameters:
#
# None.
#
# == Actions:
#
# None - all of the work is done by the 'public' sub-classes
#
# logstash::config
# logstash::indexer
# logstash::shipper
# logstash::web
#
# == Requires:
#
# working java implementation
#
# == Sample Usage:
#
# declare a config class:
#  class { 'logstash::config':
#    logstash_home         => '/opt/logstash',
#    logstash_jar_provider => 'http',
#    logstash_transport    => 'redis',
#    redis_provider        => 'package',
#  }
#
#  Then apply a worker class to a given node
#
#  node myindexer { class { 'logstash::indexer': } }
#  node ashippingnode { class { 'logstash::shipper': } }
#  node mywebbox { class { 'logstash::web': }
#
# == Todo:
#
# * Update documentation
# * add proper logstash config file fragment support
# * and lots more I'm sure.
#
class logstash { }
