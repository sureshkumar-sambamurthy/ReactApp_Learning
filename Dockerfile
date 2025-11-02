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

# Use ARM64 node image for M1
FROM --platform=linux/arm64 node:20-bullseye

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .

# Install LHCI + Puppeteer globally
RUN npm install -g @lhci/cli puppeteer

# Install necessary libraries for Puppeteer/Chrome
RUN apt-get update && apt-get install -y \
    ca-certificates fonts-liberation libappindicator3-1 libasound2 libatk-bridge2.0-0 \
    libatk1.0-0 libcups2 libdbus-1-3 libdrm2 libgbm1 libgtk-3-0 libnspr4 \
    libnss3 libx11-xcb1 libxcomposite1 libxdamage1 libxrandr2 xdg-utils wget unzip \
 && rm -rf /var/lib/apt/lists/*

# Expose port
EXPOSE 3000

# Wrapper to start React app + LHCI
RUN echo '#!/bin/sh\n\
npm start &\n\
APP_PID=$!\n\
sleep 20\n\
export LHCI_CHROME_PATH=$(node -p "require(\"puppeteer\").executablePath()")\n\
lhci autorun --url=http://localhost:3000 --config=.lighthouserc.json\n\
kill $APP_PID' > /usr/local/bin/run-app-lhci && chmod +x /usr/local/bin/run-app-lhci

CMD ["run-app-lhci"]

