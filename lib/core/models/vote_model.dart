class VoteRequest {
  final int answerId; // 0, 1, or 2

  VoteRequest({
    required this.answerId,
  });

  Map<String, dynamic> toJson() => {
        'decision': answerId,
      };
}
