#!/usr/bin/env bash

apt-get update
apt-get install -y python3 default-jre python3-pip
apt-get install -y mc
apt-get install -y net-tools
apt-get install openjdk-11-jdk-headless
# uncomment one of the following for graphical desktops
# NOTE: the graphical desktop is accessible through
# the main VirtualBox window (Show button)

# - minimal: wm & graphical server
# apt-get install -y icewm xinit xterm python3-tk

# - minimal desktop env: lxqt
# apt-get install -y xinit lxqt

# cd to the shared  directory
cd /vagrant
# python packages
pip3 install matplotlib pandas seaborn
# jupyter
pip3 install jupyter
# uncomment and modify to remove a previously installed Spark version
# rm -rf /usr/local/spark-3.0.0-preview2-bin-hadoop2.7
# remove any previously downloaded file
rm -rf spark-3.*-bin-hadoop*.tgz*
if ! [ -d /usr/local/spark-3.3.1-bin-hadoop3 ]; then
# current link as of 2022-11-28:
 wget https://dlcdn.apache.org/spark/spark-3.3.1/spark-3.3.1-bin-hadoop3.tgz
 tar -C /usr/local -xvzf spark-3.3.1-bin-hadoop3.tgz
 chown --recursive ubuntu:ubuntu /usr/local/spark-3.3.1-bin-hadoop3
 rm spark-3.3.1-bin-hadoop3.tgz
fi

if ! [ -d /usr/local/hadoop-3.3.4 ]; then
 wget https://downloads.apache.org/hadoop/common/hadoop-3.3.4/hadoop-3.3.4.tar.gz
 tar -C /usr/local -xvzf hadoop-3.3.4.tar.gz
 chown --recursive ubuntu:ubuntu /usr/local/hadoop-3.3.4
 rm hadoop-3.3.4.tar.gz
fi

# Copy configuration files
cp /vagrant/conf/hosts /etc/hosts
cp -r /vagrant/conf/hadoop/* /usr/local/hadoop-3.3.4/etc/hadoop
cp -r /vagrant/conf/spark/* /usr/local/spark-3.3.1-bin-hadoop3/conf

# Set environment variables
for user in vagrant ubuntu
do 
	if ! grep "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/" /home/$user/.bashrc; then
	  echo "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/" >>  /home/$user/.bashrc
	fi
	if ! grep "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/" /usr/local/hadoop-3.3.4/etc/hadoop/hadoop-env.sh; then
	  echo "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/" >>  /usr/local/hadoop-3.3.4/etc/hadoop/hadoop-env.sh
	fi
	if ! grep "export HADOOP_HOME=/usr/local/hadoop-3.3.4" /home/$user/.bashrc; then
	  echo "export HADOOP_HOME=/usr/local/hadoop-3.3.4" >>  /home/$user/.bashrc
	fi
	if ! grep "export HADOOP_MAPRED_HOME=/usr/local/hadoop-3.3.4" /home/$user/.bashrc; then
	  echo "export HADOOP_MAPRED_HOME=/usr/local/hadoop-3.3.4" >>  /home/$user/.bashrc
	fi
	if ! grep "export HADOOP_CONF_DIR=/usr/local/hadoop-3.3.4/etc/hadoop" /home/$user/.bashrc; then
	  echo "export HADOOP_CONF_DIR=/usr/local/hadoop-3.3.4/etc/hadoop" >>  /home/$user/.bashrc
	fi
	if ! grep "export SPARK_HOME=/usr/local/spark-3.3.1-bin-hadoop3" /home/$user/.bashrc; then
	  echo "export SPARK_HOME=/usr/local/spark-3.3.1-bin-hadoop3" >> /home/$user/.bashrc
	fi
	if ! grep "export PYSPARK_PYTHON=/usr/bin/python3" /home/$user/.bashrc; then
	  echo "export PYSPARK_PYTHON=/usr/bin/python3" >>  /home/$user/.bashrc
	fi
	if ! grep "export PYSPARK_DRIVER_PYTHON=jupyter" /home/$user/.bashrc; then
	  echo "export PYSPARK_DRIVER_PYTHON=jupyter" >>  /home/$user/.bashrc
	fi
	if ! grep "export PYSPARK_DRIVER_PYTHON_OPTS=notebook" /home/$user/.bashrc; then
	  echo "export PYSPARK_DRIVER_PYTHON_OPTS=notebook" >>  /home/$user/.bashrc
	fi
	if ! grep "export PATH=/usr/local/hadoop-3.3.4/bin:/usr/local/hadoop-3.3.4/sbin:/usr/local/spark-3.3.1-bin-hadoop3/bin:$PATH" /home/$user/.bashrc; then
	  echo "export PATH=/usr/local/hadoop-3.3.4/bin:/usr/local/hadoop-3.3.4/sbin:/usr/local/spark-3.3.1-bin-hadoop3/bin:$PATH"  >>  /home/$user/.bashrc
	fi
	if ! grep "export LD_LIBRARY_PATH=/usr/local/hadoop-3.3.4/lib/native:$LD_LIBRARY_PATH" /home/$user/.bashrc; then
	  echo "export LD_LIBRARY_PATH=/usr/local/hadoop-3.3.4/lib/native:$LD_LIBRARY_PATH"  >>  /home/$user/.bashrc
	fi
	
done
# # switch to user ubuntu
# sudo -i -u ubuntu bash << EOF
# echo "Switched to user ubuntu"
# if ! ( echo exit | ssh localhost ) ; then
  # echo "Creating keys and authorizing"
  # ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
  # cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
  # chmod 0600 ~/.ssh/authorized_keys
# fi
# EOF
echo "Exited user ubuntu"
