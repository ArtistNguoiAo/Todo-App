import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/test_api/post_model.dart';

class PostRepository{
  final String _baseUrl = 'https://jsonplaceholder.typicode.com/';

  Future<List<Post>> getPost() async{
    final response = await http.get(Uri.parse('$_baseUrl/posts'));

    if(response.statusCode == 200){
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Post.fromJson(item)).toList();
    }else{
      throw Exception('Không thể tải danh sách bài viết!');
    }
  }

  Future<Post> createPost(Post post) async{
    final response = await http.post(
        Uri.parse('$_baseUrl/posts'),
        headers: {'Content-type': 'application/json; charset=UTF-8'},
        body: jsonEncode(post.toJson()),
    );

    if(response.statusCode == 201){
      return Post.fromJson(jsonDecode(response.body));
    }else{
      throw Exception('Không thể tạo bài viết mới!');
    }
  }

  Future<Post> updatePost(Post post) async{
    final response = await http.put(
      Uri.parse('$_baseUrl/posts/${post.id}'),
      headers: {'Content-type': 'application/json; charset=UTF-8'},
      body: jsonEncode(post.toJson()),
    );

    if(response.statusCode == 200){
      return Post.fromJson(jsonDecode(response.body));
    }else{
      throw Exception('Không thể cập nhật bài viết!');
    }
  }

  Future<void> deletePost(int id) async{
    if(id<100){
      try{
        final response = await http.delete(Uri.parse('$_baseUrl/post/$id'));

        if (response.statusCode < 200 || response.statusCode >= 300) {
          throw Exception('Server trả về mã lỗi: ${response.statusCode}');
        }
      } catch (e) {
        debugPrint('Lỗi kết nối khi xóa: $e');
        throw Exception('Không thể kết nối tới máy chủ để xóa.');
      }
    } else{
      //giả lập độ trễ mạng
      await Future.delayed(Duration(milliseconds: 500));
    }

  }
}