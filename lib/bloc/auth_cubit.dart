import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInit());

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      emit(AuthSignIn());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(const AuthError(message: "No user found for that email."));
      } else if (e.code == 'wrong-password') {
        emit(const AuthError(message: "Wrong password provided for that user."));
      }
    } catch (error) {
      emit(AuthError(message: error.toString()));
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> signUp({
    required String email,
    required String username,
    required String password,
  }) async {
    emit(AuthLoading());
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      final UserCredential credential =
          await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user?.uid)
          .set({
        "userId": credential.user?.uid,
        "userName": username,
        "email": email,
      });

      credential.user!.updateDisplayName(username);

      emit(AuthSignUp());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(const AuthError(message: 'The password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        emit(const AuthError(message: 'The account already exists for that email.'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}
