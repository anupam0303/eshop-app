# build environment
FROM 735181371616.dkr.ecr.eu-west-1.amazonaws.com/eshop-node:14-alpine as build
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH
COPY package.json ./
RUN npm install --silent
RUN npm install react-scripts@3.4.1 -g --silent
COPY . ./
RUN npm run build

# production environment
FROM 735181371616.dkr.ecr.eu-west-1.amazonaws.com/eshop-nginx:stable-alpine
COPY --from=build /app/build /usr/share/nginx/html/eshop-dev
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
