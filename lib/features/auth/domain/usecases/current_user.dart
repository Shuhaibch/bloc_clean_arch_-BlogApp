import 'package:bloc_clean_architecture_blog_app/core/error/failure.dart';
import 'package:bloc_clean_architecture_blog_app/core/usecase/usecase.dart';
import 'package:bloc_clean_architecture_blog_app/core/commen/entities/user.dart';
import 'package:bloc_clean_architecture_blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class CurrentUser implements UseCase<User, NoParam> {
  final AuthRepository authRepository;

  CurrentUser(this.authRepository);
  @override
  Future<Either<Failure, User>> call(NoParam param) async {
    return await authRepository.currentUser();
  }
}
