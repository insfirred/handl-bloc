import 'package:image_picker/image_picker.dart';

import 'comment_model.dart';
import 'post.dart';

abstract class PostRepo {
  Stream<List<Post>> fetchAllPosts({String? uid});

  Future<void> addPost(String? text, XFile? imageUrl);

  Future<void> deletePost(String postId);

  Future<void> likePost(String postId);

  Future<void> commentOnPost(String postId, String commentText);

  Stream<List<CommentModel>> fetchComments(String postId);
}
