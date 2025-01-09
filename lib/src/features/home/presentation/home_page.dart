import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../routing/app_router.dart';
import '../../post/domain/post.dart';
import '../../post/presentation/post_cubit.dart';
import 'components/post_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<PostCubit>().fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: context.read<PostCubit>().fetchPosts(),
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

        // Extract the post data
        final postsList = snapshot.data;

        if (postsList == null || postsList.isEmpty) {
          return const Center(
            child: Text('No Posts on this App'),
          );
        }

        // When everything is all right!
        return HomeView(postsList);
      },
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView(
    this.posts, {
    super.key,
  });

  final List<Post> posts;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  'H A N D L',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.paperPlane,
                  color: Colors.grey.shade700,
                ),
                onPressed: () {
                  context.navigateTo(const ChatUserRoute());
                },
              )
            ],
          ),
          const SizedBox(height: 20),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return PostItem(posts[index]);
            },
            separatorBuilder: (context, index) => const SizedBox(height: 14),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
