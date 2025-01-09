import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../post/presentation/post_cubit.dart';

class PostsGridSection extends StatefulWidget {
  const PostsGridSection(
    this.uid, {
    super.key,
  });

  final String uid;

  @override
  State<PostsGridSection> createState() => _PostsGridSectionState();
}

class _PostsGridSectionState extends State<PostsGridSection> {
  @override
  void initState() {
    super.initState();
    context.read<PostCubit>().fetchPosts(uid: widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: context.read<PostCubit>().fetchPosts(uid: widget.uid),
      builder: (context, snapshot) {
        // Handle errors
        if (snapshot.hasError) {
          log(snapshot.error.toString());
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }

        // Show loading indicator
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Extract the post data
        final postsList = snapshot.data;

        if (postsList == null || postsList.isEmpty) {
          return const Center(
            child: Text('No Posts'),
          );
        }

        var onlyImagesPostsList =
            postsList.where((post) => post.imageUrl != null).toList();

        // When everything is all right!
        return GridView.builder(
            padding: const EdgeInsets.all(8),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: onlyImagesPostsList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  onlyImagesPostsList[index].imageUrl ?? '',
                  fit: BoxFit.cover,
                ),
              );
            });
      },
    );
  }
}
