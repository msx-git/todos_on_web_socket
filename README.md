# WebSocket-based Todo App in Flutter

This repository contains a Flutter project that demonstrates real-time todo management using WebSockets. The app connects to a WebSocket server, receives updates for todos in real-time, and allows users to add, toggle, and delete todos through the WebSocket connection.

### Features:
- **Real-time Sync**: Todos are updated in real-time via a WebSocket connection.
- **Stream-based Architecture**: Efficiently handles real-time updates using `StreamBuilder` and `StreamController`.
- **Todo Management**: Add new todos, mark todos as completed or uncompleted, and delete todos.
- **WebSocket Integration**: Uses `socket_io_client` to establish a connection with the WebSocket server and emit or listen for events.
- **Responsive UI**: The app displays todos in a clean, responsive UI with real-time feedback.

### How it works:
1. Connects to a WebSocket server on app startup.
2. Listens for incoming todo updates from the server.
3. Allows users to emit events to add, toggle, and delete todos.
4. Updates the UI in real-time based on the server's response.

### Technologies:
- **Flutter**: Front-end framework for building the mobile interface.
- **WebSockets**: Enables real-time communication between the client and server using the `socket_io_client` package.

### How to Run:
1. Clone the repository.
2. Set up a WebSocket server (or use the example server provided).
3. Run the app on a device or emulator using `flutter run`.

Feel free to customize and enhance this project to suit your needs!
