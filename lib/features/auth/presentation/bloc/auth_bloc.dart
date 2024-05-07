import 'package:bloc_clean_architecture_blog_app/features/auth/domain/entities/user.dart';
import 'package:bloc_clean_architecture_blog_app/features/auth/domain/usecases/user_sign_in.dart';
import 'package:bloc_clean_architecture_blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
  })  : _userSignUp = userSignUp,
        _userLogin = userLogin,
        super(AuthInitial()) {
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthSignUp>(_onAuthLogin);
  }
  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userSignUp(UserSignUpParams(
        name: event.name, email: event.email, password: event.password));
    res.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (user) => emit(
        AuthSuccess(user: user),
      ),
    );
  }

  void _onAuthLogin(AuthSignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userLogin(
        UserLoginParams(email: event.email, password: event.password));
    res.fold(
      (l) => emit(AuthFailure(message: l.message)),
      (r) => emit(
        AuthSuccess(user: r),
      ),
    );
  }
}
