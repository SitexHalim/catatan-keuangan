import 'dart:io';

import 'package:catatan_keuangan/controller/controller_profile.dart';
import 'package:catatan_keuangan/controller/controller_transaksi.dart';
import 'package:catatan_keuangan/controller/controller_user.dart';
import 'package:catatan_keuangan/route/route_nama.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final controller = Get.put(ControllerTransaksi());
  final controll = Get.put(ControllerUser());
  final controllProfile = Get.put(ControllerProfile());
  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Get.offAllNamed(RouteNama.dashboard);
        break;
      case 1:
        Get.offAllNamed(RouteNama.transaksilist);
        break;
      case 2:
        Get.offAllNamed(RouteNama.grafik);
        break;
      case 3:
        Get.offAllNamed(RouteNama.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text('My Profile'))),
      body: Obx(() {
        controll.loadDataUser();
        return ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: controllProfile.profilePhoto.value.isEmpty
                        ? const AssetImage('assets/default_profile.png')
                        : FileImage(File(controllProfile.profilePhoto.value))
                            as ImageProvider,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controll.userNama.value,
                        style: const TextStyle(
                            fontSize: 23.0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        controll.userEmail.value,
                        style: const TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Get.toNamed(RouteNama.profiles);
              },
              child: const Card(
                margin: EdgeInsets.all(10.0),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.toNamed(RouteNama.setting);
              },
              child: const Card(
                margin: EdgeInsets.all(10.0),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  controll.signOutFromGoogle();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, foregroundColor: Colors.white),
                child: const Text('Log Out'),
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money_off),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Grafik',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
