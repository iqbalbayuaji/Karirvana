import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/jadwal_manage_controller.dart';

class JadwalManageView extends GetView<JadwalManageController> {
  const JadwalManageView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JadwalManageView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'JadwalManageView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
