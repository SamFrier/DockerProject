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
  
This will download the *hello-world* container if it is not already present, display the message and then stop the container. You can keep containers running by executing certain commands within them (such as starting a service), or you can keep a container open in interactive mode, such as in this *busybox* example:

    ~$ docker run –ti busybox /bin/sh

### Service Discovery (*etcd*)

If you have a cluster of CoreOS machines, you can store data in *etcd* in order to distribute this data across all machines in the cluster. CoreOS has the `etcdctl` command line interface pre-installed to enable this. For example, you can use the following command on one of the machines in the cluster to store the string “Hello world!” with the key `/message`:

    ~$ etcdctl set /message “Hello world!”

You can then retrieve the string **from any machine in the cluster** using its key:

    ~$ etcdctl get /message
    Hello world!

### Process Management (*fleet*)

## Sources

https://github.com/coreos/coreos-vagrant

https://coreos.com/os/docs/latest/booting-on-vagrant.html

https://coreos.com/blog/coreos-clustering-with-vagrant/

https://coreos.com/os/docs/latest/quickstart.html
