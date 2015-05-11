#!/bin/bash

source ~/admin-openrc.sh

function create-flat-net {
    NAME=$1
    neutron net-show $NAME-net 2>&1 > /dev/null
    if [ "$?" -ne 0 ]
    then
	neutron net-create --provider:physical_network=$NAME --provider:network_type=flat --shared $NAME-net
    fi
}

function create-subnet {
    NAME=$1
    CIDR=$2
    GW=$3

    neutron subnet-show nat-net 2>&1 > /dev/null
    if [ "$?" -ne 0 ]
    then
	neutron subnet-create $NAME-net --name $NAME-net $CIDR --gateway=$GW --enable-dhcp=false
    fi
}

create-flat-net nat
create-subnet nat 172.16.0.0/16 172.16.0.1

create-flat-net ext
create-flat-net wan
create-flat-net lan



