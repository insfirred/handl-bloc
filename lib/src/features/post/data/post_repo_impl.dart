import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:handl_bloc/src/features/post/domain/post.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/comment_model.dart';
import '../domain/post_repo.dart';

class PostRepoImpl implements PostRepo {
  final storage = FirebaseStorage.instance;
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  @override
  Future<void> addPost(String? text, XFile? image) async {
    try {
      DateTime now = DateTime.now();

      Post post = Post(
        id: '',
        text: text,
        createdBy: auth.currentUser!.uid,
        createdAt: now,
        likes: [],
        comments: [],
      );

      var postRef = await firestore.collection('posts').add(post.toJson());

      String? imageUrl = image != null
          ? await _uploadImageAndGenerateUrl(File(image.path), postRef.id)
          : null;

      await postRef.update({
        'id': postRef.id,
        'imageUrl': imageUrl,
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> commentOnPost(String postId, String commentText) async {
    try {
      DateTime now = DateTime.now();
      String uid = auth.currentUser!.uid;

      CommentModel post = CommentModel(
        id: '',
        text: commentText,
        postId: postId,
        createdBy: uid,
        createdAt: now,
      );

      var commenttRef = await firestore
          .collection('comments')
          .doc(postId)
          .collection('commentsList')
          .add(post.toJson());

      await commenttRef.update({
        'id': commenttRef.id,
      });

      var postRef = firestore.collection('posts').doc(postId);
      var postSnap = await postRef.get();

      if (postSnap.exists) {
        List oldCommentsList = (postSnap.data()?['comments'] as List);
        List<String> updatedCommentsList = [];
        for (var e in oldCommentsList) {
          updatedCommentsList.add(e);
        }

        updatedCommentsList.add(commenttRef.id);

        postRef.update(
          {'comments': updatedCommentsList},
        );
      }
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    // TODO: implement deletePost
    throw UnimplementedError();
  }

  @override
  Stream<List<Post>> fetchAllPosts({String? uid}) {
    try {
      if (uid == null) {
        return firestore
            .collection('posts')
            .orderBy('createdAt', descending: true)
            .snapshots()
            .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Post.fromJson(doc.data());
          }).toList();
        });
      }
      return firestore
          .collection('posts')
          .where('createdBy', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return Post.fromJson(doc.data());
        }).toList();
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> likePost(String postId) async {
    try {
      String uid = auth.currentUser!.uid;
      var postRef = firestore.collection('posts').doc(postId);

      postRef.get().then(
        (value) {
          if (value.exists) {
            List oldLikes = (value.data()?['likes'] as List);
            List<String> updatedLikes = [];
            for (var e in oldLikes) {
              updatedLikes.add(e);
            }

            // liking a post
            if (!updatedLikes.contains(uid)) {
              updatedLikes.add(uid);
            } else {
              updatedLikes.remove(uid);
            }

            postRef.update(
              {'likes': updatedLikes},
            );
          }
        },
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Stream<List<CommentModel>> fetchComments(String postId) {
    try {
      return firestore
          .collection('comments')
          .doc(postId)
          .collection('commentsList')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return CommentModel.fromJson(doc.data());
        }).toList();
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  // private methods
  Future<String> _uploadImageAndGenerateUrl(File image, String postId) async {
    final fileBytes = await image.readAsBytes();
    final fileName = 'postImages/${auth.currentUser!.uid}/$postId';

    final response = await Supabase.instance.client.storage
        .from('posts')
        .uploadBinary(fileName, fileBytes);

    log('Image uploaded and method returned: $response');
    String url =
        Supabase.instance.client.storage.from('posts').getPublicUrl(fileName);
    log('Public URL: ${Supabase.instance.client.storage.from('posts').getPublicUrl(fileName)}');
    return url;
  }
}
