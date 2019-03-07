# Flight Runway

A base platform/environment for managing and executing OpenFlight tools.

## Overview

## Commands

* `flight` (and `fl`) - main entry point for execution of OpenFlight tools.
* `flexec` - shorthand to execute a binary within the Flight Runway environment (for e.g. `irb`, `bundle` etc.).
* `flenable` - configure system-wide or user profile scripts to integrate Flight Runway with your environment.
* `flactivate` - execute a `bash` shell preconfigured for use with Flight Runway.
* `flintegrate` - install an OpenFlight tool using a tool descriptor file.

## Installation

### From the OpenFlight `yum` repository

The recommended installation method is to use the RPM provided for
installation on Enterprise Linux 7 series distributions, e.g. CentOS
7:

1. Set up the `yum` repository on your system.  For production
   releases use `openflight.repo` and for development releases use
   `openflight-dev.repo`:

   ```
   cd /etc/yum/repos.d
   # For production releases
   wget https://openflighthpc.s3-eu-west-1.amazonaws.com/repos/openflight/openflight.repo
   # For development releases
   wget https://openflighthpc.s3-eu-west-1.amazonaws.com/repos/openflight-dev/openflight-dev.repo
   ```

2. Rebuild your `yum` cache:

   ```
   yum makecache
   ```

3. Install the `flight-runway` RPM with `yum`:

   ```
   yum install flight-runway
   ```

### Manual installation

While manual installation is not normally required, if you're not using Enterprise Linux or want to set things up yourself directly from the repository, you can do so by following the steps below.

#### Prerequisites

You will need a functional Ruby 2.5+ environment (one installed via RVM or similar works well) along with the Bundler tool.

#### Steps

1. Clone the repository into `/opt/flight`

    ```bash
    cd /opt
    git clone https://github.com/openflighthpc/flight-runway flight
    ```

2. Replace the convenience wrappers with symlinks to the programs supplied by your Ruby environment:

    ```bash
    cd /opt/flight/bin
    for a in bundle gem irb rake ruby 
      rm -f $a
      ln -s $(which $a) $a
    done
    ```

3. Place scripts and configuration files from the `pkg/` directory in the expected locations:

    ```bash
    cd /opt/flight
    mv pkg/bin/flintegrate bin/flintegrate
    mkdir -p /opt/flight/opt/runway
    mv pkg/dist /opt/flight/opt/runway
    rmdir pkg
    ```

## Configuration

Once Flight Runway is installed, you can choose one of the following options for integrating Flight Runway into your environment:

### No integration

You can operate Flight Runway without integrating it in your environment.  Address binaries using their absolute paths, e.g.:

```
[chrisdemo@localhost ~]$ /opt/flight/bin/flight
```

Alternatively start a `bash` shell with the `flactivate` command which is preconfigured for use of the Flight Runway tools:

```
[chrisdemo@localhost ~]$ /opt/flight/bin/flactivate
(flight) [chrisdemo@localhost ~]$ flight
Usage: flight COMMAND [[OPTION]... [ARGS]]
Perform high performance computing management activities.

Commands:
  flight help             Display help and usage information.
  flight shell            Enter a shell-like sandbox for a Flight command.

For more help on a particular command run:
  flight COMMAND help

Please report bugs to <flight@openflighthpc.org>
OpenFlightHPC home page: <https://openflighthpc.org/>
```

### Integration with your PATH 

The simplest way to make Flight Runway available is by adding the `/opt/flight/bin` directory to your PATH environment variable:

```
[chrisdemo@localhost ~]$ PATH=/opt/flight/bin:$PATH
[chrisdemo@localhost ~]$ flight
```

Make the above change manually or by adding it to your `~/.bash_profile` (or similar for your preferred shell).

### System-wide integration

Use the `flenable` tool as the superuser to make Flight Runway available to all users on your system by integrating it with `/etc/profile.d` scripts:

```
[root@localhost flight-runway]# /opt/flight/bin/flenable
Install system-wide profile scripts (Y/n)? y
Installing profile scripts to /etc/profile.d...  OK
```

On future login sessions, the `flight` tool, and its shorthand (`fl`), are available at the terminal, along with the `flexec` and `flintegrate` tools.

### User-only integration

If you only want Flight Runway available as a particular user, use the `flenable` tool to make Flight Runway available by integrating it with your shell profile scripts:

```
[chrisdemo@localhost ~]$ /opt/flight/bin/flenable
Install to /home/chrisdemo/.bashrc (Y/n)? y
Installing to /home/chrisdemo/.bashrc...  OK
```

On future login sessions, the `flight` tool, and its shorthand (`fl`), are available at the terminal, along with the `flexec` and `flintegrate` tools.

## Installing and integrating tools

With Flight Runway up and running you'll probably want to install one or more of the OpenFlight tools.  This is facilitated by using the `flintegrate` command which takes a tool descriptor file and integrates the command into the Flight Runway environment.

You can find a set of tool descriptors in the [openflight-tools](https://github.com/openflighthpc/openflight-tools) repository.  First clone the repo:

```
cd $HOME
git clone https://github.com/openflighthpc/openflight-tools 
```

With the tool descriptors available, use one of the following methods for installation/integration of a tool:

### Using defaults specified in the tool descriptor

The simplest installation method is to use the default releases specified in the tool descriptors, e.g.:

```
flintegrate $HOME/openflight-tools/flight-example.yml
```

This will download a zip file containing the `flight-example` tool from the default URL specified in the tool descriptor, unpack it into the `/opt/flight/opt/flight-example` directory and integrate it according to the instructions held within the tool descriptor.

### Upstream zip file

If you want to specify an alternative URL for the upstream source for a tool, specify a URL to a zip file containing the release of the tool you want to use to the `flintegrate` tool:

```
flintegrate $HOME/openflight-tools/flight-example.yml \
  https://github.com/openflighthpc/flight-example/archive/master.zip
```

This will download the zip file from the specified URL, unpack it to the `/opt/flight/opt/flight-example` directory and integrate it according to the instructions held within the tool descriptor.

You may specify a target directory as a third argument.

### Local directory

This might be a directory that you've already prepared from a clone or unpacked zip file.

```
flintegrate $HOME/openflight-tools/flight-example.yml \
  /opt/flight/opt/flight-example
```

No download occurs; the tool that's present in the `/opt/flight/opt/flight-example` directory is integrated into the Flight Runway environment.

# Contributing

Fork the project. Make your feature addition or bug fix. Send a pull
request. Bonus points for topic branches.

Read [CONTRIBUTING.md](CONTRIBUTING.md) for more details.

# License

Eclipse Public License 2.0, see [LICENSE.txt](LICENSE.txt) for details.

Copyright (C) 2019-present Alces Flight Ltd.

This program and the accompanying materials are made available under
the terms of the Eclipse Public License 2.0 which is available at
[https://www.eclipse.org/legal/epl-2.0](https://www.eclipse.org/legal/epl-2.0),
or alternative license terms made available by Alces Flight Ltd -
please direct inquiries about licensing to
[licensing@alces-flight.com](mailto:licensing@alces-flight.com).

Flight Runway is distributed in the hope that it will be
useful, but WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, EITHER
EXPRESS OR IMPLIED INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OR
CONDITIONS OF TITLE, NON-INFRINGEMENT, MERCHANTABILITY OR FITNESS FOR
A PARTICULAR PURPOSE. See the [Eclipse Public License 2.0](https://opensource.org/licenses/EPL-2.0) for more
details.
