# chroot environments

Bootstrap chroot environments


## Bootstrap

### Ubuntu

You can bootstrap a Ubuntu environment with:
```
./bootstrap_ubuntu.sh /path/to/env
```
Requirements:
- debootstrap


## Start

### systemd-nspawn

Boot & enter the environment with:
```
systemd-nspawn -D /path/to/env -b
```
systemd-nspawn will search for an init system in the environment and start it. If you don't want to start the init system, omit the `-b` flag.

### chroot

Enter the environment with:
```
sudo chroot /path/to/env
```
