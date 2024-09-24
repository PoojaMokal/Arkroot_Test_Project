import 'package:chat_gpt_demo/core/constants/color/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OutputDialog extends StatelessWidget {
  final String output;
  const OutputDialog({super.key, required this.output});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: white,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(output),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text("Back"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
