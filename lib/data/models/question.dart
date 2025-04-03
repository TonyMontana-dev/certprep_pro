class Question {
  final int? id;
  final int examId;
  final int domainId;
  final String question;
  final String? explanation;

  Question({
    this.id,
    required this.examId,
    required this.domainId,
    required this.question,
    this.explanation,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'exam_id': examId,
        'domain_id': domainId,
        'question': question,
        'explanation': explanation,
      };

  factory Question.fromMap(Map<String, dynamic> map) => Question(
        id: map['id'],
        examId: map['exam_id'],
        domainId: map['domain_id'],
        question: map['question'],
        explanation: map['explanation'],
      );
}
