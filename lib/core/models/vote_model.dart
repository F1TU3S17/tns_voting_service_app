class VoteRequest {
  final String questionId;
  final int answerId; // 0, 1, or 2

  VoteRequest({
    required this.questionId,
    required this.answerId,
  });

  Map<String, dynamic> toJson() => {
        'questionId': questionId,
        'answerId': answerId,
      };
}
