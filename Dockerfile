# Use Node.js Alpine image for building
FROM node:17-alpine as build

# Set working directory
WORKDIR /app

# Copy React App source code
COPY . .

# Install dependencies and build the React app
RUN npm install
RUN npm run build

# Use Nginx Alpine image for serving
FROM nginx:1.16.0-alpine

# Copy the built React app to NGINX's web root directory
COPY --from=build /app/dist /usr/share/nginx/html

# Remove the default NGINX configuration (if any) and copy custom NGINX config
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx/nginx.conf /etc/nginx/conf.d

# Expose port 80 for incoming traffic
EXPOSE 80

# Start NGINX when the container runs
CMD ["nginx", "-g", "daemon off;"]