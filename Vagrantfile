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

  config.vm.network "forwarded_port", guest: 9000, host: 9000, auto_correct: true
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
  config.vm.provision "shell", run: "always", inline: <<-SHELL
    /home/vagrant/miniconda/bin/ipython notebook --notebook-dir=/home/vagrant/notebooks --port 9000 --ip=0.0.0.0 &
  SHELL

end
