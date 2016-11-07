# demo-bootstrap

A script to help simplify the deployment of controllers for the demo on SC16.

# Add a new distribution

The distribution must be compressed as a `tar/tar.gz/zip` file.  The downloading
link must include the full distribution name.

Add the downloading link to `filelist` file.

Run `./setup-controller.sh your-distribution-name`.


For example, the default distribution is `distribution-karaf-0.4.3-Beryllium-SR3`.

The link to the distribution is

~~~
https://nexus.opendaylight.org/content/repositories/opendaylight.release/org/opendaylight/integration/distribution-karaf/0.4.3-Beryllium-SR3/distribution-karaf-0.4.3-Beryllium-SR3.zip
~~~

Use the following command to set up the controller:

~~~
./setup-controller.sh distribution-karaf-0.4.3-Beryllium-SR3
~~~

The script will also try to apply some patches.  The patches will be installed
by default but if you specify `prompt` the script will ask if you want to apply
certain patches.  For example:

~~~
./setup-controller.sh distribution-karaf-0.4.3-Beryllium-SR3 prompt
~~~
