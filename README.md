Kaggle Virtual Machine
================================
Sets up a VirtualBox VM with the essential Python (pandas, scikit-learn, xgboost, Keras) and R packages installed.
A [Vagrant](https://www.vagrantup.com/) file is used to set up this VM, which runs on Ubuntu 14.04.

### Getting Started
I assume you already have VirtualBox (version 5+) installed, if you don't, please [download](https://www.virtualbox.org/wiki/Downloads) and install it.

1. [Download and install Vagrant](http://www.vagrantup.com/downloads.html) if you haven't previously done so.
2. Change into the `kaggle-vm` directory and run `vagrant up` - this creates the VM.

### What's Installed

- Python, 3.5.2
  - numpy, 1.11.1
  - pandas, 0.18.1
  - scikit-learn, 0.18.1
  - scipy, 0.18.1
  - xgboost, 0.6a2
  - Some other packages, refer to requirements.txt
- R version 3.0.2
- Deep Learning,
  - Keras, 1.2.2
  - TensorFlow, 1.0.1
  - Theano, 0.8.2

In addition, an Ipython server is also installed. You can view it from the host's browser at http://localhost:9000. Password is *password*.
