# Step 1: Build React app
FROM node:20 AS builder
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build

# Step 2: Serve + LHCI + Chrome
FROM node:20-bullseye

# Install dependencies for Chrome
RUN apt-get update && \
    apt-get install -y wget unzip gnupg2 fonts-liberation libnss3 libx11-xcb1 libxcomposite1 libxcursor1 libxdamage1 libxrandr2 libxss1 libxtst6 libasound2 libatk1.0-0 libcups2 libdrm2 libgbm1 libgtk-3-0 libxinerama1 libpangocairo-1.0-0 libxkbcommon0 libxrender1 libxshmfence1 --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Download and install Chrome directly
RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt-get update && \
    apt-get install -y ./google-chrome-stable_current_amd64.deb --no-install-recommends && \
    rm google-chrome-stable_current_amd64.deb && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Install global npm packages
RUN npm install -g serve @lhci/cli

# Copy built app and LHCI config
COPY --from=builder /app/dist ./dist
COPY .lighthouserc.json ./

# Expose port
EXPOSE 3000

# Run the app
CMD ["serve", "-s", "dist", "-l", "3000"]
