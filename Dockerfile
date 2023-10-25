FROM httpd:alpine

 ENV TZ=Europe/Kiev
 
 RUN apk add --no-cache tzdata
 RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
 RUN rm -rf /usr/local/apache2/htdocs/index.html

 COPY src/index.php /usr/local/apache2/htdocs/
 
 EXPOSE 80

 CMD ["apachectl", "-D", "FOREGROUND"]
