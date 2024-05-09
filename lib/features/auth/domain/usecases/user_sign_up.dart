import 'package:bloc_clean_architecture_blog_app/core/error/failure.dart';
import 'package:bloc_clean_architecture_blog_app/core/usecase/usecase.dart';
import 'package:bloc_clean_architecture_blog_app/core/commen/entities/user.dart';
import 'package:bloc_clean_architecture_blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserSignUp implements UseCase<User, UserSignUpParams> {
  final AuthRepository authRepository;
  UserSignUp(
    this.authRepository,
  );

  @override
  Future<Either<Failure, User>> call(UserSignUpParams param) async {
    return await authRepository.signUpWithEmailPassword(
      name: param.name,
      email: param.email,
      password: param.password,
    );
  }
}

class UserSignUpParams {
  final String name;
  final String email;
  final String password;
  UserSignUpParams({
    required this.name,
    required this.email,
    required this.password,
  });
}
