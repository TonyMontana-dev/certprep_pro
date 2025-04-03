class Answer {
  final int? id;
  final int questionId;
  final String answer;
  final bool isCorrect;

  Answer({
    this.id,
    required this.questionId,
    required this.answer,
    required this.isCorrect,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'question_id': questionId,
        'answer': answer,
        'is_correct': isCorrect ? 1 : 0,
      };

  factory Answer.fromMap(Map<String, dynamic> map) => Answer(
        id: map['id'],
        questionId: map['question_id'],
        answer: map['answer'],
        isCorrect: map['is_correct'] == 1,
      );
}
