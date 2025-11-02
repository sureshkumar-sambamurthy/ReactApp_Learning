# # Step 1: Build React app
# FROM node:20 AS builder
# WORKDIR /app
# COPY . .
# RUN npm install
# RUN npm run build

# # Step 2: Use browserless Chrome
# FROM browserless/chrome:latest

# WORKDIR /app

# # Copy built React app and LHCI config
# COPY --from=builder /app/dist ./dist
# COPY .lighthouserc.json ./

# # Install serve and LHCI locally instead of globally
# RUN npm install serve @lhci/cli

# EXPOSE 3000

# # Use npx to run serve locally installed
# CMD ["npx", "serve", "-s", "dist", "-l", "3000"]

# Use Node 20
FROM node:20-bullseye

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install app dependencies
RUN npm ci

# Copy the app source code
COPY . .

# Install LHCI + Puppeteer globally
RUN npm install -g @lhci/cli puppeteer

# Expose the React app port
EXPOSE 3000

# Add wrapper script to run LHCI with Puppeteer Chromium path
RUN echo '#!/bin/sh\n\
export LHCI_CHROME_PATH=$(node -p "require(\"puppeteer\").executablePath()")\n\
lhci "$@"' > /usr/local/bin/run-lhci && chmod +x /usr/local/bin/run-lhci

# Default command: start React app
CMD ["npm", "start"]

