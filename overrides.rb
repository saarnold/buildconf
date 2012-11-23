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

host_exclude = Array.new


Autoproj.env_set 'HOSTSYSTEM', 'x86_64-linux-gnu'

if not ENV['HOSTBUILD'] == "true" 
    Autoproj.env_set 'TARGET', 'i386-rtems'
    Autoproj.env_set 'BSP', 'pc486'
    Autoproj.env_set 'OROCOS_TARGET', 'rtems'
    host_exclude = "tools/service_discovery","rtt","logger","tools/logger"
else
    Autoproj.env_set 'OROCOS_TARGET', 'gnulinux' #todo handle this better?
    Autoproj.env_set 'TARGET', ENV['HOSTSYSTEM']
    host_exclude = "external/binutils","external/gcc","external/gdb","external/rtems","external/newlib","external/boost","external/omniorb","external/xerces","external/libxml"
end

Autoproj.env_add "RUBYLIB","/home/goldhoorn/limes/clean-rock-rtems/install/x86_64-linux-gnu/lib/ruby/1.8/x86_64-linux/" #TODO

Autoproj.prefix = File.join("install",ENV['TARGET'])

STDOUT.puts "Building for target #{ENV['TARGET']} and OROCOS_TARGET #{ENV['OROCOS_TARGET']}"
#raise if ENV['OROCOS_TARGET'] != "rtems"

host_exclude.each do |pkg|
    #Autoproj::Manifest.ignore_package(pkg)
    Autoproj.manifest.ignore_package(pkg)
end

Autobuild::Package.each do |pkg_name, pkg|
#Autoproj.manifest.each_package do |pkg|
    pkg.builddir = "build-#{ENV['TARGET']}" if pkg.kind_of?(Autobuild::Configurable)
    if not ENV['HOSTBUILD'] == "true"
        if pkg.kind_of?(Autobuild::CMake) and pkg_name != "rtt"
            pkg.define("CMAKE_TOOLCHAIN_FILE",File.join(Autoproj.root_dir,"base","types","cmake","FindRTEMS.cmake"))
            pkg.define("RTEMS_INSTALL_DIR",File.join(Autoproj.root_dir,Autoproj.prefix))
            foo="-L#{File.join(Autoproj.root_dir,Autoproj.prefix,"lib")}"
            pkg.define("ADD_CFLAGS",foo)
        end
        if pkg_name == "rtt" or pkg_name == "tools/rtt"
            foo="-L#{File.join(Autoproj.root_dir,Autoproj.prefix,"lib","typelib")} -lomniConnectionMgmt4 -lomniCodeSets4 -lomniORB4 -lomniDynamic4 -lomnithread -lboost_filesystem"
            #foo="-L#{File.join(Autoproj.root_dir,Autoproj.prefix,"lib","typelib")}"
            pkg.define("ADD_CFLAGS",foo)
            pkg.define("CORBA_IMPLEMENTATION","OMNIORB")
            pkg.define("ENABLE_CORBA","ON")
        end
        if pkg.kind_of?(Autobuild::Orogen)
            #foo="-L#{File.join(Autoproj.root_dir,Autoproj.prefix,"lib","typelib")} -ltypeLang_cSupport -ltypeLang_tlb -ltypeLang_idl -lomniConnectionMgmt4 -lomniCodeSets4 -lomniORB4 -lomniDynamic4 -lomnithread"
            foo="-L#{File.join(Autoproj.root_dir,Autoproj.prefix,"lib","typelib")}"
            pkg.define("ADD_CFLAGS",foo)
        end
    end
end





