# Write in this file customization code that will get executed before 
# autoproj is loaded.

# Set the path to 'make'
# Autobuild.commands['make'] = '/path/to/ccmake'

# Set the parallel build level (defaults to the number of CPUs)
# Autobuild.parallel_build_level = 10

# Uncomment to initialize the environment variables to default values. This is
# useful to ensure that the build is completely self-contained, but leads to
# miss external dependencies installed in non-standard locations.
#
# set_initial_env
#
# Additionally, you can set up your own custom environment with calls to env_add
# and env_set:
#
# env_add 'PATH', "/path/to/my/tool"
# env_set 'CMAKE_PREFIX_PATH', "/opt/boost;/opt/xerces"
# env_set 'CMAKE_INSTALL_PATH', "/opt/orocos"
#
# NOTE: Variables set like this are exported in the generated 'env.sh' script.
#

require 'autoproj/gitorious'
Autoproj.gitorious_server_configuration('GITORIOUS', 'gitorious.org')
Autoproj.gitorious_server_configuration('SPACEGIT', 'spacegit.dfki.uni-bremen.de',:fallback_to_http => false)

disable_imports_from 'rock.toolchain'

if not ENV['HOSTBUILD'] == "true" 
    host_exclude = "tools/service_discovery","rtt","logger","tools/logger"
    Autoproj.change_option 'rtt_target', 'uclinux'
    Autoproj.change_option 'target', 'microblaze-unknown-linux-gnu' 
    #Autoproj.change_option 'target', 'microblaze-none-linux-gnu' 
    #Autoproj.change_option 'target', 'microblaze' 
    #Autoproj.change_option 'target', 'microblaze-none-uclinux' 
#    Autoproj.change_option 'bsp', 'pc486' #TODO
else
    host_exclude = "external/binutils","external/gcc","external/gdb","external/rtems","external/newlib","external/boost","external/omniorb","external/xerces","external/libxml"
    Autoproj.change_option 'rtt_target', 'gnulinux' 
    Autoproj.change_option 'target', 'x86_64-linux-gnu' 
end

#workaroung for buggy cmake
#Autoproj.env_set "BSP",user_config('bsp')
Autoproj.env_set "TARGET",user_config('target')
#Autoproj.env_set "RTEMS_INSTALL_DIR",File.join(Autoproj.root_dir,Autoproj.prefix)


require './autoproj/rock'
rock_autoproj_init

Autoproj.env_inherit 'CMAKE_PREFIX_PATH'

