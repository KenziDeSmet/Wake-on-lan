# Wake On Lan - PowerShell

Wake-on-LAN is a special feature that allows other devices to wake your device remotely.

This functionality is enabled by configuring your Ubuntu device's network driver to accept a specially formatted packet called the "magic packet."

Additionally, you can enable the Wake-on-LAN feature through your device's BIOS. It is often labeled as "Wake up on LAN" or "Wake up on PCI event," but the exact naming may vary depending on your BIOS.

A script is available in this repository that allows you to use Wake-on-LAN from another Windows device via PowerShell to turn on a remote device.

**Determining the Right Network Interface**

Before enabling Wake-on-LAN on your Ubuntu device, you need to identify the correct network adapter and retrieve its connection name.

The `nmcli` tool allows you to list the available network connections using the following command:

```cpp
nmcli connection show
```

After executing the above command, you will see a list of available connections. You need to note two important pieces of information:

1. The connection name (e.g., "Wired connection 1").
2. The device name, which is found in the last column (e.g., "enp1s0").

Example output:

```cpp
NAME                UUID                                  TYPE      DEVICE
Wired connection 1  fd179af5-6b4d-35aa-97c4-3e14bfe9ee81  ethernet  enp1s0
```

## **Retrieving the Network Adapter's MAC Address**

The next step is to retrieve the MAC address of the ethernet adapter.

The MAC address is where we will send the Wake-on-LAN magic packet to wake your Ubuntu device. Replace "<DEVICE NAME>" with your actual device name in the following command:

```cpp
nmcli device show "<DEVICE NAME>" | grep "GENERAL.HWADDR"
```

After running this command, you should see output similar to the example below:

```cpp
GENERAL.HWADDR:                         52:54:00:87:6C:0B
```

The value next to "GENERAL.HWADDR" is the MAC address of your network adapter, which you will use to wake your Ubuntu device.

## **Checking the Wake-on-LAN Setting**

The next step is to check the current Wake-on-LAN setting for your selected connection.

To retrieve the current setting, run the following command, replacing "<CONNECTION NAME>" with the name you obtained earlier:

```cpp
nmcli connection show "<CONNECTION NAME>" | grep 802-3-ethernet.wake-on-lan
```

If Wake-on-LAN is disabled, you will see an output similar to this:

```cpp
802-3-ethernet.wake-on-lan:             default
802-3-ethernet.wake-on-lan-password:    --
```

## **Using NMCLI to Enable Wake-on-LAN on Ubuntu**

Now that you have identified your network connection name, you can enable Wake-on-LAN on your Ubuntu device.

To enable Wake-on-LAN for the specified network connection, run the following command, replacing "<CONNECTION NAME>" with your connection name:

```cpp
nmcli connection modify "<CONNECTION NAME>" 802-3-ethernet.wake-on-lan magic
```

## **Turning off Wake-on-LAN**

If you decide to disable the Wake-on-LAN functionality on your Ubuntu device, you can use the following command:

```cpp
nmcli connection modify "<CONNECTION NAME>" 802-3-ethernet.wake-on-lan ignore
```

This command changes the "Wake-on-LAN" setting from "magic" to "ignore," which ensures that your Ubuntu device will no longer respond to magic packets on your network connection.

## Source

https://pimylifeup.com/ubuntu-enable-wake-on-lan/
