import 'package:catatan_keuangan/controller/controller_profile.dart';
import 'package:catatan_keuangan/firebase_options.dart';
import 'package:catatan_keuangan/route/route_screen.dart';
import 'package:catatan_keuangan/screen/dashboard_screen.dart';
import 'package:catatan_keuangan/screen/grafik_screen.dart';
import 'package:catatan_keuangan/screen/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print(e);
  }
  runApp(Apps());
}

class Apps extends StatelessWidget {
  final controller = Get.put(ControllerProfile());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GetMaterialApp(
        themeMode: controller.themeMode.value,
        darkTheme: ThemeData.dark(),
        theme: ThemeData.light(),
        debugShowCheckedModeBanner: false,
        home: DashboardScreen(),
        getPages: RouteScreen.Page,
      );
    });
  }
}
