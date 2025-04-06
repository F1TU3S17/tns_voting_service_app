class QuestionShort {
  final String id;
  final String title;
  final String description;
  final String departmentId;
  final int votersCount;
  final int votersTotal;
  final DateTime endDate;

  QuestionShort({
    required this.id,
    required this.title,
    required this.description,
    required this.departmentId,
    required this.votersCount,
    required this.votersTotal,
    required this.endDate,
  });

  factory QuestionShort.fromJson(Map<String, dynamic> json) {
    return QuestionShort(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      departmentId: json['departmentId'],
      votersCount: json['votersCount'],
      votersTotal: json['votersTotal'],
      endDate: DateTime.parse(json['endDate']),
    );
  }
}

class FileInfo {
  final String id;
  final String name;

  FileInfo({
    required this.id,
    required this.name,
  });

  factory FileInfo.fromJson(Map<String, dynamic> json) {
    return FileInfo(
      id: json['id'],
      name: json['name'],
    );
  }
}

enum VotingType { com, bod }
enum VotingWay { majority, unanimous }

class QuestionDetail {
  final String id;
  final String title;
  final String description;
  final String departmentId;
  final List<FileInfo> files;
  final int votersCount;
  final int votersTotal;
  final VotingType votingType;
  final VotingWay votingWay;
  final String? conferenceLink;

  QuestionDetail({
    required this.id,
    required this.title,
    required this.description,
    required this.departmentId,
    required this.files,
    required this.votersCount,
    required this.votersTotal,
    required this.votingType,
    required this.votingWay,
    required this.conferenceLink,
  });

  String get votingTypeText {
    switch (votingType) {
      case VotingType.com:
        return 'Комитет';
      case VotingType.bod:
        return 'Совет директоров';
    }
  }

  String get votingWayText {
    switch (votingWay) {
      case VotingWay.majority:
        return 'Большинство голосов';
      case VotingWay.unanimous:
        return 'Единогласие';
    }
  }

  factory QuestionDetail.fromJson(Map<String, dynamic> json) {
    return QuestionDetail(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      departmentId: json['departmentId'],
      files: (json['files'] as List)
          .map((fileJson) => FileInfo.fromJson(fileJson))
          .toList(),
      votersCount: json['votersCount'],
      votersTotal: json['votersTotal'],
      votingType: json['votingType'] == 'com' ? VotingType.com : VotingType.bod,
      votingWay: json['votingWay'] == 'majority'
          ? VotingWay.majority
          : VotingWay.unanimous,
      conferenceLink: json['conferenceLink'],
    );
  }
}
