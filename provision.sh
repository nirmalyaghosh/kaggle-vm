#!/bin/bash

################################################
# Provisions the Kaggle Virtual Machine 
# 
# Credits :
# http://stackoverflow.com/questions/25321139/vagrant-installing-anaconda-python
# http://stackoverflow.com/a/35493714
################################################

function mssg {
    now=$(date +"%T")
    echo "[$now] $1"
    shift
}

function conda_install {
    mssg "Installing $1"
    /home/vagrant/miniconda/bin/conda install $1 -y -q
    shift
}

mssg "Provisioning the Kaggle Virtual Machine ..."

mssg "Updating the package index files. Usually takes ~ 6 minutes, depending on the speed of your network ..."
apt-get -y update >/dev/null 2>&1

################################################
# apt-fast
mssg "Installing apt-fast to try speed things up ..."
apt-get install -y aria2 --no-install-recommends >/dev/null 2>&1
aptfast=apt-fast
if [[ ! -f $aptfast ]]; then
    wget https://raw.githubusercontent.com/ilikenwf/apt-fast/master/apt-fast >/dev/null 2>&1
    wget https://raw.githubusercontent.com/ilikenwf/apt-fast/master/apt-fast.conf >/dev/null 2>&1
    cp apt-fast /usr/bin/
    chmod +x /usr/bin/apt-fast
    cp apt-fast.conf /etc
fi

mssg "Installing pip ..."
apt-fast -y install python-pip >/dev/null 2>&1
pip install --upgrade pip
mssg "Installing Git"
apt-fast install git -y > /dev/null 2>&1
mssg "Installing python-dev "
apt-fast install -y python-dev >/dev/null 2>&1

################################################
# Miniconda
mssg "Downloading & Installing Miniconda ..."
miniconda=Miniconda3-4.0.5-Linux-x86_64.sh
if [[ ! -f $miniconda ]]; then
    wget --quiet http://repo.continuum.io/miniconda/$miniconda
    chmod +x $miniconda
    ./$miniconda -b -p /home/vagrant/miniconda
    echo 'export PATH="/home/vagrant/miniconda/bin:$PATH"' >> /home/vagrant/.bashrc
    source /home/vagrant/.bashrc
    chown -R vagrant:vagrant /home/vagrant/miniconda
    /home/vagrant/miniconda/bin/conda install conda-build anaconda-client anaconda-build -y -q
fi

################################################
# Essential Python packages : pandas, scikit-learn, xgboost
conda install "scikit-learn==0.18.1" -y -q
conda_install "pandas==0.18.1" -y -q

mssg "Installing XGBoost"
/home/vagrant/miniconda/bin/pip install xgboost==0.6a2

/home/vagrant/miniconda/bin/pip install -r /home/vagrant/requirements.txt

################################################
# Theano, H5py, Keras
mssg "Installing Theano dependencies"
apt-fast install -y python-numpy python-scipy python-dev python-pip python-nose >/dev/null 2>&1
apt-fast install -y g++ git libatlas3gf-base libatlas-dev >/dev/null 2>&1
mssg "Installing Theano"
/home/vagrant/miniconda/bin/conda install -y "theano==0.8.2" >/dev/null 2>&1
mssg "Installing H5py"
apt-fast install -y libhdf5-dev >/dev/null 2>&1
/home/vagrant/miniconda/bin/pip install "h5py==2.6.0" >/dev/null 2>&1
mssg "Installing Keras"
/home/vagrant/miniconda/bin/pip install "keras==1.2.2" >/dev/null 2>&1
mssg "Installing Tensorflow"
export TF_BINARY_URL=https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-1.0.0-cp35-cp35m-linux_x86_64.whl
/home/vagrant/miniconda/bin/pip install $TF_BINARY_URL >/dev/null 2>&1

################################################
# R
mssg "Installing R"
apt-fast -y install r-base

################################################
mssg "Installing IPython Notebook server"
mkdir -p /home/vagrant/notebooks
chown -R vagrant:vagrant /home/vagrant/notebooks
/home/vagrant/miniconda/bin/pip install notebook
