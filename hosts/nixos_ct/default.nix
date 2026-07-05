{
  config,
  pkgs,
  ...
}:
let
  frpSecrets = {
    token = builtins.getEnv "FRP_TOKEN";
    serverAddr = builtins.getEnv "FRP_SERVER_ADDR";
    serverPort = builtins.getEnv "FRP_SERVER_PORT";
  };
in {
  imports = [
    ../../modules/system.nix
    ../../modules/docker.nix
    ../../modules/proxy.nix
    # ../../modules/i3.nix

    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot = {
    loader.grub = {
      enable = true;
      device = "/dev/vda"; #  "nodev"
      efiSupport = false;
      useOSProber = true;
    };
    kernelParams = [
      "console=ttyS0,115200n8"
      "console=tty0"
    ];
  };

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking = {
    hostName = "nixos_ct"; # Define your hostname.
    usePredictableInterfaceNames = false;
    interfaces.eth0.useDHCP = true;
    networkmanager.enable = true;
  };

  services.frp = {
    instances.frpc-client={
      enable = true;
      role = "client";
      settings = {
        serverAddr = frpSecrets.serverAddr;
        serverPort = frpSecrets.serverPort;
        auth.method = "token";
        auth.token = frpSecrets.token;
        proxies= [
          {
            name = "ssh";
            type = "tcp";
            localIP = "127.0.0.1";
            localPort = 22;
            remotePort = 60022;
          }
          {
            name = "v2raya";
            type = "tcp";
            localIP = "127.0.0.1";
            localPort = 2017;
            remotePort = 60027;
          }
        ];
      };
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?
}