# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'getoptlong'

opts = GetoptLong.new(
  ['--git-username', GetoptLong::OPTIONAL_ARGUMENT ],
  ['--git-password', GetoptLong::OPTIONAL_ARGUMENT ],
  ['--reinit-repo', GetoptLong::OPTIONAL_ARGUMENT ],
  ['--provision-with', GetoptLong::OPTIONAL_ARGUMENT ],
  ['--command', GetoptLong::OPTIONAL_ARGUMENT ],
  ['--initial_setup', GetoptLong::OPTIONAL_ARGUMENT ]
)

git_username=''
git_password=''
reinit_repo=''
initial_setup=''

opts.each do |opt, arg|
  case opt
    when '--git-username'
        git_username=arg
    when '--git-password'
        git_password=arg
    when '--reinit-repo'
        reinit_repo=arg
    when '--initial_setup'
        initial_setup=arg
  end
end

Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "ubuntu/xenial64"
  #config.vm.box = "aibax/amazonlinux2"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  config.vm.network "forwarded_port", guest: 80, host: 3000
  config.vm.network :forwarded_port, guest: 3306, host: 3307
  
  config.vm.network "private_network", type: "dhcp"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"
  
  # install required plugins if necessary
  required_plugins = %w( vagrant-hostmanager vagrant-winnfsd vagrant-bindfs )
  required_plugins.each do |plugin|
    system "vagrant plugin install #{plugin}" unless Vagrant.has_plugin? plugin
  end

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder "www/", "/var/www/html", type: :nfs
  
  # Use vagrant-bindfs to re-mount folder
  config.bindfs.bind_folder "/var/www/html", "/media/www"
  
  # Bind a folder after provisioning
  config.bindfs.bind_folder "/var/www/html", "/media/www", after: :provision

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = false
  
  vb.name = 'python-project'
  
    # Customize the amount of memory on the VM:
    vb.memory = "2048"
  vb.cpus = 2
  vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
  end
  
  config.vm.provision "shell", path: "bootstrap.sh", :args => "#{git_username} #{git_password} #{reinit_repo} #{initial_setup}"
  
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
  # Vagrant.configure("2") do |config|
  #   config.vm.provision "shell", path: "bootstrap.sh"
  # end
end

# simple OS detection
module OS
    def OS.windows?
        (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
    end

    def OS.mac?
        (/darwin/ =~ RUBY_PLATFORM) != nil
    end

    def OS.unix?
        !OS.windows?
    end

    def OS.linux?
        OS.unix? and not OS.mac?
    end
end