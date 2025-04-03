class Exam {
  final int? id;
  final String title;

  Exam({this.id, required this.title});

  Map<String, dynamic> toMap() => {'id': id, 'title': title};

  factory Exam.fromMap(Map<String, dynamic> map) =>
      Exam(id: map['id'], title: map['title']);
}
