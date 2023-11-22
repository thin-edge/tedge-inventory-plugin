# tedge-inventory-plugin

## Plugin summary

Publish inventory data about a device on startup using a simply shell scripts.

The package includes some default inventory scripts, and allows users to add their own scripts into the folder for execution on device startup.

Inventory script which are in the folder below will be executed when the service starts, and the Standard Output will be parsed and the output converted to a MQTT message (one message per script).

```sh
/usr/share/tedge-inventory/scripts.d/
```

The name of the script is used to control the execution order, and the type where the digital twin information will be published under (keep reading for the example).

```sh
XX_<propertyName>
```

Where `XX` 2 digit 0-padded number between `00` and `99`, to determine its execution order.

### Example inventory script

An example script is shown below which adds multiple properties to the the `info` property on the digital twin

**file: /usr/share/tedge-inventory/scripts.d/00_info**

```sh
#!bin/sh
printf 'mymetric="%s\n' "some string value"
echo "another_value=1"
echo "nested={\"values\":\"ok\"}"
```

The above inventory script will result in the following MQTT message being published:

**Topic (retained=True, qos=1)**

```sh
te/device/main///twin/info
```

**Payload**

```json
{"mymetric":"some string value","another_value":1,"nested":{"values":"ok"}}
```

**Notes**

* For security reasons, scripts MUST have `0755` permissions otherwise they will be ignored.

**Technical summary**

The following details the technical aspects of the plugin to get an idea what systems it supports.

|||
|--|--|
|**Languages**|`shell` (posix compatible)|
|**CPU Architectures**|`all/noarch`. Not CPU specific|
|**Supported init systems**|`systemd` and `sysvinit`|
|**Required Dependencies**|-|
|**Optional Dependencies (feature specific)**|-|

### How to do I get it?

The following linux package formats are provided on the releases page and also in the [tedge-community](https://cloudsmith.io/~thinedge/repos/community/packages/) repository:

|Operating System|Repository link|
|--|--|
|Debian/Raspbian (deb)|[![Latest version of 'tedge-inventory-plugin' @ Cloudsmith](https://api-prd.cloudsmith.io/v1/badges/version/thinedge/community/deb/tedge-inventory-plugin/latest/a=all;d=any-distro%252Fany-version;t=binary/?render=true&show_latest=true)](https://cloudsmith.io/~thinedge/repos/community/packages/detail/deb/tedge-inventory-plugin/latest/a=all;d=any-distro%252Fany-version;t=binary/)|
|Alpine Linux (apk)|[![Latest version of 'tedge-inventory-plugin' @ Cloudsmith](https://api-prd.cloudsmith.io/v1/badges/version/thinedge/community/alpine/tedge-inventory-plugin/latest/a=noarch;d=alpine%252Fany-version/?render=true&show_latest=true)](https://cloudsmith.io/~thinedge/repos/community/packages/detail/alpine/tedge-inventory-plugin/latest/a=noarch;d=alpine%252Fany-version/)|
|RHEL/CentOS/Fedora (rpm)|[![Latest version of 'tedge-inventory-plugin' @ Cloudsmith](https://api-prd.cloudsmith.io/v1/badges/version/thinedge/community/rpm/tedge-inventory-plugin/latest/a=noarch;d=any-distro%252Fany-version;t=binary/?render=true&show_latest=true)](https://cloudsmith.io/~thinedge/repos/community/packages/detail/rpm/tedge-inventory-plugin/latest/a=noarch;d=any-distro%252Fany-version;t=binary/)|

### What will be deployed to the device?

* The following service will be installed
    * `tedge-inventory` (one shot service). Though you can use a systemd timer to trigger the service periodically
    * Two inventory scripts to collect information about the hardware and operating system

## Plugin Dependencies

The following packages are required to use the plugin:

* tedge

## Development

### Start demo

1. Start the demo

    ```sh
    just up && just bootstrap
    ```

2. Restart the tedge-inventory service (to run the inventory scripts again after the initial bootstrapping)

    ```sh
    systemctl restart tedge-inventory
    ```

### Stop demo

```sh
just down
```
