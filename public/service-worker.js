// Force service worker update with version
const SW_VERSION = 'v1.0.2';
console.log('Service Worker Version:', SW_VERSION);

self.addEventListener("push", function(event) {
  console.log('🔔 PUSH EVENT RECEIVED in service worker!', event);
  console.log('Event data exists:', !!event.data);
  
  // Send message to main thread immediately (no await)
  self.clients.matchAll().then(clients => {
    clients.forEach(client => {
      client.postMessage({
        type: 'PUSH_RECEIVED',
        message: 'Push event received in service worker'
      });
    });
  });
  
  let data = {};
  
  if (event.data) {
    try {
      data = event.data.json();
      console.log('Push data:', data);
    } catch (e) {
      console.error('Failed to parse push data as JSON:', e);
      data = {
        title: 'New Notification',
        body: event.data.text() || 'You have a new message',
        url: '/'
      };
    }
  } else {
    data = {
      title: 'New Notification',
      body: 'You have a new message',
      url: '/'
    };
  }

  // Create completely fresh notification options
  const notificationId = 'push-' + Date.now() + '-' + Math.random();
  console.log('Creating notification with ID:', notificationId);
  
  const options = {
    body: data.body || 'Default notification body',
    icon: data.icon || "/favicon.ico",
    // Remove tag completely - this was causing auto-close
    requireInteraction: true, // Keep notification visible
    silent: false,
    vibrate: [300, 100, 300],
    timestamp: Date.now(),
    data: { 
      url: data.url || '/',
      notificationId: notificationId
    }
  };

  console.log('Showing notification with options:', options);

  // Show notification immediately without waiting for message sending
  const notificationPromise = self.registration.showNotification(data.title || 'New Notification', options);
  
  // Send success/error messages without blocking notification display
  notificationPromise
    .then(() => {
      console.log('✅ showNotification() completed successfully');
      // Send success message (non-blocking)
      self.clients.matchAll().then(clients => {
        clients.forEach(client => {
          client.postMessage({
            type: 'NOTIFICATION_SHOWN',
            message: 'Notification appeared',
            title: data.title
          });
        });
      });
    })
    .catch(error => {
      console.error('❌ showNotification() failed:', error);
      // Send error message (non-blocking)
      self.clients.matchAll().then(clients => {
        clients.forEach(client => {
          client.postMessage({
            type: 'NOTIFICATION_ERROR',
            message: error.message
          });
        });
      });
    });

  event.waitUntil(notificationPromise);
});

self.addEventListener("notificationclick", function(event) {
  console.log('Notification clicked:', event);
  
  event.notification.close();

  if (event.action === 'open' || !event.action) {
    // Open or focus the app window
    event.waitUntil(
      clients.matchAll({ type: 'window', includeUncontrolled: true }).then(function(clientList) {
        const url = event.notification.data.url || '/';
        
        // Check if there's already a window/tab open with our app
        for (let i = 0; i < clientList.length; i++) {
          const client = clientList[i];
          if (client.url.includes(url) && 'focus' in client) {
            return client.focus();
          }
        }
        
        // If no existing window, open a new one
        if (clients.openWindow) {
          return clients.openWindow(url);
        }
      })
    );
  }
  // 'close' action just closes the notification (default behavior)
});

self.addEventListener("notificationclose", function(event) {
  console.log('Notification closed:', event);
});
