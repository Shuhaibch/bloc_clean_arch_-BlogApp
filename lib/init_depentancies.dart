import 'package:bloc_clean_architecture_blog_app/core/secrets/app_secrets.dart';
import 'package:bloc_clean_architecture_blog_app/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:bloc_clean_architecture_blog_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:bloc_clean_architecture_blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:bloc_clean_architecture_blog_app/features/auth/domain/usecases/user_sign_in.dart';
import 'package:bloc_clean_architecture_blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:bloc_clean_architecture_blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;
Future<void> initDependencies() async {
  _initAuth();
  final supaBase = await Supabase.initialize(
      url: AppSecrets.supabaseUrl, anonKey: AppSecrets.supabaseAnonKey);
  serviceLocator.registerLazySingleton(() => supaBase.client);
}

void _initAuth() {
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSouceImp(
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => UserSignUp(
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => UserLogin(
      authRepository: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => AuthBloc(
      userSignUp: serviceLocator(),
      userLogin: serviceLocator(),
    ),
  );
}
