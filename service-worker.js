const CACHE = 'b98c684d0b29b41861d9e1bb93c270f1616b834888475c063456a572fa3aa5c6';
const RUNTIME = 'runtime';
const PRECACHE_URLS = ['/icon-512x512.png',
'/icon-192x192.png',
'/icon-120x120.png',
'/icon-256x256.png',
'/icon-152x152.png',
'/icon-32x32.png',
'/icon-128x128.png',
'/external-stylesheets.css',
'/icon-96x96.png',
'/icon-16x16.png',
'/icon-57x57.png',
'/icon-72x72.png',
'/icon-144x144.png',
'/icon-167x167.png',
'/index.js',
'/manifest.webmanifest',
'/icon-196x196.png',
'/icon-76x76.png',
'/icon-48x48.png',
'/icon-180x180.png',
'/icon-36x36.png',
'/index.html'];

// On install precache all static resources
self.addEventListener('install', event => {
  event.waitUntil(
    caches
      .open(CACHE)
      .then(cache =>  {
        const promises =
          PRECACHE_URLS.map((url) =>
            cache
              .add(url)
              .catch(error => console.log(`Could not cache: ${url} - ${error}!`))
          )

        return Promise.all(promises)
      })
      .then(self.skipWaiting())
  );
});

// On activate remove all unused caches
self.addEventListener('activate', function(event) {
  event.waitUntil(
    caches.keys().then(cacheNames => {
      return cacheNames.filter(cacheName => cacheName !== CACHE);
    }).then(cachesToDelete => {
      return Promise.all(cachesToDelete.map(cacheToDelete => {
        return caches.delete(cacheToDelete);
      }));
    }).then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', event => {
  const url = event.request.url
  const origin = self.location.origin
  const isSameOrigin = url.startsWith(origin)
  let response = null

  // If we are on the same origin
  if (isSameOrigin) {
    // resolve the path
    const path = url.slice(origin.length)

    // Try to get the response from the cache if not available fall back to
    // the "index.html" file.
    response =
      caches
        .match(event.request)
        .then(cachedResponse => cachedResponse || caches.match("/index.html"))
  } else {
    response = fetch(event.request)
  }

  event.respondWith(response)
});