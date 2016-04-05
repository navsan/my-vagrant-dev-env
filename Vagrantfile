# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "8192"
	  vb.cpus = 3
  end
	
  get_scripts_from_git = <<SCRIPT
  	SRC_DIR=/home/vagrant/src 
  	mkdir -p $SRC_DIR 
	cd $SRC_DIR 
	git clone https://github.com/navsan/my-vagrant-dev-env.git
	source $SRC_DIR/.provision/provision.sh
  SCRIPT

  config.vm.provision "shell", "inline" => get_scripts_from_git 

  #----------------------------------------------------------------------------
  # Insert specific file here
  # if File.exist?(".provision/<FILENAME>.sh")
  #   config.vm.provision "shell", path: ".provision/<FILENAME>.sh"
  # end
  #----------------------------------------------------------------------------


  # Set the timezone if this plugin is installed: 
  # https://github.com/tmatilai/vagrant-timezone
  # To install the plugin, use this command
  # vagrant plugin install vagrant-timezone
  if Vagrant.has_plugin?("vagrant-timezone")
    config.timezone.value = "US/Central"
  end
end
