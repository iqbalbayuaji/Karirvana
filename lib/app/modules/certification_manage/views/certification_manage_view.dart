import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/certification_manage_controller.dart';

class CertificationManageView extends GetView<CertificationManageController> {
  const CertificationManageView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CertificationManageView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'CertificationManageView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
