if [ -f "/etc/nixos/.env" ]; then
    source /etc/nixos/.env
fi
if [[ -z "$user" ]]; then
  read -p 'user: ' user
fi
if [ ! -f /etc/nixos/.env ]; then
    touch /etc/nixos/.env
    echo user=$user >> /etc/nixos/.env
fi
sudo chown -R $user /etc/nixos
curl https://raw.githubusercontent.com/juancolchete/nixos-sol/refs/heads/main/configuration.nix -o /etc/nixos/configuration.nix 
sudo nixos-rebuild switch
source ~/.bashrc
mkdir -p /home/$user/programs
cd /home/$user/programs
[ ! -d "/home/$user/programs/solana" ] && git clone -b v1.18 https://github.com/solana-labs/solana.git /home/$user/programs/solana
sh /home/$user/programs/solana/scripts/cargo-install-all.sh /home/$user/programs
