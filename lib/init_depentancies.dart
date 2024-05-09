import 'package:bloc_clean_architecture_blog_app/core/commen/cubits/app_user/app_user_cubit.dart';
import 'package:bloc_clean_architecture_blog_app/core/secrets/app_secrets.dart';
import 'package:bloc_clean_architecture_blog_app/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:bloc_clean_architecture_blog_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:bloc_clean_architecture_blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:bloc_clean_architecture_blog_app/features/auth/domain/usecases/current_user.dart';
import 'package:bloc_clean_architecture_blog_app/features/auth/domain/usecases/user_sign_in.dart';
import 'package:bloc_clean_architecture_blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:bloc_clean_architecture_blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bloc_clean_architecture_blog_app/features/blog/data/datasources/blog_remote_data_soure.dart';
import 'package:bloc_clean_architecture_blog_app/features/blog/data/repositories/blog_repository_impl.dart';
import 'package:bloc_clean_architecture_blog_app/features/blog/domain/repository/blog_repository.dart';
import 'package:bloc_clean_architecture_blog_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:bloc_clean_architecture_blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;
Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  final supaBase = await Supabase.initialize(
      url: AppSecrets.supabaseUrl, anonKey: AppSecrets.supabaseAnonKey);
  serviceLocator.registerLazySingleton(() => supaBase.client);

  // Core
  serviceLocator.registerLazySingleton(() => AppUserCubit());
}

void _initAuth() {
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSouceImp(
        serviceLocator(),
      ),
    )
    // Repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        serviceLocator(),
      ),
    )
    // Usecases
    ..registerFactory(
      () => UserSignUp(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserLogin(
        authRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => CurrentUser(
        serviceLocator(),
      ),
    )
    //* Bloc
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}

// init Blog
void _initBlog() {
  // data source
  serviceLocator
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(
        supabaseClient: serviceLocator(),
      ),
    )
    // repository
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(
        serviceLocator(),
      ),
    )
    // Use case
    ..registerFactory(
      () => UploadBlog(
        serviceLocator(),
      ),
    )
    // Bloc
    ..registerFactory(() => BlogBloc(serviceLocator()));
}
