#!/bin/bash

################################################
# Provisions the Kaggle Virtual Machine 
# 
# Credits :
# http://stackoverflow.com/questions/25321139/vagrant-installing-anaconda-python
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
conda_install pandas
conda_install scikit-learn

mssg "Installing XGBoost"
git clone --recursive https://github.com/dmlc/xgboost
chown -R vagrant:vagrant /home/vagrant/xgboost
cd xgboost; make -j4

/home/vagrant/miniconda/bin/pip install -r /home/vagrant/requirements.txt

################################################
# R
mssg "Installing R"
apt-fast -y install r-base
