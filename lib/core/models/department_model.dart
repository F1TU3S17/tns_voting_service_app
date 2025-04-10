class Department {
  final int id;
  final String name;
  int? voteCount;

  Department({
    required this.id,
    required this.name,
    this.voteCount = 0,
  });

  Department copyWith({
    int? id,
    String? name,
    int? voteCount,
  }) {
    return Department(
      id: id ?? this.id,
      name: name ?? this.name,
      voteCount: voteCount ?? this.voteCount,
    );
  }

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'],
      name: json['name'],
      voteCount: json['question_count'] ?? 0,
    );
  }
}
