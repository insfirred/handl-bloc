import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../routing/app_router.dart';
import '../../../../utils/app_utils.dart';
import '../../../auth/presentation/auth_cubit.dart';
import '../../../post/domain/post.dart';
import '../../../post/presentation/post_cubit.dart';

class PostItem extends StatefulWidget {
  const PostItem(
    this.post, {
    super.key,
  });

  final Post post;

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  String name = '';
  bool isLikedByMe = false;

  @override
  void initState() {
    super.initState();
    loadUsername();
    checkIfLikedByMe();
  }

  loadUsername() async {
    name = await context
            .read<AuthCubit>()
            .fetchUsernameById(widget.post.createdBy) ??
        'Handl User';
    setState(() {});
  }

  checkIfLikedByMe() {
    final myId = FirebaseAuth.instance.currentUser!.uid;
    isLikedByMe = widget.post.likes.contains(myId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.grey,
                  maxRadius: 15,
                  child: Icon(
                    Icons.person,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                Text(name),
              ],
            ),
          ),

          // Image
          if (widget.post.imageUrl != null &&
              widget.post.imageUrl!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Image.network(widget.post.imageUrl!),
          ],
          const SizedBox(height: 10),

          // Text
          if (widget.post.text != null && widget.post.text!.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                widget.post.text!,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ],

          // Time of posting
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              AppUtils.dateToString(widget.post.createdAt),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),

          const SizedBox(height: 6),

          // Likes, Comments
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    context.read<PostCubit>().likePost(widget.post.id);
                    isLikedByMe = !isLikedByMe;
                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      children: [
                        // already liked by me
                        if (isLikedByMe) ...[
                          const FaIcon(
                            FontAwesomeIcons.solidHeart,
                            size: 20,
                            color: Colors.red,
                          ),
                        ]
                        // not liked by me
                        else ...[
                          const FaIcon(
                            FontAwesomeIcons.heart,
                            size: 20,
                          ),
                        ],
                        const SizedBox(width: 8),
                        Text(widget.post.likes.length.toString()),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    context.navigateTo(CommentRoute(postId: widget.post.id));
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const FaIcon(
                      FontAwesomeIcons.comment,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
