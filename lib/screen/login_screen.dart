import 'package:catatan_keuangan/controller/controller_user.dart';
import 'package:catatan_keuangan/route/route_nama.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final control = Get.put(
    ControllerUser(),
  );
  final _keyform = GlobalKey<FormState>();
  bool isObscure = true;
  togglePassword() {
    setState(() {
      isObscure = !isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber[300],
        body: Obx(() {
          if (control.isloading.value) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(
                    top: 150, right: 30, bottom: 50, left: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Account Login',
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    Form(
                      key: _keyform,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(top: 50),
                            child: SizedBox(
                              child: TextFormField(
                                controller: control.emailcontrol,
                                validator: (value) {
                                  String pattern =
                                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9,-]+\.[a-zA-Z]{2,}$';
                                  RegExp regex = RegExp(pattern);
                                  if (value == null || value.isEmpty) {
                                    return '*Masukan Email';
                                  }
                                  if (!value.contains('@')) {
                                    return 'Email harus mengandung simbol @.';
                                  }
                                  if (!value.contains('.')) {
                                    return 'Email harus mengandung simbol titik (.) setelah simbol @.';
                                  }
                                  if (!regex.hasMatch(value)) {
                                    return 'Format email tidak valid. Pastikan menggunakan format yang benar.';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Email',
                                    hintStyle: const TextStyle(
                                      fontSize: 13,
                                    ),
                                    contentPadding:
                                        const EdgeInsets.only(left: 25),
                                    prefixIcon: const Icon(
                                      Icons.email,
                                      size: 20,
                                    )),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 20),
                            child: SizedBox(
                              child: TextFormField(
                                controller: control.passwordcontrol,
                                validator: (value) {
                                  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                                  if (value == null || value.isEmpty) {
                                    return '*Masukan Password';
                                  }
                                  if (value.length < 8) {
                                    return 'Password harus terdiri dari minimal 8 karakter.';
                                  }
                                  if (!RegExp(r'(?=.*?[A-Z])')
                                      .hasMatch(value)) {
                                    return 'Password harus mengandung minimal 1 huruf kapital.';
                                  }
                                  if (!RegExp(r'(?=.*?[a-z])')
                                      .hasMatch(value)) {
                                    return 'Password harus mengandung minimal 1 huruf kecil.';
                                  }
                                  if (!RegExp(r'(?=.*?[0-9])')
                                      .hasMatch(value)) {
                                    return 'Password harus mengandung minimal 1 angka.';
                                  }
                                  if (!RegExp(r'(?=.*?[!@#\$&*~])')
                                      .hasMatch(value)) {
                                    return 'Password harus mengandung minimal 1 simbol.';
                                  }

                                  return null;
                                },
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Password',
                                    hintStyle: const TextStyle(
                                      fontSize: 13,
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.lock,
                                      size: 20,
                                    ),
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          togglePassword();
                                        },
                                        icon: Icon(isObscure
                                            ? Icons.visibility
                                            : Icons.visibility_off)),
                                    contentPadding:
                                        const EdgeInsets.only(left: 25)),
                                obscureText: isObscure,
                              ),
                            ),
                          ),
                          Container(
                              padding: const EdgeInsets.only(top: 20),
                              child: SizedBox(
                                width: double.infinity,
                                height: 45,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_keyform.currentState!.validate()) {
                                      control.signin();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.greenAccent,
                                      foregroundColor: Colors.white),
                                  child: const Text('Login'),
                                ),
                              )),
                          const SizedBox(
                            height: 15,
                          ),
                          const Center(
                              child: Text(
                            'Or Login WIth',
                            style: TextStyle(color: Colors.white),
                          )),
                          Container(
                              padding: const EdgeInsets.only(top: 20),
                              child: SizedBox(
                                width: double.infinity,
                                height: 45,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await control.loginwithgoogle();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                      foregroundColor: Colors.white),
                                  child: const Text('Google'),
                                ),
                              )),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Dont have account?',
                                style: TextStyle(color: Colors.white),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Get.offNamed(RouteNama.register);
                                  },
                                  child: const Text('Register'))
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        }));
  }
}
