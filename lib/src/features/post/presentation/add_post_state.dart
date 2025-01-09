abstract class AddPostState {}

class AddPostInitial extends AddPostState {}

class AddPostLoading extends AddPostState {}

class AddPostError extends AddPostState {
  final String error;
  AddPostError(this.error);
}

class AddPostLoaded extends AddPostState {}
