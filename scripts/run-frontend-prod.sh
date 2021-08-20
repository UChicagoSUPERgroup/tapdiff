echo "# ng build for production..."
ng build --prod
echo "# start frontend nginx..."
nginx -c /home/superifttt/nginx.conf
echo "# frontend init done."