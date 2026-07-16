import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../test_api/post_model.dart';

class ApiServiceDio{
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://jsonplaceholder.typicode.com',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
  ));

  ApiServiceDio(){
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false, //đỡ rối log
        error: true,
        compact: true, // Gom gọn log lại cho dễ nhìn
        maxWidth: 90, // Độ rộng tối đa của dòng kẻ phân cách log
      )
    );
  }

  Future<List<Post>> getPost() async{
    try{
      final response = await _dio.get('/posts');
      final List<dynamic> data = response.data;

      return data.map((json) => Post.fromJson(json)).toList();
    }on DioException catch (e){
      throw Exception('Không thể tải danh sách bài viết! : ${e.message}');
    }
  }

  Future<Post> createPost(Post post) async{
    try{
      final response = await _dio.post(
        '/posts',
        data: post.toJson(),
      );
      return Post.fromJson(response.data);
    }
    on DioException catch (e){
      throw Exception('Không thể tạo bài viết mới! : ${e.message}');
    }
  }

  Future<Post> updatePost(Post post) async{
    if(post.id! <= 100){
      try {
        final response = await _dio.put(
          '/posts/${post.id}',
          data: post.toJson(),
        );

        return Post.fromJson(response.data);
      } on DioException catch (e) {
        throw Exception('Không thể cập nhật bài viết! : ${e.message}');
      }
    }else{
      //giả lập độ trễ mạng
      await Future.delayed(Duration(milliseconds: 500));
      return post;
    }
  }

  Future<void> deletePost(int id) async{
    if(id <= 100){
      try{
        await _dio.delete('/posts/$id');
      }on DioException catch (e) {
        throw Exception('Không thể kết nối tới máy chủ để xóa! : ${e.message}');
      }
    } else{
      //giả lập độ trễ mạng
      await Future.delayed(Duration(milliseconds: 500));
    }
  }
}