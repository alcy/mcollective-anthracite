mcollective-anthracite
======================

Audit plugin for [mcollective](http://docs.puppetlabs.com/mcollective/simplerpc/auditing.html) to send audit logs to [anthracite](https://github.com/Dieterbe/anthracite)  
Configuration:   
plugin.rpcaudit.anthracite\_host ( default: localhost )  
plugin.rpcaudit.anthracite\_port ( default: 8081 )  
plugin.rpcaudit.anthacite\_open\_timeout (default: 5s)  
plugin.rpcaudit.anthracite\_read\_timeout (default: 5s)  

The timeout params are same as ruby's net/http params. 
