import 'dart:io';
import 'package:catatan_keuangan/controller/controller_profile.dart';
import 'package:catatan_keuangan/controller/controller_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilesScreen extends StatefulWidget {
  const ProfilesScreen({super.key});

  @override
  State<ProfilesScreen> createState() => _ProfilesScreenState();
}

class _ProfilesScreenState extends State<ProfilesScreen> {
  final controll = Get.put(ControllerProfile());
  final controllUser = Get.put(ControllerUser());

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
                        : FileImage(File(controll.profilePhoto.value))
                            as ImageProvider,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      controll.pickProfilePhoto();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreen,
                        foregroundColor: Colors.white),
                    child: const Text('Ubah Foto Profil'),
                  ),
                ],
              );
            }),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: controllUser.namacontrol,
              decoration: InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0)),
                  fillColor: Colors.white,
                  filled: true),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  controllUser.updateUserNama(controllUser.namacontrol.text);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen,
                    foregroundColor: Colors.white),
                child: const Text('Perbarui Profile'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
