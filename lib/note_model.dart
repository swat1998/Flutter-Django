class Note {
  final int id;
  final String? note;

  Note({
    required this.id,
    this.note,
  });

  Note copyWith({
    int? id,
    String? note,
  }) {
    return Note(
      id: id ?? this.id,
      note: note ?? this.note,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Note && other.id == id && other.note == note;
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'note': note,
    };
  }

  @override
  int get hashCode => id.hashCode ^ note.hashCode;

  @override
  String toString() => 'Note id: $id, note: $note';
}
