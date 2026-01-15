import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/task.dart';

class TaskService {
  final SupabaseClient _client = Supabase.instance.client;

  /// READ - ambil semua task milik user login
  Future<List<Task>> getTasks() async {
    final user = _client.auth.currentUser;
    if (user == null) return [];

    final response = await _client
        .from('tasks')
        .select()
        .eq('user_id', user.id)
        .order('deadline', ascending: true);

    return (response as List)
        .map((task) => Task.fromMap(task))
        .toList();
  }

  /// CREATE - tambah task
  Future<void> addTask({
    required String matkul,
    required String deskripsi,
    required DateTime deadline,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('User belum login');

    await _client.from('tasks').insert({
      'user_id': user.id,
      'matkul': matkul,
      'deskripsi': deskripsi,
      'deadline': deadline.toIso8601String(),
      'is_done': false,
    });
  }

  /// UPDATE - edit task
  Future<void> updateTask(Task task) async {
    await _client.from('tasks').update({
      'matkul': task.matkul,
      'deskripsi': task.deskripsi,
      'deadline': task.deadline.toIso8601String(),
      'is_done': task.isDone,
    }).eq('id', task.id);
  }

  /// DELETE - hapus task
  Future<void> deleteTask(String taskId) async {
    await _client.from('tasks').delete().eq('id', taskId);
  }

  /// TOGGLE SELESAI / BELUM
  Future<void> toggleTaskStatus(Task task) async {
    await _client.from('tasks').update({
      'is_done': !task.isDone,
    }).eq('id', task.id);
  }
}
