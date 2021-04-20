# Stage 1: Build Process
FROM node:lts-slim as build
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# install node_modules
ADD package.json /usr/src/app/package.json
RUN npm install
ADD . /usr/src/app
RUN npm run build
RUN echo $(ls .)

# Stage 2: Production environment with nginx
FROM nginx:1.16.0-alpine
COPY --from=build /usr/src/app/build /usr/share/nginx/html
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx/nginx.conf /etc/nginx/conf.d
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]