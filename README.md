# Grow a Box

Patches an existing Ubuntu installer image with a custom preseed file and uses
that image to provision a new Vagrant box file.

Currently uses Ubuntu 14.04.3 amd64 server as a base. VirtualBox is used as a
provider for Vagrant.

## Usage

The whole process is wrapped inside Docker containers, so there's no need to
install any additional packages.

All you need to do is to invoke:

    $ ./plant-and-wait

... and wait :-)

With any luck, you'll end up with a Docker container that looks as if it's stuck
at:

    [...]
    ==> virtualbox-iso: Waiting 10s for boot...
    ==> virtualbox-iso: Typing the boot command...
    ==> virtualbox-iso: Waiting for SSH to become available...

This means that VirtualBox is running the Ubuntu install process in headless
mode, which means that you don't get to see any output for a while.

Depending on how powerful your workstation is, you'll see more progress being
made sooner or later, so don't worry. The timeout value for this operation is
set to 30 minutes, but it usually takes only a couple of minutes on any halfway
decent system.

Once the script returned, you'll find that the resulting `.box` file can be
found in the `output/` directory.

## Customization

You may want to have some additional commands to be invoked as a final
provisioning step. In order to acchieve that, just put any number of scripts in
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
