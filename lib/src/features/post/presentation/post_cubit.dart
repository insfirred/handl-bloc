import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../data/post_repo_impl.dart';
import '../domain/comment_model.dart';
import '../domain/post.dart';
import 'add_post_state.dart';

class PostCubit extends Cubit<AddPostState> {
  PostCubit(super.initialState);

  final postRepo = PostRepoImpl();

  Stream<List<Post>> fetchPosts({String? uid}) {
    try {
      return postRepo.fetchAllPosts(uid: uid);
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  Future<void> addPost(String? text, XFile? image) async {
    try {
      emit(AddPostLoading());
      await postRepo.addPost(text, image);
      emit(AddPostLoaded());
    } catch (e) {
      log(e.toString());
      emit(AddPostError(e.toString()));
    }
  }

  Future<void> likePost(String postId) async {
    try {
      await postRepo.likePost(postId);
    } catch (e) {
      log(e.toString());
    }
  }

  Stream<List<CommentModel>> fetchComments(String postId) {
    try {
      return postRepo.fetchComments(postId);
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  Future<void> commentOnPost(String postId, String commentText) async {
    try {
      emit(AddPostLoading());
      await postRepo.commentOnPost(postId, commentText);
      emit(AddPostLoaded());
    } catch (e) {
      log(e.toString());
      emit(AddPostError(e.toString()));
    }
  }
}
