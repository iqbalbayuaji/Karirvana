import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/certification_store_controller.dart';

class CertificationStoreView extends GetView<CertificationStoreController> {
  const CertificationStoreView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CertificationStoreView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'CertificationStoreView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
