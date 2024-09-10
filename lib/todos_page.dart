import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

class TodosPage extends StatefulWidget {
  const TodosPage({super.key});

  @override
  State<TodosPage> createState() => _TodosPageState();
}

class _TodosPageState extends State<TodosPage> {
  late Socket socket;
  final todosStream = StreamController();

  @override
  void initState() {
    super.initState();
    connectToServer();
  }

  @override
  void dispose() {
    // Ensure the stream controller is properly closed to avoid memory leaks
    todosStream.close();
    socket.dispose();
    super.dispose();
  }

  void connectToServer() {
    const url = "https://9920-89-236-218-41.ngrok-free.app/";

    socket = io(url, {
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();
    socket.onConnect((_) => debugPrint("Connected to server"));

    // Listen for todos update from server
    socket.on("todos",
        (data) => todosStream.add(List<Map<String, dynamic>>.from(data)));

    socket.onDisconnect((_) => debugPrint("Disconnected from server"));
  }

  // Emit addTodo event to server
  void addTodo(String todoTitle) => socket.emit('add_todo', todoTitle);

  // Emit deleteTodo event to server
  void deleteTodo(int index) => socket.emit('remove_todo', index);

  // Emit toggleTodo event to server
  void toggleTodo(int index) => socket.emit('toggle_todo', index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todos from WebSocket')),
      body: StreamBuilder(
        stream: todosStream.stream,
        builder: (context, snapshot) {
          // Show loading spinner while waiting for data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Handle error or no data case
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text("Couldn't fetch todos"));
          }

          final socketTodos = snapshot.data!; // data is non-null by this point

          // Show message if there are no todos
          if (socketTodos.isEmpty) {
            return const Center(child: Text("There are no todos"));
          }

          // Display list of todos
          return ListView.builder(
            itemCount: socketTodos.length,
            itemBuilder: (context, index) {
              final todo = socketTodos[index];
              return ListTile(
                title: Text(
                  todo['text'],
                  style: TextStyle(
                    decoration:
                        todo['completed'] ? TextDecoration.lineThrough : null,
                  ),
                ),
                trailing: IconButton(
                  onPressed: () => deleteTodo(index),
                  icon: const Icon(
                    CupertinoIcons.delete,
                    color: Colors.redAccent,
                  ),
                ),
                onTap: () => toggleTodo(index),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addTodo("New Todo"),
        child: const Icon(Icons.add),
      ),
    );
  }
}
