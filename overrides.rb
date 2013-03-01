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

#Autoproj.env_set 'HOSTSYSTEM', 'x86_64-linux-gnu'

Autoproj.env_add "RUBYLIB",File.join(Autoproj.root_dir,"install","x86_64-linux-gnu","lib","ruby","1.9.1","x86_64-linux")
Autoproj.env_add "RUBYLIB",File.join(Autoproj.root_dir,"install","x86_64-linux-gnu","lib","ruby","1.9.1")
Autoproj.env_add "RUBYLIB",File.join(Autoproj.root_dir,"install","x86_64-linux-gnu","lib","ruby","1.8","x86_64-linux")
Autoproj.env_add "PATH",File.join(Autoproj.root_dir,"install","x86_64-linux-gnu","bin")
Autoproj.env_add "PATH","/home/goldhoorn/Desktop/microblaze-gnu/binaries/lin64-microblaze-unknown-linux-gnu_14.3_early/bin"

#Autoproj.prefix = File.join("install",user_config('target'))

#STDOUT.puts Autoproj.prefix
#raise

#STDOUT.puts "Building for target #{ENV['TARGET']} and OROCOS_TARGET #{ENV['OROCOS_TARGET']}"
#raise if ENV['OROCOS_TARGET'] != "rtems"

host_exclude.each do |pkg|
    #Autoproj::Manifest.ignore_package(pkg)
    Autoproj.manifest.ignore_package(pkg)
end


Autobuild::Package.each do |pkg_name, pkg|
#Autoproj.manifest.each_package do |pkg|
    pkg.builddir = "build-#{Autoproj.user_config('target')}" if pkg.kind_of?(Autobuild::Configurable)
    if not user_config('HOSTBUILD') == "true"
        if pkg.kind_of?(Autobuild::CMake) and pkg_name != "rtt"
            #pkg.define("BSP",user_config('bsp'))
            pkg.define("TARGET",user_config('target'))
            #pkg.preload_script = File.join(Autoproj.root_dir,"base","types","cmake","FindRTEMS.cmake")
            pkg.define("CMAKE_TOOLCHAIN_FILE",File.join(Autoproj.root_dir,"base","types","cmake","uclinux.cmake"))
            pkg.define("BUILD_STATIC","ON")
            #pkg.define("TOOLCHAIN",File.join(Autoproj.root_dir,"base","types","cmake","uclinux.cmake"))
            #pkg.define("RTEMS_INSTALL_DIR",File.join(Autoproj.root_dir,Autoproj.prefix))
            foo="-L#{File.join(Autoproj.root_dir,Autoproj.prefix,"lib")} -DRTT_STATIC"
            pkg.define("ADD_CFLAGS",foo)
        end
        if pkg_name == "rtt" or pkg_name == "tools/rtt"
            #foo="-L#{File.join(Autoproj.root_dir,Autoproj.prefix,"lib","typelib")} -lomniConnectionMgmt4 -lomniCodeSets4 -lomniORB4 -lomniDynamic4 -lomnithread -lboost_filesystem"
            foo="-L#{File.join(Autoproj.root_dir,Autoproj.prefix,"lib","typelib")}"
            pkg.define("ADD_CFLAGS",foo)
            pkg.define("CORBA_IMPLEMENTATION","OMNIORB")
            pkg.define("ENABLE_CORBA","ON")
            pkg.define("ENABLE_MQ","OFF")
            pkg.define("OS_NO_ASM","ON")
#            pkg.define("PLUGINS_ENABLE","OFF")
            #pkg.define("BSP",user_config('bsp'))
            pkg.define("TARGET",user_config('target'))
            pkg.define("CMAKE_TOOLCHAIN_FILE",File.join(Autoproj.root_dir,"base","types","cmake","uclinux.cmake"))
            #pkg.define("RTEMS_INSTALL_DIR",File.join(Autoproj.root_dir,Autoproj.prefix))
        end
        if pkg.kind_of?(Autobuild::Orogen)
            #foo="-L#{File.join(Autoproj.root_dir,Autoproj.prefix,"lib","typelib")} -ltypeLang_cSupport -ltypeLang_tlb -ltypeLang_idl -lomniConnectionMgmt4 -lomniCodeSets4 -lomniORB4 -lomniDynamic4 -lomnithread"
            foo="-L#{File.join(Autoproj.root_dir,Autoproj.prefix,"lib","typelib")}"
            pkg.define("ADD_CFLAGS",foo)
        end
    end
end





