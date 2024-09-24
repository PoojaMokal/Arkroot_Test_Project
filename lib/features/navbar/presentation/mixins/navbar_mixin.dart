import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:aws_dynamodb_api/dynamodb-2012-08-10.dart';
import 'package:chat_gpt_demo/core/constants/strings/strings_constants.dart';
import 'package:chat_gpt_demo/core/services/dynamo_db_service.dart';
import 'package:chat_gpt_demo/features/navbar/presentation/controllers/user_controller.dart';
import 'package:get/get.dart' as getx;

mixin NavbarMixin {
  UserController userController = getx.Get.find<UserController>();

  Future<void> fetchCurrentUserAttributes() async {
    try {
      final List<AuthUserAttribute> result =
          await Amplify.Auth.fetchUserAttributes();

      final AuthUserAttribute email = result.firstWhere((e) {
        return e.userAttributeKey.key == Strings.email2;
      });

      userController.userEmail.value = email.value;

      final List<Map<String, AttributeValue>>? allUsers =
          await DynamoService().getAll();

      if (allUsers != null) {
        bool value = allUsers.any(
          (element) => element["Email"]?.s == email.value,
        );

        if (value == true) {
          Map<String, AttributeValue> data = allUsers.firstWhere(
            (element) => element["Email"]?.s == email.value,
          );

          userController.name.value = data["full_name"]?.s ?? "";
          userController.number.value = data["phone_number"]?.s ?? "";
          userController.bio.value = data["bio"]?.s ?? "";
        }
      }
    } on AuthException catch (e) {
      safePrint('Error fetching user attributes: ${e.message}');
    }
  }
}
