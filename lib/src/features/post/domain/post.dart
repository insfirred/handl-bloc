class Post {
  final String id;
  final String? text;
  final String? imageUrl;
  final String createdBy;
  final DateTime createdAt;
  final List<String> likes;
  final List<String> comments;

  const Post({
    required this.id,
    this.text,
    this.imageUrl,
    required this.createdBy,
    required this.createdAt,
    required this.likes,
    required this.comments,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json['id'],
        text: json['text'],
        imageUrl: json['imageUrl'],
        createdBy: json['createdBy'],
        createdAt: DateTime.parse(json['createdAt']),
        likes: (json['likes'] as List).map((e) => e as String).toList(),
        comments: (json['comments'] as List).map((e) => e as String).toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'imageUrl': imageUrl,
        'createdBy': createdBy,
        'createdAt': createdAt.toIso8601String(),
        'likes': likes,
        'comments': comments,
      };
}
