# Build stage
FROM node:18-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npx ng build --configuration production

# Production stage
FROM nginx:alpine
ARG BACKEND_URL=devops-platform-backend
COPY --from=build /app/dist/frontend /usr/share/nginx/html
# Angular routing support
COPY nginx.conf /etc/nginx/conf.d/default.conf
RUN sed -i "s/backend-service/$BACKEND_URL/g" /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
