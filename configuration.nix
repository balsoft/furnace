{ config, pkgs, lib, ... }:
{
  # NixOS wants to enable GRUB by default
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  
  # !!! Needed for the virtual console to work on the RPi 3, as the default of 16M doesn't seem to be enough.
  # If X.org behaves weirdly (I only saw the cursor) then try increasing this to 256M.
  boot.kernelParams = ["cma=32M"];
    
  # File systems configuration for using the installer's partition layout
  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-label/NIXOS_BOOT";
      fsType = "vfat";
    };
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };
  networking.firewall.enable = false;  
  users.users.balsoft = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDd2OdcSHUsgezuV+cpFqk9+Svtup6PxIolv1zokVZdqvS8qxLsA/rwYmQgTnuq4/zK/GIxcUCH4OxYlW6Or4M4G7qrDKcLAUrRPWkectqEooWRflZXkfHduMJhzeOAsBdMfYZQ9024GwKr/4yriw2BGa8GbbAnQxiSeTipzvXHoXuRME+/2GsMFAfHFvxzXRG7dNOiLtLaXEjUPUTcw/fffKy55kHtWxMkEvvcdyR53/24fmO3kLVpEuoI+Mp1XFtX3DvRM9ulgfwZUn8/CLhwSLwWX4Xf9iuzVi5vJOJtMOktQj/MwGk4tY/NPe+sIk+nAUKSdVf0y9k9JrJT98S/ comment" ];
    extraGroups = ["sudo" "wheel" "networkmanager" "disk" "sound" "pulse" "input"];
    description = "Александр Бантьев";
    uid = 1000;
    password = "";
  };
  security.sudo.enable = true;
  hardware.enableRedistributableFirmware = true;
  hardware.firmware = [
    pkgs.raspberrypiWirelessFirmware
  ];
  networking.wireless = {
    enable = true;
    networks.Keenetic.pskRaw = "4d03ac6e3d2a2b891d83dcceca6f531abd0fec421ad4460878f5f3bc4c76562e";
  };
  networking.hostName = "pi";
  documentation.enable = false;
  documentation.nixos.enable = false;
  swapDevices = [ { device = "/swap"; size = 4096
  ; } ];
}
