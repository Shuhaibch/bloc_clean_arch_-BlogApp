import 'dart:io';

import 'package:bloc_clean_architecture_blog_app/core/error/exception.dart';
import 'package:bloc_clean_architecture_blog_app/core/error/failure.dart';
import 'package:bloc_clean_architecture_blog_app/features/blog/data/datasources/blog_remote_data_soure.dart';
import 'package:bloc_clean_architecture_blog_app/features/blog/data/models/blogs_models.dart';
import 'package:bloc_clean_architecture_blog_app/features/blog/domain/entities/blog_entity.dart';
import 'package:bloc_clean_architecture_blog_app/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;

  BlogRepositoryImpl(this.blogRemoteDataSource);
  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    try {
      BlogModel blogModel = BlogModel(
          id: const Uuid().v1(),
          posterId: posterId,
          title: title,
          content: content,
          imageUrl: '',
          topics: topics,
          updatedAt: DateTime.now());
      final imageUrl = await blogRemoteDataSource.uploadBlogImage(
        image: image,
        blog: blogModel,
      );
      blogModel = blogModel.copyWith(imageUrl: imageUrl);
      final uploadedBlog = await blogRemoteDataSource.uploadBlog(blogModel);
      return right(uploadedBlog);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
