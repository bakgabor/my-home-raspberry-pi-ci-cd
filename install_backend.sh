VARIABLES="./backend_variables.sh"
. "$VARIABLES"

CREATE_CONFIG="./scripts/create_backend_config.sh"
. "$CREATE_CONFIG"

scp -r ./install-files/backend_nginx_config $CONNECT:~/$CONFIG_FILE_NAME

ssh $CONNECT "sudo mv ~/$CONFIG_FILE_NAME /etc/nginx/sites-available/$CONFIG_FILE_NAME"
ssh $CONNECT "sudo ln -s -f /etc/nginx/sites-available/$CONFIG_FILE_NAME /etc/nginx/sites-enabled/"

cd ./backend

ssh $CONNECT "cd /var/www && sudo mkdir -p $PROJECT_FOLDER && sudo mkdir -p $PROJECT_FOLDER/backend"
ssh $CONNECT "cd /var/www && sudo chmod -R 777 ./$PROJECT_FOLDER"

PROJECT_PATH="/var/www/$PROJECT_FOLDER/backend"
scp -r ./config $CONNECT:$PROJECT_PATH/
scp -r ./src $CONNECT:$PROJECT_PATH/
scp -r ./templates $CONNECT:$PROJECT_PATH/
scp -r ../install-files/backend_env $CONNECT:$PROJECT_PATH/.env

ssh $CONNECT "cd /var/www && sudo chmod -R 755 ./$PROJECT_FOLDER"

ssh $CONNECT "cd $PROJECT_PATH && sudo chown www-data:www-data ./var -R && sudo chown www-data:www-data ./public -R"

ssh $CONNECT "sudo service nginx restart"
