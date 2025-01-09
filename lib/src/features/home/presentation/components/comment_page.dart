import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../post/presentation/post_cubit.dart';
import 'comment_item.dart';

@RoutePage()
class CommentPage extends StatefulWidget {
  const CommentPage(
    this.postId, {
    super.key,
  });

  final String postId;

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text Field
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Add comment...',
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      String commentText = controller.text;
                      controller.clear();
                      context.read<PostCubit>().commentOnPost(
                            widget.postId,
                            commentText,
                          );
                    },
                    child: Icon(
                      Icons.send,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Comments List
              StreamBuilder(
                stream: context.read<PostCubit>().fetchComments(widget.postId),
                builder: (context, snapshot) {
                  // Handle errors
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Something went wrong!'),
                    );
                  }

                  // Show loading indicator
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Extract the comments data
                  final comenntsList = snapshot.data;

                  if (comenntsList == null || comenntsList.isEmpty) {
                    return const Center(
                      child: Text('No Comments on this Post'),
                    );
                  }

                  // When everything is all right!
                  return Column(
                    children: [
                      Row(
                        children: [
                          // Comments Heading
                          const Text(
                            'Comments',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            '${comenntsList.length}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // All Comments List
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: comenntsList.length,
                        itemBuilder: (context, index) => CommentItem(
                          comenntsList[index],
                        ),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 15),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
