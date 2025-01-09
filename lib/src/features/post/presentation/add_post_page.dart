import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'add_post_state.dart';
import 'post_cubit.dart';

@RoutePage()
class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  XFile? selectedImage;
  final controller = TextEditingController();

  _pickImageSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    selectedImage = await picker.pickImage(source: source);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Heading
              Text(
                'What\'s on your mind?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 12),

              // Text Field
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Share with the world...',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Add Image Btn
              if (selectedImage == null) ...[
                IconButton(
                  onPressed: () => _pickImageSheet(context),
                  icon: Icon(
                    Icons.add_photo_alternate,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],

              // Image with remove btn
              if (selectedImage != null) ...[
                Image.file(
                  File(selectedImage!.path),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedImage = null;
                    });
                  },
                  child: Text(
                    'Choose another',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: BlocConsumer<PostCubit, AddPostState>(
          builder: (context, state) {
            return FloatingActionButton(
              onPressed: () {
                context.read<PostCubit>().addPost(
                      controller.text.isEmpty ? null : controller.text,
                      selectedImage,
                    );
              },
              child: const Text(
                'Post',
                style: TextStyle(color: Colors.white),
              ),
            );
          },
          listener: (context, state) {
            if (state is AddPostLoaded) {
              context.router.maybePop();
            }
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
