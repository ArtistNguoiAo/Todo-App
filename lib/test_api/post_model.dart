

class Post{
  final int? id;
  final String title;
  final String body;
  final int? userId;

  Post({this.id, required this.title, required this.body, this.userId});

  factory Post.fromJson(Map<String, dynamic> json){
    return Post(
      id: json['id'],
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return{
      if(id != null) 'id': id,
      'title': title,
      'body': body,
      if(userId != null) 'userId': userId
    };
  }
}