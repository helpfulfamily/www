# Stage 1 - the build process
FROM node:latest as build-deps

# Stage 2 - the production environment
FROM nginx:stable

# support running as arbitrary user which belogs to the root group
RUN chmod g+rwx /var/cache/nginx /var/run /var/log/nginx



# users are not allowed to listen on priviliged ports
RUN sed -i.bak 's/listen\(.*\)80;/listen 8443;/' /etc/nginx/conf.d/default.conf


# comment user directive as master process is run as user in OpenShift anyhow
RUN sed -i.bak 's/^user/#user/' /etc/nginx/nginx.conf

COPY . /usr/share/nginx/html

EXPOSE 8443
CMD ["nginx", "-g", "daemon off;"]