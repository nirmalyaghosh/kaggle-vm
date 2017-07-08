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

mssg "Provisioning the Kaggle Virtual Machine ..."

mssg "Updating the package index files. Usually takes a few minutes, depending on the speed of your network ..."
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
mssg "Downloading & Installing Anaconda ..."
anaconda=Anaconda3-4.2.0-Linux-x86_64.sh
if [[ ! -f $anaconda ]]; then
    wget --quiet https://repo.continuum.io/archive/$anaconda
    chmod +x $anaconda
    ./$anaconda -b -p /home/vagrant/anaconda
    echo 'export PATH="/home/vagrant/anaconda/bin:$PATH"' >> /home/vagrant/.bashrc
    source /home/vagrant/.bashrc
    chown -R vagrant:vagrant /home/vagrant/anaconda
    /home/vagrant/anaconda/bin/conda install conda-build anaconda-client anaconda-build -y -q
fi

################################################
# Essential Python packages : pandas, scikit-learn, xgboost
/home/vagrant/anaconda/bin/conda install "scikit-learn==0.18.1" -y -q
/home/vagrant/anaconda/bin/pip install xgboost==0.6a2
/home/vagrant/anaconda/bin/pip install -r /home/vagrant/requirements.txt

################################################
# Theano, H5py, Keras
mssg "Installing Theano dependencies"
apt-fast install -y python-numpy python-scipy python-dev python-pip python-nose >/dev/null 2>&1
apt-fast install -y g++ git libatlas3gf-base libatlas-dev >/dev/null 2>&1
mssg "Installing Theano"
/home/vagrant/anaconda/bin/conda install -y "theano==0.8.2" >/dev/null 2>&1
mssg "Installing H5py"
apt-fast install -y libhdf5-dev >/dev/null 2>&1
/home/vagrant/anaconda/bin/pip install "h5py==2.6.0" >/dev/null 2>&1
mssg "Installing Keras"
/home/vagrant/anaconda/bin/conda install -c conda-forge keras=2.0.5

mssg "Installing Tensorflow"
export TF_BINARY_URL=https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-1.2.0-cp35-cp35m-linux_x86_64.whl
/home/vagrant/anaconda/bin/pip install $TF_BINARY_URL >/dev/null 2>&1

################################################
# R
mssg "Installing R"
/home/vagrant/anaconda/bin/conda install -c r r-essentials
mssg "Installing R-xgboost"
apt-fast install -y gfortran >/dev/null 2>&1
/usr/bin/git clone --recursive https://github.com/dmlc/xgboost
cd xgboost; make -j4
/home/vagrant/anaconda/bin/R -e "install.packages('xgboost', repos = 'http://cran.us.r-project.org')"

################################################
mssg "Jupyter Notebook server"
mkdir -p /home/vagrant/notebooks
chown -R vagrant:vagrant /home/vagrant/notebooks
