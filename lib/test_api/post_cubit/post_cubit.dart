import 'package:bloc/bloc.dart';
import 'package:todo_app/test_api/post_model.dart';
import 'package:todo_app/test_api/post_respository.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepository respository;

  PostCubit(this.respository) : super(PostState());

  Future<void> fetchPosts() async{
    emit(state.copyWith(
      isLoading: true,
      isSuccess: false,
      errorMessage: null
    ));
    try{
      final posts = await respository.getPost();
      emit(state.copyWith(
        isLoading: false,
        isSuccess: true,
        posts: posts
      ));
    } catch(e) {
      emit(state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> addPost(String title, String body) async{
    try{
      final newPostData = Post(title: title, body: body, userId: 1);
      final createdPost = await respository.createPost(newPostData);

      final updatedList = List<Post>.from(state.posts)..insert(0, createdPost);
      emit(state.copyWith(posts: updatedList));
    } catch(e){
      emit(state.copyWith(errorMessage: 'Thêm thất bại: $e'));
    }
  }

  Future<void> editPost(int id, String newTitle, String newBody) async {
    try {
      final postToUpdate = Post(id: id, title: newTitle, body: newBody, userId: 1);
      final updatedPost = await respository.updatePost(postToUpdate);

      final updatedList = state.posts.map((post) {
        return post.id == id ? updatedPost : post;
      }).toList();

      emit(state.copyWith(
        isLoading: false,
        isSuccess: true,
        posts: updatedList,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Cập nhật thất bại: $e',
      ));
    }
  }

  Future<void> removePost(int id) async{
    try{
      await respository.deletePost(id);
      final updatedList = state.posts.where((post) => post.id != id).toList();
      emit(state.copyWith(posts: updatedList, errorMessage: null));
    } catch(e){
      emit(state.copyWith(errorMessage: 'Xoá thất bại: $e'));
    }
  }
}
