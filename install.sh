clear

tput cup 5 5
echo "Welcome to nginx installer"
tput cup 10 5
echo "Made by LordChebupelya"

clear

tput cup 5 5
echo "Installation properties"
tput cup 7 5
read -p "Give root access to current user and update all repos? [y/n]: " update_repos
tput cup 8 5
read -p "Launch on machine startup? [y/n]: " run_on_startup
tput cup 10 5
read -p "Start installation? [y/n]: " start_install

function install_nginx() {
  if [ $update_repos = "y" ]; then
    su root
    sudo yum -y update
  elif [ $update_repos = "n" ]; then
    echo "Not updating CentOS yum repos"
  else
    echo "ERROR: Incorrect arguement: $update_repos "
  fi
  sudo yum install epel-release
  sudo yum install nginx
  sudo systemctl start nginx
  sudo systemctl status nginx
  read -p "Do you see 'active (running)' green text? [y/n]: " service_status
  if [ $service_status = "y" ]; then
    echo "Continuing the installation..."
  elif [ $service_status = "n" ]; then
    sudo systemctl disable httpd
  fi
  sudo firewall-cmd --permanent --zone=public --add-service=http
  sudo firewall-cmd --permanent --zone=public --add-service=https
  sudo firewall-cmd --reload
  ip a
  echo "Installation completed."
}

if [ $start_install = "y" ]; then
  echo "Installing..."
  install_nginx
elif [ $start_install = "n" ]; then
  echo "Cancelling installation..."
else
  echo "ERROR: Incorrect arguement: $start_install "
  sleep 3s
  clear
  ./install.sh
fi
