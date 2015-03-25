# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

# external env vars
puppet_opts =  ENV["PUPPET_OPTIONS"] || ""

if ENV["PUPPET_DEBUG"] == "1"
  # regular output
elsif ENV["PUPPET_DEBUG"] == "2"
  puppet_opts << " --verbose --debug"
else
  puppet_opts << " 2> /dev/null"
end

show_gui = ENV["VAGRANT_GUI"] || false

configure_providers = -> (box, name, memory, cpus = 1) {
  box.vm.provider :virtualbox do |v|
     v.name = name
     v.gui = show_gui
     v.memory = memory
     v.cpus = cpus
  end

  box.vm.provider "vmware_fusion" do |v|
     v.name = name
     v.gui = show_gui
     v.vmx["memsize"] = memory.to_s
     v.vmx["numvcpus"] = cpus.to_s
  end

  box.vm.provider :parallels do |v|
    v.memory = 1024
    v.cpus = cpus
  end
}

provision_puppet = -> (box, ip, role) {
  environment = 'development'
    box.vm.provision "shell", inline: "
echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo Preparing the VM. This may take some time depending upon the setup.
echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    box.vm.provision "puppet" do |puppet|
      puppet.manifests_path = "./manifests"
      puppet.module_path = ["./modules", "./roles"]
      puppet.manifest_file = "site.pp"
      puppet.hiera_config_path = "./hiera/hiera.yaml"
      puppet.facter = {role: role, environment: "development"}
      puppet.options = puppet_opts
    end
    box.vm.provision "shell", inline: " 
echo VM is ready. You may SSH into the machine by typing: 'vagrant ssh php-devbox'.
NOTE: To report any problems, please create an issue at: https://github.com/mansab/php-devbox/issues/new"
}

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # disable the default shared folder
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder "./hiera", "/var/lib/hiera"

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  config.ssh.forward_agent = true

  # config for the PHP dev box
  config.vm.define "php-devbox" do |box|
    box.vm.box = "enadco/ubuntu"
    box.vm.host_name = "php-box.dev"
    configure_providers.call(box, "php-devbox", 1024, 2)

    box.vm.network "private_network", ip: "192.168.34.101"

    box.vm.synced_folder "./docroot", "/var/www/localhost"
    box.vm.network "forwarded_port", guest: 80, host: 15102
    box.vm.network "forwarded_port", guest: 9000, host: 15103

    provision_puppet.call(box, "192.168.34.101", "php-devbox")
  end
end
