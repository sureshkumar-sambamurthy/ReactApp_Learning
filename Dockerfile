# Step 1: Build React app
FROM node:20 AS builder
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build

# Step 2: Use Chrome + Node image
FROM zenika/alpine-chrome:with-node
WORKDIR /app

# Copy built app and config
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package.json ./  # if needed for npm
COPY .lighthouserc.json ./

# Ensure permissions for root
RUN chmod -R 777 /app

# Install serve and LHCI globally
RUN npm install -g serve @lhci/cli

EXPOSE 3000
CMD ["serve", "-s", "dist", "-l", "3000"]
