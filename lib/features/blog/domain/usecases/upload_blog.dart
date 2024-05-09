import 'dart:io';

import 'package:bloc_clean_architecture_blog_app/core/error/failure.dart';
import 'package:bloc_clean_architecture_blog_app/core/usecase/usecase.dart';
import 'package:bloc_clean_architecture_blog_app/features/blog/domain/entities/blog_entity.dart';
import 'package:bloc_clean_architecture_blog_app/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';


class UploadBlog implements UseCase<Blog, UploadBlogParams> {
  final BlogRepository blogRepository;

  UploadBlog(this.blogRepository);
  @override
  Future<Either<Failure, Blog>> call(UploadBlogParams param) async {
    return await blogRepository.uploadBlog(
      image: param.image,
      title: param.title,
      content: param.content,
      posterId: param.posterId,
      topics: param.topics,
    );
  }
}

class UploadBlogParams {
  final String posterId;
  final String title;
  final String content;
  final File image;
  final List<String> topics;

  UploadBlogParams({
    required this.posterId,
    required this.title,
    required this.content,
    required this.image,
    required this.topics,
  });
}
