
## DONT modify this file unless you know what you are doing. Things can easily go 
## wrong :D Ask Henkka for help if you need to modify this file for some reason.

Vagrant.configure("2") do |config|
  desired_directory = "/var/www/ticketless-api-go"
  config.ssh.shell = "bash -c 'cd #{desired_directory}; exec bash'"
	config.vm.box = "bento/ubuntu-22.04"
  config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.network "forwarded_port", guest: 8000, host: 8000
  config.vm.synced_folder ".", "/var/www/ticketless-api-go" # Sync current folder to VM

  config.vm.hostname = "ticketless-api-go-local"
  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
		vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    vb.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000 ]
		vb.name = "ticketless-api-go-local"
    vb.memory = "1024"  # 1mb seems to be plenty for this project
    vb.cpus = 1
  end
  
  config.vm.provision "shell", inline: <<-SHELL
    # Basic updates and package installations
    sudo apt-get update
    sudo apt-get install -y git net-tools dos2unix
    sudo apt-get -y install nginx

    # Install GO
    sudo wget https://go.dev/dl/go1.22.2.linux-amd64.tar.gz
    sudo tar -C /usr/local -xzf go1.22.2.linux-amd64.tar.gz
    sudo export PATH=$PATH:/usr/local/go/bin

    apt-get -y install zip unzip
    curl -LsS https://r.mariadb.com/downloads/mariadb_repo_setup | sudo bash -s -- --mariadb-server-version="mariadb-10.11"
    apt-get -y install mariadb-server mariadb-client

    # Stop and disable Apache if it's running
    sudo systemctl stop apache2
    sudo systemctl disable apache2

    # Setup Nginx
    sudo systemctl enable nginx
    vagrant sudo systemctl start nginx
    sudo rm /etc/nginx/sites-enabled/default
    sudo ln -s /var/www/ticketless-api-go/nginx/nginx.local.conf /etc/nginx/sites-enabled/
    sudo nginx -s reload

    # Change nginx.conf sendfile to off
    sudo sed -i 's/sendfile on/sendfile off/g' /etc/nginx/nginx.conf

    sudo systemctl disable nginx.service
    sudo systemctl enable nginx.service

    # Add user for the database
    sudo mysql --user=root --execute="CREATE USER 'ticketless'@'localhost' IDENTIFIED BY 'test'; GRANT ALL PRIVILEGES ON *.* TO 'ticketless'@'localhost' WITH GRANT OPTION;"
    sudo mysql --user=root --execute="SET GLOBAL group_concat_max_len = 370000;"
    sudo service mysql restart

    # Create testing database and user
    sudo mysql --user=root --execute="CREATE DATABASE ticketlessTesting;"
    sudo mysql --user=root --execute="CREATE USER 'ticketlessTestUser'@'localhost' IDENTIFIED BY 'test'; GRANT ALL PRIVILEGES ON *.* TO 'ticketlessTestUser'@'localhost' WITH GRANT OPTION;"
    sudo mysql --user=root --execute="SET GLOBAL group_concat_max_len = 370000;"
    
    sudo systemctl restart nginx

  SHELL

end
