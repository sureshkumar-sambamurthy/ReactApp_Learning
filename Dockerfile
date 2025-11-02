# Step 1: Build React app
FROM node:20 AS builder
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build

# Step 2: Serve + LHCI using browserless/chrome
FROM browserless/chrome:latest

WORKDIR /app

# Copy built app and config
COPY --from=builder /app/dist ./dist
COPY .lighthouserc.json ./

# Install global npm packages for serving & LHCI
USER root
RUN npm install -g serve @lhci/cli

EXPOSE 3000

CMD ["serve", "-s", "dist", "-l", "3000"]
