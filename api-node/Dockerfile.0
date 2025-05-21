# Starting with a base image for Node.js
FROM node:19.6-bullseye-slim

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the app code
COPY . .

# Expose the port
EXPOSE 3000

# Run the app (or dev command)
CMD ["npm", "run", "dev"]
