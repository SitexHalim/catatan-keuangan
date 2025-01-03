import 'package:catatan_keuangan/controller/controller_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilesScreen extends StatefulWidget {
  const ProfilesScreen({super.key});

  @override
  State<ProfilesScreen> createState() => _ProfilesScreenState();
}

class _ProfilesScreenState extends State<ProfilesScreen> {
  final controll = Get.put(ControllerProfile());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: controll.profilePhoto.value.isEmpty
                        ? const AssetImage('assets/default_profile.png')
                        : NetworkImage(controll.profilePhoto.value),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      controll.saveProfilePhoto(
                          'https://lp-cms-production.imgix.net/2022-04/Indonesia%20Gunung%20Kerinci%20Muhammad%20Rinandar%20Taysa%20:%20EyeEm%20GettyImages-1191868930%20RFE.jpg?auto=format&q=40&w=870&dpr=4');
                    },
                    child: const Text('Ubah Foto Profil'),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
