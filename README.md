Kaggle Virtual Machine
================================
Sets up a VirtualBox VM with the essential Python (pandas, scikit-learn, xgboost) and R packages installed.
A [Vagrant](https://www.vagrantup.com/) file is used to set up this VM, which runs on Ubuntu 14.04.

### Getting Started
I assume you already have VirtualBox (version 5+) installed, if you don't, please [download](https://www.virtualbox.org/wiki/Downloads) and install it.

1. [Download and install Vagrant](http://www.vagrantup.com/downloads.html) if you haven't previously done so.
2. Change into the `kaggle-vm` directory and run `vagrant up` - this creates the VM.

This should install
 
- Python, 3.5.2
- pandas, 0.18.1
- numpy, 1.11.1
- scikit-learn, 0.17.1
- scipy, 0.18.0
