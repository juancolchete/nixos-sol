{ config, pkgs, ... }:

let 
vars = import ./env.nix;
in {
  imports =
    [
      ./hardware-configuration.nix
      ./boot.nix
    ]; 


  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;
  virtualisation.docker.enable = true;
  time.timeZone = "America/Sao_Paulo";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  services.xserver.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users."$user" = {
    isNormalUser = true;
    description = "$user";
    extraGroups = [ "networkmanager" "wheel" "docker"];
    packages = with pkgs; [
      nodejs
      corepack_22
   ];
  };
  environment.variables.GTK_THEME = "Adwaita:dark";
  
  services.qemuGuest.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
      wget 
      vim  
      git 
      gcc 
      clang
      gnumake42
      cmake
      pkg-config 
      llvm
      hidapi
      systemd
      udev
      openssl
      anchor
      rustup
      pkg-config
      rustfmt
      llvm
      protobuf
      zlib
      steam-run
      solana-cli
      unzip
  ];

  system.stateVersion = "24.11";
  system.activationScripts.rustup = ''
    PATH=${pkgs.rustup}/bin:/home/$user/.cargo/bin:${pkgs.curl}/bin:${pkgs.bash}/bin:run/current-system/sw/bin:/run/current-system/sw/bin/tar:/run/current-system/sw/bin/clang:$PATH
    touch /home/$user/.bashrc 
    rm /home/$user/.bashrc
    touch /home/$user/.bashrc 
    echo export PATH=${pkgs.solana-cli}:/home/$user/programs/bin:'$PATH' >> /home/$user/.bashrc
    echo export LIBCLANG_PATH=${pkgs.llvmPackages.libclang.lib}/lib >> /home/$user/.bashrc
    echo export LLVM_CONFIG_PATH=${pkgs.llvm}/bin/llvm-config/bin/llvm-config >> /home/$user/.bashrc
    echo ${pkgs.systemd.dev}
    echo export PKG_CONFIG_PATH=${pkgs.systemd.dev}/lib/pkgconfig >> /home/$user/.bashrc
    echo export CFLAGS="-I${pkgs.systemd.dev}/include" >> /home/$user/.bashrc
    echo export LDFLAGS="-L${pkgs.systemd.dev}/lib" >> /home/$user/.bashrc
    echo export CC=/run/current-system/sw/bin/clang >> /home/$user/.bashrc
    echo export NIXPKGS_ALLOW_UNFREE=1 >> /home/$user/.bashrc
    echo alias build-sbf=cargo-build-sbf >> /home/$user/.bashrc
    source /home/$user/.bashrc
    alias build-sbf=cargo-build-sbf
  '';

   
}
