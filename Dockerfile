FROM octohost/php5
MAINTAINER Furkan Tektas <http://github.com/furkantektas>

RUN sudo apt-get -y install python-software-properties
RUN sudo add-apt-repository ppa:ubuntugis/ppa
RUN sudo apt-get update
RUN sudo apt-get -y install postgresql-9.1-postgis-2.1 postgresql-9.1-postgis-2.1-scripts

# Reference: https://docs.docker.com/examples/postgresql_service/
# Run the rest of the commands as the ``postgres`` user created by the ``postgres-9.1`` package when it was ``apt-get installed``
USER postgres

# Create a PostgreSQL role named ``docker`` with ``docker`` as the password and
# then create a database `docker` owned by the ``docker`` role.
# Note: here we use ``&&\`` to run commands one after the other - the ``\``
#       allows the RUN command to span multiple lines.
RUN    /etc/init.d/postgresql start &&\
    psql --command "CREATE USER docker WITH SUPERUSER PASSWORD 'docker';" &&\
    createdb -O docker docker

# Adjust PostgreSQL configuration so that remote connections to the
# database are possible. 
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.1/main/pg_hba.conf

# And add ``listen_addresses`` to ``/etc/postgresql/9.1/main/postgresql.conf``
RUN echo "listen_addresses='*'" >> /etc/postgresql/9.1/main/postgresql.conf

# Expose the PostgreSQL port
EXPOSE 5432

# Add VOLUMEs to allow backup of config, logs and databases
#VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

# Set the default command to run when starting the container
#CMD ["/usr/lib/postgresql/9.1/bin/postgres", "-D", "/var/lib/postgresql/9.1/main", "-c", "config_file=/etc/postgresql/9.1/main/postgresql.conf"]

CMD /bin/sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php5/fpm/php.ini

USER root

# Exposing HTTP port
EXPOSE 80

# nginx directory
VOLUME ["/srv/www"]

# Running nginx in the foreground
CMD service php5-fpm start && service postgresql start && /usr/sbin/nginx -c /etc/nginx/nginx.conf
