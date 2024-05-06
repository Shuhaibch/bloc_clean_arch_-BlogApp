import 'package:bloc_clean_architecture_blog_app/core/error/exception.dart';
import 'package:bloc_clean_architecture_blog_app/core/error/failure.dart';
import 'package:bloc_clean_architecture_blog_app/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:bloc_clean_architecture_blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);
  @override
  Future<Either<Failure, String>> loginWithEmailPassword(
      {required String email, required String password}) {
    // TODO: implement loginWithEmailPassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userId = await remoteDataSource.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      );
     return right(userId);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
