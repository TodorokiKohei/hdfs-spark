# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "bento/ubuntu-20.04"

  config.vm.provider "virtualbox" do |vb|
    vb.cpus = 2
    vb.memory = "2048"
    vb.customize ["modifyvm", :id, "--uart1", "0x3F8", "4"]
    vb.customize ["modifyvm", :id, "--uartmode1", "file", File::NULL]
  end

  config.vm.define "master" do |server|
    server.vm.hostname = "master"
    server.vm.network "private_network", ip: "192.168.100.10"
    server.vm.synced_folder "master/", "/opt/src"

    server.vm.provider "virtualbox" do |vb|
      ### virtualbox上で表示される名前
      vb.name = "hdfs" + "_master"
    end
  end

  config.vm.define "worker-1" do |server|
    server.vm.hostname = "worker-1"
    server.vm.network "private_network", ip: "192.168.100.20"
    server.vm.synced_folder "worker-1/", "/opt/src"

    server.vm.provider "virtualbox" do |vb|
      ### virtualbox上で表示される名前
      vb.name = "hdfs" + "_worker-1"
    end
  end

  config.vm.define "worker-2" do |server|
    server.vm.hostname = "worker-2"
    server.vm.network "private_network", ip: "192.168.100.30"
    server.vm.synced_folder "worker-2/", "/opt/src"

    server.vm.provider "virtualbox" do |vb|
      ### virtualbox上で表示される名前
      vb.name = "hdfs" + "_worker-2"
    end
  end

  config.vm.define "client" do |server|
    server.vm.hostname = "client"
    server.vm.network "private_network", ip: "192.168.100.40"
    server.vm.synced_folder "client/", "/opt/src"

    server.vm.provider "virtualbox" do |vb|
      ### virtualbox上で表示される名前
      vb.name = "hdfs" + "_client"
    end

    server.vm.provision "shell", privileged: false, path: "client/provision.sh"
  end

  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
end
