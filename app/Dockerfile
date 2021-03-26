FROM mhart/alpine-node:14 AS build

WORKDIR /app

ENV PATH /app/node_modules/.bin:$PATH

ADD . /app

RUN npm install
RUN npm run build

# production environment
FROM nginx:stable-alpine
COPY --from=build /app/build /usr/share/nginx/html
# new
COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]