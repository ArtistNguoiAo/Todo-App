import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/test_api/post_cubit/post_cubit.dart';
import 'package:todo_app/test_api/post_respository.dart';
import '../utils/string_utils.dart';
import '../widget/dialog.dart';
import 'post_model.dart';

class PostPage extends StatelessWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => PostRepository(),
      child: BlocProvider(
        create: (context) => PostCubit(context.read<PostRepository>())..fetchPosts(),
        child: const PostView(),
      ),
    );
  }
}

class PostView extends StatelessWidget {
  const PostView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test call API với http'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<PostCubit>().fetchPosts(),
          )
        ],
      ),
      body: BlocConsumer<PostCubit, PostState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
         if (state.isSuccess || state.posts.isNotEmpty) {
            final posts = state.posts;
            if (posts.isEmpty) return const Center(child: Text('Danh sách trống'));

            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: CircleAvatar(child: Text(post.id?.toString() ?? 'N/A')),
                    title: Text(post.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text(post.body, maxLines: 1, overflow: TextOverflow.ellipsis),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            final cubit = context.read<PostCubit>();
                            _showDialog(context, postCubit: cubit, post: post);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            if (post.id != null) {
                              AppDialog.showConfirmDialog(
                                context: context,
                                onDelete: () async{
                                  context.read<PostCubit>().removePost(post.id!);
                                },
                                text: StringUtils.delete,
                                content: StringUtils.confirmDelete,
                              );

                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: Text('Bấm nút refresh để tải dữ liệu'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final cubit = context.read<PostCubit>();
          _showDialog(context, postCubit: cubit);
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showDialog(BuildContext context, {required PostCubit postCubit, Post? post}) {
    final isEdit = post != null;
    final titleController = TextEditingController(text: isEdit ? post.title : '');
    final bodyController = TextEditingController(text: isEdit ? post.body : '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? 'Cập nhật bài viết' : 'Thêm bài viết mới'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Tiêu đề')),
            const SizedBox(height: 10),
            TextField(controller: bodyController, decoration: const InputDecoration(labelText: 'Nội dung'), maxLines: 3),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () {
              final title = titleController.text.trim();
              final body = bodyController.text.trim();
              if (title.isNotEmpty && body.isNotEmpty) {
                if (isEdit) {
                  postCubit.editPost(post.id!, title, body);
                } else {
                  postCubit.addPost(title, body);
                }
                Navigator.pop(context);
              }
            },
            child: Text(isEdit ? 'Cập nhật' : 'Thêm'),
          )
        ],
      ),
    );
  }
}