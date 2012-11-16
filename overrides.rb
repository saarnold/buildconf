# Write in this file customization code that will get executed after all the
# soures have beenloaded.

# Uncomment to reenable building the RTT test suite
# This is disabled by default as it requires a lot of time and memory
#
# Autobuild::Package['rtt'].define "BUILD_TESTING", "ON"

# Package specific prefix:
# Autobuild::Package['rtt'].prefix='/opt/autoproj/2.0'
#
# See config.yml to set the prefix:/opt/autoproj/2.0 globally for all packages.


Autoproj.env_set 'TARGET', 'i386-rtems'
Autoproj.env_set 'BSP', 'pc486'

Autoproj.prefix = File.join("install",ENV['TARGET'])


Autobuild::Package.each do |pkg_name, pkg|
#Autoproj.manifest.each_package do |pkg|
    pkg.builddir = "build-#{ENV['TARGET']}" if pkg.kind_of?(Autobuild::Configurable)
end





