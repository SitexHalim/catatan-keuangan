import 'package:catatan_keuangan/route/route_nama.dart';
import 'package:catatan_keuangan/screen/dashboard_screen.dart';
import 'package:catatan_keuangan/screen/grafik_screen.dart';
import 'package:catatan_keuangan/screen/login_screen.dart';
import 'package:catatan_keuangan/screen/outcome_screen.dart';
import 'package:catatan_keuangan/screen/profile_screen.dart';
import 'package:catatan_keuangan/screen/profiles_screen.dart';
import 'package:catatan_keuangan/screen/register_screen.dart';
import 'package:catatan_keuangan/screen/income_screen.dart';
import 'package:catatan_keuangan/screen/setting_screen.dart';
import 'package:catatan_keuangan/screen/transaksilist_screen.dart';
import 'package:get/get.dart';

class RouteScreen {
  static final Page = [
    GetPage(name: RouteNama.register, page: () => const RegisterScreen()),
    GetPage(name: RouteNama.login, page: () => const LoginScreen()),
    GetPage(name: RouteNama.dashboard, page: () => const DashboardScreen()),
    GetPage(name: RouteNama.income, page: () => const IncomeScreen()),
    GetPage(name: RouteNama.outcome, page: () => const OutcomeScreen()),
    GetPage(
        name: RouteNama.transaksilist, page: () => const TransaksilistScreen()),
    GetPage(name: RouteNama.setting, page: () => const Settingscreen()),
    GetPage(name: RouteNama.profile, page: () => const ProfileScreen()),
    GetPage(name: RouteNama.profiles, page: () => const ProfilesScreen()),
    GetPage(name: RouteNama.grafik, page: () => const GrafikScreen()),
    // GetPage(
    // name: RouteNama.grafikperbadingan,
    // page: () => const GrafikperbandinganScreen())
  ];
}
