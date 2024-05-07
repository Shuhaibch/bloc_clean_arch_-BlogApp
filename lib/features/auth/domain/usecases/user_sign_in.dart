// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc_clean_architecture_blog_app/core/error/failure.dart';
import 'package:bloc_clean_architecture_blog_app/core/usecase/usecase.dart';
import 'package:bloc_clean_architecture_blog_app/features/auth/domain/entities/user.dart';
import 'package:bloc_clean_architecture_blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserLogin implements UseCase<User, UserLoginParams> {
  final AuthRepository authRepository;

  UserLogin({required this.authRepository});
  @override
  Future<Either<Failure, User>> call(UserLoginParams param) {
    return authRepository.loginWithEmailPassword(
        email: param.email, password: param.password);
  }
}

class UserLoginParams {
  final String email;
  final String password;
  UserLoginParams({
    required this.email,
    required this.password,
  });
}
