Vagrant.configure(2) do |config|
  config.vm.box         = "ubuntu/trusty64"
  config.vm.hostname    = "kaggle-vm"
  config.vm.box_version = "20160406.0.0"

  config.vm.provider "virtualbox" do |v|
    v.cpus   = 6
    v.memory = 8182
    v.name   = "kaggle-vm"
  end

  config.vm.provision :shell, path: 'provision.sh', keep_color: true

end

