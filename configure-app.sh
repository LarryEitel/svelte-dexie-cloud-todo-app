#!/bin/bash -e
if [ ! -f "./dexie-cloud.json" ]; then
    echo "Please run:"
    echo "  npx dexie-cloud create"
    echo "or: "
    echo "  npx dexie-cloud connect <DB-URL>"
    echo "...to create a database in the cloud"
    echo "Then retry this script!"
    exit 1;
fi
echo "Adding demo users to your application..."
npx dexie-cloud import src/data/importfile.json
echo "Whitelisting origin: http://localhost:5173"
npx dexie-cloud whitelist http://localhost:5173
echo "Whitelisting origin: https://localhost:3000"
npx dexie-cloud whitelist https://localhost:3000
echo "Whitelisting origin: https://todo.eitel.com"
npx dexie-cloud whitelist https://todo.eitel.com
DB_URL=$(node -p "require('./dexie-cloud.json').dbUrl")
echo ""
echo "Configuring .env.local: VITE_PUBLIC_DEXIE_CLOUD_DBURL=$DB_URL"
echo "VITE_PUBLIC_DEXIE_CLOUD_DBURL=$DB_URL" > .env.local
echo "FAST_REFRESH=false" >> .env.local
echo ""
echo "Application is now configured!"
echo "Use 'pnpm install' if you haven't done so already."
echo "Use 'pnpm dev' to start the app."
