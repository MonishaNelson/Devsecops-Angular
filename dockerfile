# Stage 1: Build Angular app
FROM node:18-alpine AS builder

# Set the working directory
WORKDIR /app
 
COPY ./ ./
 
# Copy package.json and package-lock.json to the working directory
COPY package*.json ./
 
# Install dependencies
RUN npm install
 
 
# Build the Angular app
RUN npm run build
 
 
# Stage 2: Serve the Angular app using Nginx
FROM nginx:alpine
 
#RUN rm -rf /etc/nginx/conf.d/default.conf
 
COPY nginx.conf /etc/nginx/conf.d/default.conf
 
# Copy built app from the previous stage to Nginx public directory
COPY --from=builder /app/dist/ /usr/share/nginx/html/
  
# Expose port 80 to the outside world
EXPOSE 80
 
# Command to start Nginx when the container starts
CMD ["nginx", "-g", "daemon off;"]

