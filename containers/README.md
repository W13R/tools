# containers with systemd

Bootstrap & run systemd containers

## Requirements

Your host system kernel must support user_namespaces.

You need the following programs:

- `systemd-nspawn`
- `machinectl`
- `systemd-run`

They may be already installed via the systemd package, but in some
distros you have to install them with the package systemd-container.

Depending on the distro you want to bootstrap, you need

- `debootstrap` for Ubuntu

If you want to run desktop environments in your 

## Bootstrap

### Ubuntu

You can bootstrap a Ubuntu environment with:
```
sudo ./bootstrap_ubuntu.sh /path/to/env
```

Edit the shell script to change the Ubuntu Version, add standard software, etc.


## Use

Boot & enter the environment with systemd-nspawn.
systemd-nspawn will search for an init system in the environment and start it.
If you don't want to start the init system, omit the `-b` flag.

Start init system and enter the environment:

```
sudo systemd-nspawn -bUD /path/to/env
```

For more information about the flags and arguments, see the man page of
systemd-nspawn or approach the search engine of your choice.


### Graphical Applications

DISCLAIMER: The following works on *my* system (Manjaro Linux),
but may not work for *yours* ~ this stuff is a bit clumsy.

Start the container with:

```
sudo systemd-nspawn -bUD /path/to/env --bind-ro /tmp/.X11-unix --bind-ro "$XAUTHORITY"
```

Log into your container (preferably as an unprivileged user),
and set the `DISPLAY` variable to you current display, e.g.:

```
export DISPLAY=:0
```

Now you can run graphical applications, for example`firefox` or `libreoffice`
in your container.


### Run in background

```
sudo systemd-nspawn -bUD /path/to/env > /dev/null 2> /dev/null &
```

You can then view and stop the container with machinectl:

```
sudo machinectl
sudo machinectl stop <machine-name> 
```

If you need a shell in the environment, you have multiple options:

```
sudo machinectl login <machine-name>
```

To get a root shell without login:

```
sudo systemd-run -P --machine <machine-name> /bin/bash
```

You can use this to run commands in the environment.
Just replace `/bin/bash` with another command.
If you don't want the output, omit the `-P` flag.
