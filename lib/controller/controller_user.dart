import 'package:catatan_keuangan/route/route_nama.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ControllerUser extends GetxController {
  TextEditingController namacontrol = TextEditingController();
  TextEditingController emailcontrol = TextEditingController();
  TextEditingController passwordcontrol = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  var userEmail = ''.obs;
  var userNama = ''.obs;
  var isloading = false.obs;

  void clear() {
    namacontrol.clear();
    emailcontrol.clear();
    passwordcontrol.clear();
  }

  void singup() {
    register(namacontrol.text, emailcontrol.text, passwordcontrol.text);
    clear();
  }

  Future<void> register(String nama, String email, String passwword) async {
    isloading.value = true;
    try {
      final crendtial = await auth.createUserWithEmailAndPassword(
          email: email, password: passwword);

      String userId = crendtial.user!.uid;

      await firestore.collection('users').doc(userId).set(
          {'id': userId, 'nama': nama, 'email': email, 'password': passwword});

      Get.defaultDialog(title: 'Succes', middleText: 'Register Berhasil');
    } on FirebaseException catch (e) {
      if (e.code == 'weak-password') {
        Get.defaultDialog(title: 'Failed', middleText: 'Password lemah');
        print('passwrd lemah');
      } else if (e.code == 'email-already-in-use') {
        Get.defaultDialog(
            title: 'Failed', middleText: 'Akun sudah terdaftarkan');

        print('account ini sudah digunakan coba lagi');
      }
    } catch (e) {
      print('Password Gagagl $e');
    } finally {
      isloading.value = false;
    }
  }

  signin() {
    login(emailcontrol.text, passwordcontrol.text);
    clear();
  }

  Future<void> login(String email, String password) async {
    isloading.value = true;
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);

      Get.defaultDialog(title: 'Succes', middleText: 'Login Berhasil');
      Get.offAllNamed(RouteNama.dashboard);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.defaultDialog(
            title: 'Akun', middleText: 'Password atau email Salah');
        print('Tidak ada akun email');
      } else if (e.code == 'wrong-password') {
        Get.defaultDialog(
            title: 'Failed', middleText: 'Password atau email Salah');
        print('Passowrd salah pada akun');
      }
    } catch (e) {
      print(e);
    } finally {
      isloading.value = false;
    }
  }

  Future<dynamic> loginwithgoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      Get.snackbar('Berhasil', 'Log In ke akun');
      Get.offAllNamed(RouteNama.dashboard);

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print(Exception(e));
    }
  }

  Future<bool> signOutFromGoogle() async {
    try {
      isloading.value = true;
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      Get.snackbar('Berhasil', 'Log Out dari akun');
      Get.offNamed(RouteNama.login);
      return true;
    } on Exception catch (_) {
      return false;
    } finally {
      isloading.value = false;
    }
  }

  void loaddata() {
    loadDataUser();
  }

  Future<void> loadDataUser() async {
    User? user = auth.currentUser;
    if (user != null) {
      userEmail.value = user.email ?? 'email tidak di temukan';

      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        userNama.value = userDoc['nama'] ?? 'Nama tidak ditemuka';
      }
    }
  }

  Future<void> updateUserNama(String newNama) async {
    isloading.value = true;
    try {
      User? user = auth.currentUser;
      if (user != null) {
        await firestore.collection('users').doc(user.uid).update({
          'nama': newNama,
        });

        userNama.value = newNama;
        Get.defaultDialog(
            title: 'Sukses', middleText: 'Nama berhasil diperbarui');
        clear();
      }
    } catch (e) {
      Get.defaultDialog(title: 'Gagal', middleText: 'Gagal memperbarui nama');
      print('Error update nama: $e');
    } finally {
      isloading.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
    emailcontrol.dispose();
    passwordcontrol.dispose();
  }
}
