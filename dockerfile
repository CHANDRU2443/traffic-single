# Faulty App Version Dockerfile configuration
FROM nginx:1.25-alpine
COPY index.html /usr/share/nginx/html/index.html
# Faulty entrypoint rewrite causing validation failure on live checks
RUN sed -i 's/index.html/index.html?version=faulty/g' /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
