import 'package:auto_route/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../auth/presentation/auth_cubit.dart';
import 'components/follow_btn.dart';
import 'components/message_btn.dart';
import 'components/post_grid_section.dart';

@RoutePage()
class ProfilePage extends StatefulWidget {
  const ProfilePage(this.uid, {super.key});

  final String uid;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    loadUsername();
  }

  loadUsername() async {
    name = await context.read<AuthCubit>().fetchUsernameById(widget.uid) ?? '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: context.read<AuthCubit>().logout,
                icon: const FaIcon(FontAwesomeIcons.signOut),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const CircleAvatar(
            minRadius: 50,
            backgroundColor: Colors.grey,
            child: Icon(
              Icons.person,
              size: 60,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Center(
            child: Text(
              FirebaseAuth.instance.currentUser!.email!,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatsItem(
                label: 'Posts',
                value: '110',
              ),
              _buildStatsItem(
                label: 'Followers',
                value: '800',
              ),
              _buildStatsItem(
                label: 'Following',
                value: '550',
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FollowBtn(),
              SizedBox(width: 12),
              MessageBtn(),
            ],
          ),
          const SizedBox(height: 30),
          const Padding(
            padding: EdgeInsets.only(left: 8),
            child: Text(
              'All Posts',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          PostsGridSection(widget.uid),
        ],
      ),
    );
  }

  Widget _buildStatsItem({
    required String label,
    required String value,
  }) {
    return SizedBox(
      width: 90,
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(label),
        ],
      ),
    );
  }
}
