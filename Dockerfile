# Step 1: Build React app
FROM node:20 AS builder
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build

# Step 2: Serve + LHCI
FROM zenika/alpine-chrome:with-node

WORKDIR /app
RUN chmod -R 777 /app

# Copy built app and LHCI config
COPY --from=builder /app/dist ./dist
COPY .lighthouserc.json ./

# Install global packages
RUN npm install -g serve @lhci/cli

EXPOSE 3000
CMD ["serve", "-s", "dist", "-l", "3000"]
