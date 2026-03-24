{ nixos-raspberrypi, pkgs, lib, ... }:
{
	imports = with nixos-raspberrypi.nixosModules; [
		raspberry-pi-5.base
		raspberry-pi-5.page-size-16k
   		 raspberry-pi-5.display-vc4
		# raspberry-pi-5.bluetooth
	];
	boot.kernelPackages = lib.mkForce nixos-raspberrypi.packages.${pkgs.stdenv.hostPlatform.system}.linuxPackages_rpi5;
	boot.loader.raspberry-pi.bootloader = "kernel";

	fileSystems = {
		"/boot/firmware" = {
			device = "/dev/disk/by-uuid/2175-794E";
			fsType = "vfat";
			options = [
				"noatime"
				"noauto"
				"x-systemd.automount"
				"x-systemd.idle-timeout=1min"
			];
		};
		"/" = {
			device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
			fsType = "ext4";
			options = [ "noatime" ];
		};
	};
	#hardware.raspberry-pi."5".vc4.enable = true;
}
