import 'package:chat_gpt_demo/core/constants/color/color_constants.dart';
import 'package:chat_gpt_demo/features/chat_gpt/presentation/dialogs/organisation_created_dialog.dart';
import 'package:chat_gpt_demo/features/chat_gpt/presentation/dialogs/progress_dialog.dart';
import 'package:chat_gpt_demo/utils/gesturedetector_util.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatGptScreen extends StatefulWidget {
  const ChatGptScreen({super.key});

  @override
  State<ChatGptScreen> createState() => _ChatGptScreenState();
}

class _ChatGptScreenState extends State<ChatGptScreen> {
  final formKey = GlobalKey<FormState>();

  TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GestureDetectorUtil.onScreenTap();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: const SizedBox(),
          centerTitle: true,
          title: const Text("Chat GPT"),
          automaticallyImplyLeading: false,
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  controller: controller,
                  maxLines: 6,
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return "Enter some input";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: "Enter your input",
                    fillColor: textGrayColor,
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: generateText,
                    child: const Text("Generate summary"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> generateText() async {
    GestureDetectorUtil.onScreenTap();

    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      ProgressDialog.showProgressDialog(context);

      final systemMessage = OpenAIChatCompletionChoiceMessageModel(
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(
            "${controller.text}   Give a good self-introduction summary so that it can be added in resume",
          ),
        ],
        role: OpenAIChatMessageRole.assistant,
      );
      final requestMessages = [
        systemMessage,
      ];

      OpenAIChatCompletionModel chatCompletion =
          await OpenAI.instance.chat.create(
        model: "gpt-4o",
        messages: requestMessages,
      );

      debugPrint(chatCompletion.choices.first.message.content?.first.text);

      Get.back();

      _openDialog(
          chatCompletion.choices.first.message.content?.first.text ?? "");
    } catch (e) {
      Get.back();
    }
  }

  Future<void> _openDialog(String output) async {
    await showCupertinoDialog(
        context: Get.context!,
        builder: (context) {
          return OutputDialog(output: output);
        });

    controller.text = '';
    setState(() {});
  }
}
