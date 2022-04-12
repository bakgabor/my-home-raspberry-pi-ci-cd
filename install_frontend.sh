VARIABLES="./frontend_variables.sh"
. "$VARIABLES"

CREATW_CONFIG="./scripts/create_frontend_config.sh"
. "$CREATW_CONFIG"


#cd ./server_files

scp -r ./install-files/frontend_nginx_config $CONNECT:~/$CONFIG_FILE_NAME

ssh $CONNECT "sudo mv ~/$CONFIG_FILE_NAME /etc/nginx/sites-available/$CONFIG_FILE_NAME"
ssh $CONNECT "sudo ln -s -f /etc/nginx/sites-available/$CONFIG_FILE_NAME /etc/nginx/sites-enabled/"

cd ./frontend

PROJECT_PATH="/var/www/$PROJECT_FOLDER/frontend"
#npm run build
ssh $CONNECT "cd /var/www && sudo mkdir -p $PROJECT_FOLDER && sudo chmod -R 777 ./$PROJECT_FOLDER && sudo rm -r $PROJECT_PATH"

scp -r ./dist $CONNECT:$PROJECT_PATH

ssh $CONNECT "cd /var/www && sudo chmod -R 755 ./$PROJECT_FOLDER"

ssh $CONNECT "cd /var/www/$PROJECT_FOLDER && sudo chown www-data:www-data ./frontend -R"
ssh $CONNECT "sudo service nginx restart"
