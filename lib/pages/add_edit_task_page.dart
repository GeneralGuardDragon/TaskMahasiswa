import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class AddEditTaskPage extends StatefulWidget {
  final Task? task;

  const AddEditTaskPage({super.key, this.task});

  @override
  State<AddEditTaskPage> createState() => _AddEditTaskPageState();
}

class _AddEditTaskPageState extends State<AddEditTaskPage> {
  final _matkulController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final TaskService _taskService = TaskService();

  DateTime? _deadline;
  bool _loading = false;

  @override
  void initState() {
    super.initState();

    // kalau edit, isi form dengan data lama
    if (widget.task != null) {
      _matkulController.text = widget.task!.matkul;
      _deskripsiController.text = widget.task!.deskripsi;
      _deadline = widget.task!.deadline;
    }
  }

  Future<void> _saveTask() async {
    if (_matkulController.text.isEmpty ||
        _deskripsiController.text.isEmpty ||
        _deadline == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field wajib diisi')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      if (widget.task == null) {
        // CREATE
        await _taskService.addTask(
          matkul: _matkulController.text,
          deskripsi: _deskripsiController.text,
          deadline: _deadline!,
        );
      } else {
        // UPDATE
        await _taskService.updateTask(
          Task(
            id: widget.task!.id,
            matkul: _matkulController.text,
            deskripsi: _deskripsiController.text,
            deadline: _deadline!,
            isDone: widget.task!.isDone,
          ),
        );
      }

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }

    setState(() => _loading = false);
  }

  Future<void> _pickDeadline() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _deadline ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() => _deadline = date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.task != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Tugas' : 'Tambah Tugas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _matkulController,
              decoration: const InputDecoration(labelText: 'Mata Kuliah'),
            ),
            TextField(
              controller: _deskripsiController,
              decoration: const InputDecoration(labelText: 'Deskripsi'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _deadline == null
                        ? 'Deadline belum dipilih'
                        : 'Deadline: ${_deadline!.toLocal().toString().split(' ')[0]}',
                  ),
                ),
                TextButton(
                  onPressed: _pickDeadline,
                  child: const Text('Pilih Deadline'),
                )
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : _saveTask,
              child: _loading
                  ? const CircularProgressIndicator()
                  : Text(isEdit ? 'Update' : 'Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
