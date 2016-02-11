# letsencrypt_client

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with letsencrypt_client](#setup)
    * [What letsencrypt_client affects](#what-letsencrypt_client-affects)
    * [Setup requirements](#setup-requirements)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This module is for managing letsencrypt certificates with puppet. It does not
automatically install the certificates to the web server as that is out of
scope for this project.

## Module Description

Currently the module handles installing the letsencrypt cli tool for the module
to then use to request certificates using the defined resource type.
Certificates will automatically be renewed when the cert has less than 30 days
left until it expires.

## Setup

### What letsencrypt_client affects

* Installs python, python-dev, libffi-dev, libssl-dev, virtualenv, pip, and
letsencrypt

### Setup Requirements

* Requires `openssl` to be installed and in /usr/bin

## Usage

Simply use the letsencrypt_client::cert defined resource type to request a
certificate from letsencrypt's CA.

Please ensure that you make regular backups of the letsencrypt directory that
is used to store the private keys / certificates generated, these are located
at:
`/etc/letsencrypt`.

## Reference

```
letsencrypt_client::cert { "example.com",
  webroot     => "/var/www",
  domain_name => "$title",
  sub_domains => ['mail.example.com', 'blog.example.com', 'www.example.com'],
}
```

## Limitations

This has been tested on:

* Ubuntu 14.04.3 LTS

## Development

The source is at https://github.com/demophoon/letsencrypt-client. Feel free to
submit issues and or enhancement requests there.

## Release Notes/Contributors/Etc

* Britt Gresham <britt@brittg.com>
* Adam Cooper <adam@genericstudent.com>
