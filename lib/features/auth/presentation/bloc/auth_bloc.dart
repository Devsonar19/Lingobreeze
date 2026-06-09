import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:equatable/equatable.dart';

// --- States (Keep these exactly the same) ---
abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class Authenticated extends AuthState {
  final User user;
  Authenticated(this.user);
  @override
  List<Object?> get props => [user];
}
class Unauthenticated extends AuthState {}
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
  @override
  List<Object?> get props => [message];
}

// --- Events ---
abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}
class CheckAuthStatus extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  LoginRequested(this.email, this.password);
}

// NEW: Explicit Register Event
class RegisterRequested extends AuthEvent {
  final String email;
  final String password;
  RegisterRequested(this.email, this.password);
}

class LogoutRequested extends AuthEvent {}

// --- BLoC Implementation ---
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthBloc() : super(AuthInitial()) {
    on<CheckAuthStatus>((event, emit) async {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    });

    // Login with Error handling
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        emit(Authenticated(userCredential.user!));
      } on FirebaseAuthException catch (e) {
        // This prints the exact error to your terminal for easy debugging
        print("🔥 LOGIN FIREBASE ERROR: ${e.code} - ${e.message}");

        String errorMsg = 'Login failed. Please check your credentials.';

        // Covering all bases for old and new Firebase SDK versions
        if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-credential') {
          errorMsg = 'Invalid email or password. Are you sure you are registered?';
        } else if (e.code == 'network-request-failed') {
          errorMsg = 'No internet connection. Please check your network and try again.';
        } else if (e.code == 'invalid-email') {
          errorMsg = 'The email address is badly formatted.';
        }

        emit(AuthError(errorMsg));
      } catch (e) {
        // This catches completely unknown errors (like missing Google Services)
        print("🔥 LOGIN UNKNOWN ERROR: $e");
        emit(AuthError("An unexpected error occurred. Please try again."));
      }
    });

    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        emit(Authenticated(userCredential.user!));
      } on FirebaseAuthException catch (e) {
        String errorMsg = e.message ?? 'Registration failed.';

        // NEW: Catch specific errors
        if (e.code == 'weak-password') {
          errorMsg = 'The password provided is too weak. Please use at least 6 characters.';
        } else if (e.code == 'email-already-in-use') {
          errorMsg = 'An account already exists for that email. Please log in instead.';
        } else if (e.code == 'network-request-failed') {
          errorMsg = 'No internet connection. Please check your network and try again.';
        }

        emit(AuthError(errorMsg));
      }
    });

    on<LogoutRequested>((event, emit) async {
      await _firebaseAuth.signOut();
      emit(Unauthenticated());
    });
  }
}