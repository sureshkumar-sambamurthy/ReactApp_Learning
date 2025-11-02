FROM node:20 AS builder
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build

FROM zenika/alpine-chrome:with-node
WORKDIR /app
COPY --from=builder /app/dist ./dist
RUN npm install -g serve @lhci/cli
COPY .lighthouserc.json ./
EXPOSE 3000
CMD ["serve", "-s", "dist", "-l", "3000"]