import 'package:bloc_clean_architecture_blog_app/core/commen/cubits/app_user/app_user_cubit.dart';
import 'package:bloc_clean_architecture_blog_app/core/usecase/usecase.dart';
import 'package:bloc_clean_architecture_blog_app/core/commen/entities/user.dart';
import 'package:bloc_clean_architecture_blog_app/features/auth/domain/usecases/current_user.dart';
import 'package:bloc_clean_architecture_blog_app/features/auth/domain/usecases/user_sign_in.dart';
import 'package:bloc_clean_architecture_blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;
  AuthBloc({
    required AppUserCubit appUserCubit,
    required CurrentUser currentUser,
    required UserSignUp userSignUp,
    required UserLogin userLogin,
  })  : _userSignUp = userSignUp,
        _appUserCubit = appUserCubit,
        _currentUser = currentUser,
        _userLogin = userLogin,
        super(AuthInitial()) {
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
  }
  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userSignUp(UserSignUpParams(
        name: event.name, email: event.email, password: event.password));
    res.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userLogin(
        UserLoginParams(email: event.email, password: event.password));
    res.fold(
      (l) => emit(AuthFailure(message: l.message)),
      (r) => _emitAuthSuccess(r, emit),
    );
  }

  void _isUserLoggedIn(
      AuthIsUserLoggedIn event, Emitter<AuthState> emit) async {
    // emit();
    final res = await _currentUser(NoParam());
    res.fold(
      (l) => emit(AuthFailure(message: l.message)),
      (r) => _emitAuthSuccess(r, emit),
    );
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user: user));
  }
}
