Vagrant.configure(2) do |config|
  config.vm.box         = "ubuntu/trusty64"
  config.vm.hostname    = "kaggle-vm"
  config.vm.box_version = "20160406.0.0"

  config.vm.provider "virtualbox" do |v|
    v.cpus   = 6
    v.memory = 8192
    v.name   = "kaggle-vm"
  end

  config.vm.provision "file", source: "requirements.txt", destination: "/home/vagrant/requirements.txt"
  config.vm.provision :shell, path: 'provision.sh', keep_color: true

  config.vm.synced_folder "../kaggle", "/home/vagrant/kaggle", create: true

end
