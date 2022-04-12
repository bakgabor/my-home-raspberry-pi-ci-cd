echo "create config to the port $PORT"
echo "server {
    listen $PORT;

    if (\$project = '') {
       set \$project \"site\";
    }

    root \"/var/www/$PROJECT_FOLDER/frontend\";

    error_log /var/log/nginx/0.error.log;
    access_log /var/log/nginx/0.access.log;

    #more_set_headers -s '400 401 402 403 404 405' \"Access-Control-Allow-Origin: *\";

    gzip             on;
    gzip_min_length  1000;
    gzip_proxied     expired no-cache no-store private auth;
    gzip_types       text/plain application/xml text/css application/x-javascript text/javascript application/javascript;
    gzip_disable     \"msie6\";

    location / {
        try_files \$uri \$uri/ /index.html;
    }

}" > ./install-files/frontend_nginx_config
