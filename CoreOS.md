# CoreOS: A Beginner's Guide

## Introduction

CoreOS is a Linux distribution designed for hosting applications on server clusters, although it can be deployed on physical and virtual machines as well as cloud setups. It is designed to be an extremely lightweight operating system (eschewing features such as a graphical interface) in order to minimise operational overhead.

Instead of utilising a package manager as with other Linux distributions, all CoreOS applications run in containers. This is primarily done via Docker; however Rocket (*rkt*) is also supported. Other key features of CoreOS include service discovery using *etcd*, which allows users to distribute data across containers and machines in the cluster, and management of processes and containers across the cluster using *fleet*.

## Installation Guide

## Usage Guide

This section provides a brief overview of how to use the three major features of CoreOS as mentioned in the introduction.

### Container Management (Docker)

CoreOS applications run in isolated, lightweight containers, which are created and managed using Docker. A simple example would be to run a container called *hello-world*, which displays a single welcome message:

    ~$ docker run hello-world
  
This will download the *hello-world* container if it is not already present, display the message and then stop the container. You can keep containers running by executing certain commands within them (such as starting a service), or you can keep a container open in interactive mode, such as in this busybox example:

    ~$ docker run –ti busybox /bin/sh

### Service Discovery (*etcd*)

If you have a cluster of CoreOS machines, you can store data in etcd in order to distribute this data across all machines in the cluster. CoreOS has the `etcdctl` command line interface pre-installed to enable this. For example, you can use the following command on one of the machines in the cluster to store the string “Hello world!” with the key `/message`:

    ~$ etcdctl set /message “Hello world!”

You can then retrieve the string **from any machine in the cluster** using its key:

    ~$ etcdctl get /message
    Hello world!

### Process Management (*fleet*)

You can distribute processes across the cluster rather than a single machine using fleet. By doing this, a process (e.g. a Docker container) can run on any machine in the cluster rather than being tied to a specific one. The main method of using fleet is via the `fleetctl` command line tool. 

A simple example would be a service that prints “Hello world!” once per second. First, on any machine in the cluster, create a file called *hello.service* with the following contents:

    ```
    [Service]
    ExecStart=/usr/bin/bash -c "while true; do echo 'Hello Fleet'; sleep 1; done"
    ```
    
Then, tell fleet to start the service:

    ~$ fleetctl start hello.service
    
You can check the status of the service **from any machine in the cluster** using these commands:

    ~$ fleetctl list-units
    
    ~$ fleetctl status hello.service

Finally, you can destroy the service using this command:

    ~$ fleetctl destroy hello.service
    
As a final example, this alternative service has the same functionality as *hello.service* but runs the command inside a busybox container:

    ```
    [Unit]
    Description=My Service
    After=docker.service
	
    [Service]
    TimeoutStartSec=0
    ExecStartPre=-/usr/bin/docker kill hello
    ExecStartPre=-/usr/bin/docker rm hello
    ExecStartPre=/usr/bin/docker pull busybox
    ExecStart=/usr/bin/docker run --name hello busybox /bin/sh -c "trap 'exit 0' INT TERM;       while true; do echo Hello World; sleep 1; done"
    ExecStop=/usr/bin/docker stop hello
    ```

## Sources

https://github.com/coreos/coreos-vagrant

https://coreos.com/os/docs/latest/booting-on-vagrant.html

https://coreos.com/blog/coreos-clustering-with-vagrant/

https://coreos.com/os/docs/latest/quickstart.html
