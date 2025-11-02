# Step 1: Build React app
FROM node:20 AS builder
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build

# Step 2: Serve + run LHCI (Chrome already included)
FROM zenika/alpine-chrome:with-node

WORKDIR /app

# Install locally in /app/node_modules
COPY package.json package-lock.json ./
RUN npm install serve @lhci/cli

# Copy built app and config
COPY --from=builder /app/dist ./dist
COPY .lighthouserc.json ./

# Use PATH to include local node_modules
ENV PATH=/app/node_modules/.bin:$PATH

# Drop back to non-root user for runtime
USER chrome

EXPOSE 3000
CMD ["serve", "-s", "dist", "-l", "3000"]
