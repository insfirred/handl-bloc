import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/app_utils.dart';
import '../../../auth/presentation/auth_cubit.dart';
import '../../../post/domain/comment_model.dart';

class CommentItem extends StatefulWidget {
  const CommentItem(
    this.comment, {
    super.key,
  });

  final CommentModel comment;

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  String name = '';

  loadUsername() async {
    name = await context
            .read<AuthCubit>()
            .fetchUsernameById(widget.comment.createdBy) ??
        'Handl User';
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadUsername();
  }

  @override
  Widget build(BuildContext context) {
    loadUsername();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const CircleAvatar(
              maxRadius: 15,
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              AppUtils.dateToString(widget.comment.createdAt),
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 38),
          child: Text(
            widget.comment.text,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
