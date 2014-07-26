It's a docker image for developing your geospatial web applications using PHP5, NGiNX and [PostGIS](http://postgis.net/) (postgresql's geospatial extension) 

#Building
```
sudo docker run  -p 80:80 -p 5432:5432 -v /var/www:/srv/www \
--name nginxpostgis tektas/nginx-php-postgis:latest
```

##Ports

80 NGiNX service

5432 PostgreSQL service
