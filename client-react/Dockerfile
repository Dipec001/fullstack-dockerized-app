
FROM node:20-slim AS build

WORKDIR /usr/src/app

# Copy only the files required to install dependencies (better layer caching)
COPY package*.json ./

# Use cache mount to speed up install of existing dependencies
RUN --mount=type=cache,id=s/744c76ba-b674-4e64-86c9-5656f7d335d9-/usr/src/app/.npm,target=/usr/src/app/.npm \
  npm set cache /usr/src/app/.npm && \
  npm install

# Copy the rest of the application
COPY . .

# Run the build command to create production-ready assets
RUN npm run build


# Development Stage (for hot reload)
FROM node:20-slim AS dev

WORKDIR /usr/src/app

# Copy only the files required to install dependencies
COPY package*.json ./

# Install dependencies (for development mode)
RUN npm install

# Copy the rest of the application
COPY . .

# Expose port for hot-reloading during development
EXPOSE 3001

# Run Vite development server (with hot reloading)
CMD ["npm", "run", "dev"]


# Production Stage (serving with Nginx)
FROM nginxinc/nginx-unprivileged:1.23-alpine-perl AS prod

# Copy nginx configuration
COPY --link nginx.conf /etc/nginx/conf.d/default.conf

# Copy built files from the build stage
COPY --link --from=build usr/src/app/dist/ /usr/share/nginx/html

EXPOSE 3001

# Use Nginx to serve the production-ready app
CMD ["nginx", "-g", "daemon off;"]
