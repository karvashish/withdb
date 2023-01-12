###################

# BUILD FOR LOCAL DEVELOPMENT

###################



FROM node:18.12.1-alpine As development



# Update npm to version 9

RUN npm install -g npm@9.2.0



USER node



# Create the project directory

RUN mkdir -p /home/node/spatial



WORKDIR /home/node/spatial



# Copy application dependency manifests to the container image.

# Copying this first prevents re-running npm install on every code change.

# A wildcard is used to ensure copying both package.json AND package-lock.json (when available).

COPY --chown=node:node package*.json ./



# Install app dependencies using the `npm ci` command instead of `npm install`

RUN npm ci



# Bundle app source

COPY --chown=node:node . .



###################

# BUILD FOR PRODUCTION

###################

FROM node:18.12.1-alpine As build

RUN npm install -g npm@9.2.0



USER node

RUN mkdir -p /home/node/spatial

WORKDIR /home/node/spatial



COPY --chown=node:node package*.json ./



COPY --chown=node:node --from=development /home/node/spatial/node_modules ./node_modules

COPY --chown=node:node . .




# Run the build command which creates the production bundle

RUN npm run build



# Set NODE_ENV environment variable

ENV NODE_ENV production



RUN npm install --omit=dev && npm cache clean --force



###################

# PRODUCTION

###################



FROM node:18.12.1-alpine As production

USER node

RUN mkdir -p /home/node/spatial

WORKDIR /home/node/spatial



# Copy the bundled code from the build stage to the production image

COPY --chown=node:node --from=build /home/node/spatial/node_modules ./node_modules

COPY --chown=node:node --from=build /home/node/spatial/dist ./dist



CMD [ "node", "dist/main.js" ]