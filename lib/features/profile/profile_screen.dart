import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:aws_dynamodb_api/dynamodb-2012-08-10.dart';
import 'package:chat_gpt_demo/core/constants/color/color_constants.dart';
import 'package:chat_gpt_demo/core/constants/strings/strings_constants.dart';
import 'package:chat_gpt_demo/core/services/dynamo_db_service.dart';
import 'package:chat_gpt_demo/features/navbar/presentation/mixins/navbar_mixin.dart';
import 'package:chat_gpt_demo/utils/gesturedetector_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with NavbarMixin {
  final formKey = GlobalKey<FormState>();

  String name = '';
  String number = '';
  String bio = '';

  @override
  void initState() {
    super.initState();

    setValue();
  }

  void setValue() {
    name = userController.name.value;
    number = userController.number.value;
    bio = userController.bio.value;
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
          title: const Text("Profile"),
          automaticallyImplyLeading: false,
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.logout),
          onPressed: () {
            signOutCurrentUser();
          },
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  initialValue: name,
                  onChanged: (value) {
                    name = value.trim();
                    setState(() {});
                  },
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return "Enter full name";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: "Full name",
                    fillColor: textGrayColor,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  initialValue: number,
                  onChanged: (value) {
                    number = value.trim();
                    setState(() {});
                  },
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return "Enter phone number";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: "Phone number",
                    fillColor: textGrayColor,
                  ),
                ),
                const SizedBox(height: 20),
                getx.Obx(
                  () {
                    return TextFormField(
                      initialValue: userController.userEmail.value,
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        fillColor: textGrayColor,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  initialValue: bio,
                  onChanged: (value) {
                    bio = value.trim();
                    setState(() {});
                  },
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return "Enter bio";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: "Bio",
                    fillColor: textGrayColor,
                  ),
                ),
                const SizedBox(height: 60),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () async {
                        GestureDetectorUtil.onScreenTap();

                        if (!formKey.currentState!.validate()) {
                          return;
                        }

                        final attribute = {
                          Strings.fullName: AttributeValue(s: name),
                          Strings.phoneNumber: AttributeValue(s: number),
                          Strings.email:
                              AttributeValue(s: userController.userEmail.value),
                          Strings.bio: AttributeValue(s: bio),
                        };

                        final PutItemOutput output =
                            await DynamoService().insertNewItem(attribute);

                        fetchCurrentUserAttributes();
                      },
                      child: const Text("Save Data")),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signOutCurrentUser() async {
    final result = await Amplify.Auth.signOut();
    if (result is CognitoCompleteSignOut) {
      safePrint('Sign out completed successfully');
    } else if (result is CognitoFailedSignOut) {
      safePrint('Error signing user out: ${result.exception.message}');
    }
  }
}
