class Task {
  final String id;
  final String matkul;
  final String deskripsi;
  final DateTime deadline;
  final bool isDone;

  Task({
    required this.id,
    required this.matkul,
    required this.deskripsi,
    required this.deadline,
    required this.isDone,
  });

  /// dari Supabase (Map) ke Object
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      matkul: map['matkul'],
      deskripsi: map['deskripsi'],
      deadline: DateTime.parse(map['deadline']),
      isDone: map['is_done'],
    );
  }

  /// dari Object ke Map (untuk insert/update)
  Map<String, dynamic> toMap() {
    return {
      'matkul': matkul,
      'deskripsi': deskripsi,
      'deadline': deadline.toIso8601String(),
      'is_done': isDone,
    };
  }
}
