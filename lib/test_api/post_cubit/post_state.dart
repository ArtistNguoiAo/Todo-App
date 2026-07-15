part of 'post_cubit.dart';

class PostState{
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final List<Post> posts;

  PostState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.posts = const [],
});

  PostState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    List<Post>? posts,
}){
    return PostState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
      posts: posts ?? this.posts,
    );
  }
}