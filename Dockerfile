# Step 1: Build React app
FROM node:20 AS builder
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build

FROM browserless/chrome:latest

WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY .lighthouserc.json ./

RUN npm install -g serve @lhci/cli

EXPOSE 3000

CMD ["serve", "-s", "dist", "-l", "3000"]
