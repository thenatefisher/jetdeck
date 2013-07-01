sudo apt-get udpate
sudo apt-get -y upgrade
sudo apt-get -y remove ruby*
sudo apt-get -y install screen curl build-essential git libxml2 libqt4-dev imagemagick postgresql-common libpq-dev postgresql-client-9.1 postgresql-9.1
curl -L https://get.rvm.io | bash -s stable --rails
wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh
git clone git@github.com:thenatefisher/jetdeck.git
bundle install

postgres setup:
	edit /etc/postgresql/8.4/main/pg_hba.conf to use md5 auth: local   all	postgres	md5
	edit /etc/postgresql/8.4/main/postgresql.conf to listen local: listen_addresses = 'localhost'
	su postgres
	psql
		ALTER USER postgres with encrypted password 'your_password';
		SELECT * FROM "pg_user";
		\q
	sudo service postgres restart

rake db:migrate
rake db:seed