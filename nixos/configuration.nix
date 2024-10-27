# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  gdk = pkgs.google-cloud-sdk.withExtraComponents( with pkgs.google-cloud-sdk.components; [
    gke-gcloud-auth-plugin
  ]);
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];
  #___ OVERLAY IMPORTS ____#
  nixpkgs.overlays = [
    (import /etc/nixos/overlays/repototxt-overlay.nix)
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking = {
    networkmanager.enable = true;
    networkmanager.dns = "default";  # Use "dnsmasq" or "systemd-resolved" if needed.
    nameservers = [ "8.8.8.8" "8.8.4.4" ];  # Google's DNS servers.
  };

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  # services.displayManager.sddm.enable = true;
  # services.desktopManager.plasma6.enable = true;



  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;


  # Define a user account. Don't forget to set a password with ‘passwd’.

  users.users.bishal = {
    isNormalUser = true;
    description = "Bishal Karmakar";
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" ]; # ____ Added docker group ______ #
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Turn on hyprland
  programs.hyprland = {
   enable = true;
   xwayland.enable = true;  # Enable XWayland if needed
  };
  


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    neovim
    xclip
    google-chrome
    unstable.vscode
    gh
    git
    git-lfs
    bun
    yarn
    pnpm
    fzf
    gdk
    python3
    python312Packages.pip
    gcc
    gnumake42
    go
    ffmpeg
    nodejs_22
    gnupg 
    pass
    docker-credential-helpers
    dig
    inetutils
    wl-clipboard
    qemu
    qemu_kvm
    virt-manager
    htop
    nix-prefetch-scripts
    repototxt
    jq
    kdePackages.konsole
    kitty
  ];
 

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?


  ##_________MY CONFIGS ____________________##
   
  programs.bash.shellAliases = { # __ Aliases __ #
    vi = "nvim"; 
    vim = "nvim";
    svi = "sudo nvim";  # sudo versions of the alias
    svim = "sudo nvim";

    c = "sudo nvim /etc/nixos/configuration.nix";
    rb = "sudo nixos-rebuild switch";

  };
  
  virtualisation.docker.enable = true; # __ Install Docker __ #

  # __ FOR QEMU __ #
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.package = pkgs.qemu_kvm;

 
  # Enable Bluetooth
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  hardware.bluetooth.settings = {
	General = {
		Experimental = true;
	};
  };
  services.blueman.enable = true;


  home-manager.users.bishal = { pkgs, ... }: {
    home.packages = [ pkgs.atool pkgs.httpie ];
    programs.bash.enable = true;

    programs.zoxide.enable = true;
    programs.zoxide.enableBashIntegration= true;
    programs.zoxide.options = [
      "--cmd cd"
    ];

    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "23.05";
  };



  
}
