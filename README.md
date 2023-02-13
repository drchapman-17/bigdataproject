# Big Data Project

### Setup:

1. Build the VM cluster running:

```shell
vagrant up --provision
```

2. Access the **node-master** virtual Machine using *vagrant ssh*

3. Switch user:
```shell
sudo -i -u ubuntu
```

4. Generate a public ssh key using:

```shell
ssh-keygen -b 4096
```

5. Add the content of *id_rssa.pub* to all the nodes **authorized_hosts** files in the *.ssh* folder (ubuntu user)

6. on **node-master** start the hadoop cluster by runing:
```shell
start-all.sh
```

7. add the two scripts and the notebook file in a **node-master** folder

8. run *download.sh* and *unzip.sh* to download and unzip the dataset.

9. open the notebook
