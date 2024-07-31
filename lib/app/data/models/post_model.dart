class Post {
  String? id;
  String? userId;
  String? userName;
  String? description;
  String? imageUrl;
  double? votePercentage;
  String? createdAt;
  String? updatedAt;

  Post(
      {this.id,
      this.userId,
      this.userName,
      this.description,
      this.imageUrl,
      this.votePercentage,
      this.createdAt,
      this.updatedAt});

  Post.fromJson(Map<String, dynamic> json, this.id) {
    userId = json['userId'];
    userName = json['userName'];
    description = json['description'];
    imageUrl = json['imageUrl'];
    votePercentage = json['votePercentage'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['userName'] = userName;
    data['description'] = description;
    data['imageUrl'] = imageUrl;
    data['votePercentage'] = votePercentage;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'userName': userName,
      'description': description,
      'imageUrl': imageUrl,
      'votePercentage': votePercentage,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map, String id) {
    return Post(
      id: id,
      userId: map['userId'] != null ? map['userId'] as String : null,
      userName: map['userName'] != null ? map['userName'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      votePercentage: map['votePercentage'] != null
          ? map['votePercentage'] as double
          : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
    );
  }

  @override
  String toString() {
    return 'Post(id: $id, userId: $userId, userName: $userName, description: $description, imageUrl: $imageUrl, votePercentage: $votePercentage, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
