#/bin/bash
#*********************************************************************
#Script automates some dev env setups for popular IDE's  and platforms
#*********************************************************************
apt-install(){
	sudo apt update
	sudo apt install -y $1
}
msg(){
	echo "*******************" Installing $1 "*******************"
}

LIST=$(whiptail --title  "What do you need to install?" --checklist --separate-output \
"Choose preferred software" 25 57 19 \
"0" "SSH Server" OFF \
"1" "Google_Chrome" OFF \
"2" "MySQL Server" OFF \
"3" "MySQL Client" OFF \
"4" "MySQL Workbench Community" OFF \
"5" "PHP Latest stable version with modules " OFF \
"6" "Composer" OFF \
"7" "GIT" OFF \
"8" "Postman" OFF \
"9" "Microsoft Visualstudio Code IDE" OFF \
"10" "PyCharm IDE" OFF \
"11" "Docker" OFF \
"12" "Ansible" OFF \
"13" "Terraform" OFF \
"14" "Packer" OFF \
"15" "MC File Manager" OFF \
"16" "Atom.io code editor" OFF \
"17" "pgAdmin Software" OFF \
"18" "PostgreSQL Server" OFF 3>&1 1>&2 2>&3)

exitstatus=$?
if [ "$exitstatus" != 0 ];  then
     echo "Installation cancelled."
     exit
fi
# Common libs install
sudo apt update
sudo apt install -y curl software-properties-common apt-transport-https net-tools ca-certificates gnupg lsb-release sshpass
sudo apt --fix-broken install

for item in $LIST
do
case $item in
	"0") # SSH Server
	msg "SSH Server and run it!"
	sudo apt install -y "openssh-server"
	sudo systemctl enable sshd
	;;
	
	"1") # Gogole Chrome stable
	msg "Google Chrome Stable"
	echo Installing Google Chrome stable...
	wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
	sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
	apt-install google-chrome-stable
	#if [ ! -f  google-chrome-stable_current_amd64.deb ]; then
	#	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	#fi
	#sudo dpkg -i --force-depends google-chrome-stable_current_amd64.deb
	;;

	"2") # MySQL Server
	msg "MySQL Server latest version"
	sudo apt install -y "mysql-server"
	sudo mysql_secure_installation
	echo make the user and grant admin priviledges:
	echo $sudo mysql -u root -p
	echo >CREATE USER 'my_user'@'localhost' IDENTIFIED BY 'password';
	echo >GRANT ALL PRIVILEGES ON *.* TO 'my_user'@'localhost';
	echo >FLUSH PRIVILEGES;
	;;
	
	"3") # MySQL Client
	msg "MySQL Client"
	sudo apt install -y "mysql-client"
	;;
		
	"4") # MySQL Workbench
	msg "MySQL Workbench Community 8.0.27"
	sudo snap install mysql-workbench-community
	sudo snap connect mysql-workbench-community:password-manager-service :password-manager-service
	;;
	
	"5") # PHP
	msg "PHP interpretator with some modules"
	sudo apt install -y php php-pdo php-intl php-xml php-zip php-mbstring phpunit php-mysql php-sqlite3 php-ldap php-gd unzip php-curl
	;;
		
	"6") # Composer
	msg "PHP COMPOSER"
	sudo apt install -y "composer"
	;;	
	
	"7") # GIT
	msg "GIT"
	sudo apt install -y "git"
	;;	

	"8") # Postman
	msg "Postman latest stable release"
	sudo snap install postman
	;;
			
	"9") # VS Code
	msg "Microsoft Visual Studio Code latest stable release"
	wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
	apt-install "code"
	;;

	"10") # PyCharmIDE
	msg "PyCharm IDE comunity latest stable release"
	sudo snap install pycharm-community --classic
	;;
	
	"11") # Docker
	msg "Docker for Ubuntu stable release"
	#Digital ocean method:
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

	#sudo mkdir -p /etc/apt/keyrings
 	#curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
	#echo \
  	#"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
 	#$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	# sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
	# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
	# echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	# sudo apt update
	# apt-cache policy docker-ce
	#sudo chmod a+r /etc/apt/keyrings/docker.gpg
	apt-install "docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-compose"
	sudo groupadd docker
	sudo usermod -aG docker ${USER}
	su - ${USER}
	id -nG
	;;

	"12") # Ansible
	msg "Ansible for Ubuntu stable release"
	sudo apt install -y ansible
	;;	
	
	"13") # Terraform
	msg "Hashicorp Terraform for Ubuntu stable release"
	curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
	sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
	apt-install "terraform"
	;;

	"14") # Packer
	msg "Hashicorp Packer for Ubuntu stable release"
	curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
	sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
	apt-install "packer"
	;;
		
	"15") # ------------- MC FILE MANAGER -------------------------------------------------
	msg "MC File Manager"
	sudo apt install -y mc
	;;	

	"16") # Atom.io code editor	
	msg "Atom.io code editor for Ubuntu stable release"
	sudo snap install --classic atom
	;;	

	"17") # pgAdmin
	msg "PostgreSQL pgAdmin software"
	sudo curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo apt-key add
	sudo sh -c 'echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list && apt update'
	sudo apt install "pgadmin4 pgadmin4-desktop pgadmin4-web" 
	sudo /usr/pgadmin4/bin/setup-web.sh
	;;

	"18") # PosqgreSQL
	msg "PostgreSQL server for Ubuntu"
	sudo apt install -y postgresql
	;;	
esac    
done
echo finished.
exit
