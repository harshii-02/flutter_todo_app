import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> toDoList = [];
  final TextEditingController newTaskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tasks', jsonEncode(toDoList));
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('tasks');
    if (jsonString != null) {
      setState(() {
        toDoList = List<Map<String, dynamic>>.from(jsonDecode(jsonString));
      });
    }
  }

  void addTask(String task) {
    if (task.trim().isEmpty) return;
    setState(() {
      toDoList.add({'task': task.trim(), 'completed': false});
      newTaskController.clear();
    });
    saveData();
  }

  void deleteTask(int index) {
    setState(() {
      toDoList.removeAt(index);
    });
    saveData();
  }

  void toggleTask(int index) {
    setState(() {
      toDoList[index]['completed'] = !toDoList[index]['completed'];
    });
    saveData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My To-Do List'),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: newTaskController,
                    decoration: InputDecoration(
                      hintText: 'Enter a new task',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onSubmitted: addTask,
                  ),
                ),
                const SizedBox(width: 10),
                FloatingActionButton(
                  onPressed: () => addTask(newTaskController.text),
                  child: const Icon(Icons.add),
                  mini: true,
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: toDoList.length,
              itemBuilder: (context, index) {
                final task = toDoList[index]['task'];
                final completed = toDoList[index]['completed'];

                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerRight,
                    child: const Icon(Icons.delete, color: Colors.yellow),
                  ),
                  onDismissed: (_) => deleteTask(index),
                  child: Card(
                    elevation: 3,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      leading: Checkbox(
                        value: completed,
                        onChanged: (_) => toggleTask(index),
                      ),
                      title: Text(
                        task,
                        style: TextStyle(
                          fontSize: 16,
                          decoration: completed
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: completed ? Colors.grey : Colors.black,
                        ),
                      ),
                      onTap: () => toggleTask(index),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
