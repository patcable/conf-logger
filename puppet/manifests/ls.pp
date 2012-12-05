# Puppet Configuration for ConfLog

class { 'logstash::config':

  logstash_home          => '/opt/logstash',
  logstash_jar_provider  => 'http',             # pull down the jar over http
  logstash_transport     => 'none',            # configure redis as the transport
  elasticsearch_provider => 'embedded',         # we'll run ES inside out logstash JVM
  java_provider          => 'package',          # install java for me please, from a package
  java_package           => 'openjdk-6-jdk',    # package name on this platform
  java_home              => '/usr/lib/jvm/java-6-openjdk-amd64',
                                                # JAVA_HOME for your chosen JDK
}
class { 'logstash::standalone': }
