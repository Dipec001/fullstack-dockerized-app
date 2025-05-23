# Starting with a base image for Node.js
FROM node:19.6-bullseye-slim AS build-base

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the package files
COPY package*.json ./

# Install dependencies
RUN --mount=type=cache,id=s/1e65626d-b927-4f2b-894e-594f92b8b02f-/usr/src/app/.npm,target=/usr/src/app/.npm \
  npm set cache /usr/src/app/.npm && \
  npm install -g nodemon && \
  npm install

# dev stage
FROM build-base AS dev

# Copy the rest of the app code
COPY . .

# Expose the port
EXPOSE 3000

# Start the application with nodemon
CMD ["nodemon", "--watch", "/usr/src/app", "src/index.js"]

FROM build-base AS prod

# Set NODE_ENV
ENV NODE_ENV=production

RUN --mount=type=cache,id=s/1e65626d-b927-4f2b-894e-594f92b8b02f-/usr/src/app/.npm,target=/usr/src/app/.npm \
  npm set cache /usr/src/app/.npm && \
  npm ci --omit=dev


USER node

# Copy the healthcheck script
COPY --chown=node:node ./healthcheck/ .

# Copy remaining source code AFTER installing dependencies. 
# Again, copy only the necessary files
COPY --chown=node:node ./src/ .

# Expose the port
EXPOSE 3000

CMD ["node", "index.js"]