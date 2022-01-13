# Production image, copy all the files and run next
FROM node:14.17.3-alpine AS runner
WORKDIR /app

ENV NODE_ENV production

RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001

# Copy the build output to replace the default nginx contents.
COPY --from=build /app/packages/web/next.config.js ./
COPY --from=build /app/packages/web/public ./public
COPY --from=build --chown=nextjs:nodejs /app/packages/web/.next ./.next
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/packages/web/package.json ./package.json

USER nextjs

EXPOSE 3000

CMD ["yarn", "start:prod"]
