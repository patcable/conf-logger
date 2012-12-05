#puppet-logstash#

* Simple puppet logstash module, tries to take care of making sure redis &
elasticsearch are available.
* Supports grabbing logstash jar directly (jar's are packages right?  we just don't support them natively yet :-))
* aimed at logstash-1.1 or newer, with simple redis setup
* templated init scripts for all java daemons (based on work by Josh Davis/Christian d'Heureuse)

##Usage##

Declare a config class that is used by the working classes:

```puppet
  # this example is enough for CentOS 5
  class { 'logstash::config':
    logstash_home => '/opt/logstash',
    logstash_jar_provider => 'http',
    logstash_transport => 'redis',
    redis_provider     => 'package',
  }
  # there is a redis RPM here:
  yumrepo { 'yum.mccartney.ie':
    baseurl  => 'http://yum.mccartney.ie',
    descr    => 'redis for el',
    gpgcheck => 0,
  }
```
Then just apply the required classes to each node:
```puppet
  # indexer/storage node
  class { 'logstash::indexer': }
  # use this class to provide transport that matches what we want, optional
  class { 'logstash::redis': }
  
  # straight log shipper only
  class { 'logstash::shipper': }

  # web interface
  class { 'logstash::web': }
```


###Sample config for Ubuntu Precise (12.04)
```puppet
lass { 'logstash::config':
  logstash_home          => '/opt/logstash',
  logstash_jar_provider  => 'http',             # pull down the jar over http
  logstash_transport     => 'redis',            # configure redis as the transport
  redis_provider         => 'package',          # install redis from native package please
  redis_package          => 'redis-server',     # package name for this platform
  redis_version          => '',                 # package-version doesn't work with apt/deb
  elasticsearch_provider => 'embedded',         # we'll run ES inside out logstash JVM
  java_provider          => 'package',          # install java for me please, from a package
  java_package           => 'openjdk-6-jdk',    # package name on this platform
  java_home              => '/usr/lib/jvm/java-6-openjdk-amd64',
                                                # JAVA_HOME for your chosen JDK
}
```
##Configuration Detail##

Many of the configuration defaults come from the original behaviour of Kris Buytaert's original module, which this started out as a fork of.



#Credit#
Based on lots of original work by Kris Buytaert & Joe McDonagh 
https://github.com/KrisBuytaert/puppet-logstash
https://github.com/thesilentpenguin/puppet-logstash

