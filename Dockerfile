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

# Base Node image
FROM node:20-bullseye

# Set working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm ci

# Install LHCI and Puppeteer globally
RUN npm install -g @lhci/cli puppeteer

# Copy the rest of your app
COPY . .

# Expose the port your React app runs on
EXPOSE 3000

# Environment variable for Puppeteer to use headless Chrome
ENV LHCI_CHROME_FLAGS="--no-sandbox --headless --disable-gpu --disable-dev-shm-usage"

# Default command to run the React app
CMD ["npm", "start"]

