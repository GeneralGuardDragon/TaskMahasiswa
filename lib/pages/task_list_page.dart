import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';
import '../services/auth_service.dart';
import 'add_edit_task_page.dart';
import 'login_page.dart';
import '../widgets/task_card.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final TaskService _taskService = TaskService();
  final AuthService _authService = AuthService();

  List<Task> _tasks = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await _taskService.getTasks();
    setState(() {
      _tasks = tasks;
      _loading = false;
    });
  }

  Future<void> _logout() async {
    await _authService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tugas Kuliah'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          )
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _tasks.isEmpty
              ? const Center(child: Text('Belum ada tugas'))
              : ListView.builder(
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    final task = _tasks[index];
                      return TaskCard(
                        task: task,
                        onToggle: () async {
                          await _taskService.toggleTaskStatus(task);
                          _loadTasks();
                        },
                        onDelete: () async {
                          await _taskService.deleteTask(task.id);
                          _loadTasks();
                        },
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddEditTaskPage(task: task),
                            ),
                          ).then((_) => _loadTasks());
                        },
                      );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddEditTaskPage(),
            ),
          ).then((_) => _loadTasks());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
