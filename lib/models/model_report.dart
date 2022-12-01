enum ReportType { profile, chat, post, review, replay }

class ReportModel {
  final String reportedId;
  final String title;
  final String description;
  final ReportType type;

  ReportModel({
    required this.reportedId,
    required this.title,
    required this.description,
    required this.type,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    ReportType type = ReportType.profile;
    if (json['type'] != null) {
      type = ReportType.values[json['type']];
    }
    return ReportModel(
      reportedId: json['reportedId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: type,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "reportedId": reportedId,
      'title': title,
      'description': description,
      'type': type.index
    };
  }
}
