# Grow a Box

Patches a vanilla Ubuntu installer image with a preseed file that takes care of
automating the installation process and then live-provisions a new VM to become
a Vagrant box.

Currently uses Ubuntu 14.04.3 amd64 server as a base. VirtualBox is used as a
provider for Vagrant.

## Motivation

Sometimes you need to build a base box to be used with Vagrant entirely from
scratch. Not based upon some untrusted public base box, or a hand-crafted VM
that cannot easily be updated or shared.

Under the premise that you're working with VirtualBox as a provider for Vagrant
and Ubuntu is your OS of choice, preseeding comes as a natural choice for
automating the installation process.

Future versions of this... tool may add support for other OS and different
providers. I'd be happy to see contributions of any kind!

## Usage

The whole process is wrapped inside Docker containers, so there's no need to
install any additional packages.

All you need to do is to invoke:

    $ ./plant-and-wait

... and wait :-)

With any luck, you'll end up with a Docker container that appears as if it's
stuck at:

    [...]
    ==> virtualbox-iso: Waiting 10s for boot...
    ==> virtualbox-iso: Typing the boot command...
    ==> virtualbox-iso: Waiting for SSH to become available...

This is VirtualBox running the Ubuntu install process in headless mode, which
means that you don't get to see any output for a short while.

You will see more progress being made eventually, so don't worry – how long it
takes exactly really depends on how powerful your workstation is.

The timeout value for this operation is set to 30 minutes, but usually it
shouldn't take more than a couple of minutes on any halfway decent system.

Once the script returned, you'll find that the resulting `.box` file was stored
inside the `output/` directory.

## Customization

You may want to have some additional commands be invoked as a final provisioning
step. In order to achieve that, just put any number of scripts to be executed in
the `provision_extra` directory. Make sure that your script names do not start
with a dot and have the `.sh` file extension, otherwise they will be ignored.

## Troubleshooting

If you are not part of the `docker` group, the tool must be run with superuser
privileges:

    $ sudo ./plant-and-wait

Just in case the process fails or gets interrupted, make sure you remove any
dangling zombie containers with the `--volumes` option before giving it a new
shot, i.e.:

    $ for name in patch-ubuntu-installer build-vagrant-box; do
    $     docker ps --all --quiet --filter "name=$name" | xargs docker rm --force --volumes
    $ done

Sorry for the inconvenience!

## License

Please see [LICENSE](/LICENSE) for licensing details.

## Links

[https://vagrantup.com](https://vagrantup.com)

[https://packer.io/](https://packer.io)

[https://vagrantup.com](https://vagrantup.com/)

[https://www.virtualbox.org](https://www.virtualbox.org)
