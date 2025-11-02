# Step 1: Build React app
FROM node:20 AS builder
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build

# Step 2: Serve + run LHCI (Chrome already included)
FROM zenika/alpine-chrome:with-node

WORKDIR /app
RUN mkdir -p /app
# Copy built assets
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package.json ./
COPY .lighthouserc.json ./

# Fix permissions so non-root user can access files
RUN chown -R chrome:chrome /app

# Switch to non-root user
USER chrome

# Install LHCI and serve locally in /app/node_modules
RUN npm install serve @lhci/cli

# Add local node_modules to PATH
ENV PATH=/app/node_modules/.bin:$PATH

EXPOSE 3000
CMD ["serve", "-s", "dist", "-l", "3000"]
