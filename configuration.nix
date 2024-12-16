{ config, pkgs, ... }:

let 
vars = import ./env.nix;
in {
  imports =
    [
      ./hardware-configuration.nix
      ./boot.nix
    ]; 

  networking.hostName = "nixos";
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

  users.users.${vars.user} = {
    isNormalUser = true;
    description = "";
    extraGroups = [ "networkmanager" "wheel"];
    packages = with pkgs; [
      nodejs
      corepack_22
   ];
  };
  environment.variables.GTK_THEME = "Adwaita:dark";
  
  services.qemuGuest.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
      clang
      pkg-config 
      llvm
      systemd
      cmake
      git 
      anchor
      rustup
      steam-run
  ];

  system.stateVersion = "24.11";
  system.activationScripts.rustup = ''
    echo $user 
    PATH=${pkgs.rustup}/bin:/home//${vars.user}/.cargo/bin:${pkgs.curl}/bin:${pkgs.bash}/bin:run/current-system/sw/bin:/run/current-system/sw/bin/tar:/run/current-system/sw/bin/clang:$PATH
    touch /home/${vars.user}/.bashrc 
    rm /home/${vars.user}/.bashrc
    touch /home/${vars.user}/.bashrc 
    echo export PATH=${pkgs.solana-cli}:/home/${vars.user}/programs/bin:'$PATH' >> /home/${vars.user}/.bashrc
    echo export LIBCLANG_PATH=${pkgs.llvmPackages.libclang.lib}/lib >> /home/${vars.user}/.bashrc
    echo export LLVM_CONFIG_PATH=${pkgs.llvm}/bin/llvm-config/bin/llvm-config >> /home/${vars.user}/.bashrc
    echo ${pkgs.systemd.dev}
    echo export PKG_CONFIG_PATH=${pkgs.systemd.dev}/lib/pkgconfig >> /home/${vars.user}/.bashrc
    echo export CFLAGS="-I${pkgs.systemd.dev}/include" >> /home/${vars.user}/.bashrc
    echo export LDFLAGS="-L${pkgs.systemd.dev}/lib" >> /home/${vars.user}/.bashrc
    echo export CC=/run/current-system/sw/bin/clang >> /home/${vars.user}/.bashrc
    echo export NIXPKGS_ALLOW_UNFREE=1 >> /home/${vars.user}/.bashrc
    echo alias build-sbf=cargo-build-sbf >> /home/${vars.user}/.bashrc
    source /home/${vars.user}/.bashrc
    alias build-sbf=cargo-build-sbf
  '';

   
}
