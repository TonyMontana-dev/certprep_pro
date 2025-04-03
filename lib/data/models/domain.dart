class Domain {
  final int? id;
  final int examId;
  final String name;

  Domain({this.id, required this.examId, required this.name});

  Map<String, dynamic> toMap() =>
      {'id': id, 'exam_id': examId, 'name': name};

  factory Domain.fromMap(Map<String, dynamic> map) => Domain(
        id: map['id'],
        examId: map['exam_id'],
        name: map['name'],
      );
}
