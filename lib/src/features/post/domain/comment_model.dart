class CommentModel {
  final String id;
  final String text;
  final String postId;
  final String createdBy;
  final DateTime createdAt;

  const CommentModel({
    required this.id,
    required this.text,
    required this.postId,
    required this.createdBy,
    required this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        id: json['id'],
        text: json['text'],
        postId: json['postId'],
        createdBy: json['createdBy'],
        createdAt: DateTime.parse(json['createdAt']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'postId': postId,
        'createdBy': createdBy,
        'createdAt': createdAt.toIso8601String(),
      };
}
