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

COPY package*.json ./
RUN npm ci

COPY . .

# Install LHCI + Puppeteer globally
RUN npm install -g @lhci/cli puppeteer

# Expose React port
EXPOSE 3000

# Add wrapper script to run React + LHCI sequentially
RUN echo '#!/bin/sh\n\
# Start React app in background\n\
npm start &\n\
APP_PID=$!\n\
# Wait for app to be ready\n\
sleep 20\n\
# Set Puppeteer Chromium path and run LHCI\n\
export LHCI_CHROME_PATH=$(node -p "require(\"puppeteer\").executablePath()")\n\
lhci autorun --url=http://localhost:3000 --config=.lighthouserc.json\n\
# Stop React app\n\
kill $APP_PID' > /usr/local/bin/run-app-lhci && chmod +x /usr/local/bin/run-app-lhci

CMD ["run-app-lhci"]
