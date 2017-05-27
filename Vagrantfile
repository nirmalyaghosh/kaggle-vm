Vagrant.configure(2) do |config|
  config.vm.box         = "ubuntu/trusty64"
  config.vm.hostname    = "kaggle-vm"
  config.vm.box_version = "20170422.0.0"

  config.vm.provider "virtualbox" do |v|
    v.cpus   = 6
    v.memory = 8192
    v.name   = "kaggle-vm"
  end

  config.vm.provision "file", source: "requirements.txt", destination: "/home/vagrant/requirements.txt"
  config.vm.provision :shell, path: 'provision.sh', keep_color: true
  config.vm.provision "file", source: "jupyter_application_config.py", destination: "/home/vagrant/jupyter_notebook_config.py"

  config.vm.synced_folder "../kaggle", "/home/vagrant/kaggle", create: true

  config.vm.network "forwarded_port", guest: 9000, host: 9000, auto_correct: true
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
  config.vm.provision "shell", run: "always", inline: <<-SHELL
    /home/vagrant/anaconda/bin/jupyter notebook --notebook-dir=/home/vagrant/notebooks --port 9000 --ip=0.0.0.0 --config=/home/vagrant/jupyter_notebook_config.py &
  SHELL

end
