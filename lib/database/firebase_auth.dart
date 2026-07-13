import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:todo_app/utils/string_utils.dart';

class AuthService{
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;

  // Lắng nghe trạng thái đăng nhập
  Stream<fb.User?> get authStateChanges => _auth.authStateChanges();

  // Lấy thông tin user hiện tại (nếu có)
  fb.User? get currentUser => _auth.currentUser;

  Future<fb.User?> registerWithEmailAndPassword(String email, String password) async{
    try{
      fb.UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on fb.FirebaseAuthException catch (e) {
      if (e.code == StringUtils.weakPassword) {
        throw StringUtils.weakPasswordNotice;
      } else if (e.code == StringUtils.usedEmail) {
        throw StringUtils.usedEmailNotice;
      } else {
        throw StringUtils.errorRegister+'${e.message}';
      }
    } catch (e) {
      throw StringUtils.errorSystem;
    }
  }

  Future<fb.User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      fb.UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on fb.FirebaseAuthException catch (e) {
      if (e.code == StringUtils.userNotFound || e.code == StringUtils.wrongPassword || e.code == StringUtils.invalidCredential) {
        throw StringUtils.wrongEmailOrPassword;
      } else {
        throw StringUtils.errorSignIn+'${e.message}';
      }
    } catch (e) {
      throw StringUtils.errorSystem;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}