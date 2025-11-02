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

FROM node:20-bullseye

WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm ci

# Copy source code
COPY . .

# Build the React app
RUN npm run build

# Install LHCI + Puppeteer + serve
RUN npm install -g @lhci/cli puppeteer serve

# Set Puppeteer Chromium path for LHCI
ENV LHCI_CHROME_PATH=$(node -p "require('puppeteer').executablePath()")

# Expose port for static server
EXPOSE 3000

# Start the static server
CMD ["serve", "-s", "build", "-l", "3000"]
