conf-logger
===========

Monitors an IRC channel and twitter hashtag for conference-related information on a single instance.

instructions
------------
* clone the puppet subdirectory into /etc/puppet
* create appropriate hiera data in /etc/puppet/hieradata for ircserv, ircchan, ircnick, twtags, twuser, twpass
* puppet apply /etc/puppet/manifests/ls.pp

You'll need to set up Kibana on your own -- for now.

known bugs
----------
Hope you have no desire to join more than one channel or follow more than one hashtag.

credits
-------
I've added another class to the already excellent Logstash module created by Simon McCartney over at https://github.com/simonmcc/puppet-logstash
