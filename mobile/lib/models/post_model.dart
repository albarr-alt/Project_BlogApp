class PostModel {
  final int id;
  final int userId;
  final String title;
  final String content;
  final String? imageUrl;
  final String? imagePublicId;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? username;

  PostModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    this.imageUrl,
    this.imagePublicId,
    this.status = 'published',
    this.createdAt,
    this.updatedAt,
    this.username,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      userId: json['userId'] is int
          ? json['userId']
          : json['user_id'] is int
              ? json['user_id']
              : int.tryParse(json['userId']?.toString() ?? json['user_id']?.toString() ?? '0') ?? 0,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['imageUrl'] ?? json['image_url'],
      imagePublicId: json['imagePublicId'] ?? json['image_public_id'],
      status: json['status'] ?? 'published',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : json['created_at'] != null
              ? DateTime.tryParse(json['created_at'].toString())
              : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : json['updated_at'] != null
              ? DateTime.tryParse(json['updated_at'].toString())
              : null,
      username: json['username'] ?? json['author'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
