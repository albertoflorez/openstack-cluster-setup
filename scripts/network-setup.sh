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

    neutron subnet-show $NAME-net 2>&1 > /dev/null
    if [ "$?" -ne 0 ]
    then
	neutron subnet-create $NAME-net --name $NAME-net $CIDR --gateway=$GW --enable-dhcp=false
    fi
}

function create-subnet-no-gateway {
    NAME=$1
    CIDR=$2

    neutron subnet-show $NAME-net 2>&1 > /dev/null
    if [ "$?" -ne 0 ]
    then
	neutron subnet-create $NAME-net --name $NAME-net $CIDR --no-gateway --enable-dhcp=false
    fi
}

create-flat-net nat
create-subnet nat 172.16.0.0/16 172.16.0.1

create-flat-net ext

create-flat-net wan
# Can't use 10/8 for this because XOS already uses it for private networks
create-subnet wan 192.168.128.0/17 192.168.128.1

create-flat-net lan
# The IP range for this is bogus, Neutron just needs something
create-subnet-no-gateway lan 12.0.0.0/8
