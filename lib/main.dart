import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:chat_gpt_demo/features/navbar/presentation/controllers/user_controller.dart';
import 'package:chat_gpt_demo/features/navbar/presentation/pages/navbar.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart' as getx;

import 'amplifyconfiguration.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await dotenv.load(fileName: ".env");

  OpenAI.apiKey = dotenv.env['OPEN_AI_KEY']!;

  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _configureAmplify();

    getx.Get.put(UserController());
  }

  void _configureAmplify() async {
    try {
      await Amplify.addPlugin(AmplifyAuthCognito());
      await Amplify.configure(amplifyconfig);
      debugPrint('Successfully configured');
    } on Exception catch (e) {
      debugPrint('Error configuring Amplify: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Authenticator(
      child: getx.GetMaterialApp(
        title: "Chat GPT Demo",
        builder: Authenticator.builder(),
        debugShowCheckedModeBanner: false,
        defaultTransition: getx.GetPlatform.isIOS
            ? getx.Transition.cupertino
            : getx.Transition.rightToLeft,
        home: const Navbar(),
      ),
    );
  }
}
