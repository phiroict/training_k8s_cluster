#!/usr/bin/env bash

packer build -force -only=virtualbox-iso ubuntu-20.04-desktop-amd64.json
