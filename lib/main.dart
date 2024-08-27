import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:web_test/generated/assets.gen.dart';
import 'package:web_test/model/question/answer/model.dart';
import 'package:web_test/model/question/model.dart';
import 'package:web_test/model/result/model.dart';
import 'package:web_test/model/result/user_answer/model.dart';
import 'package:web_test/service/auth.dart';
import 'package:web_test/service/local.dart';
import 'package:web_test/service/result.dart';
import 'package:web_test/ui/admin/page.dart';

import 'package:web_test/ui/login/page.dart';
import 'package:web_test/ui/test/page.dart';
import 'package:web_test/ui/main/dialog/choose_test.dart';

import 'firebase.dart';
import 'router/definition.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseConfig.init();
  usePathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1920, 1080),
      child: MaterialApp.router(
        title: 'VCO Online Test',
        theme: ThemeData(
          useMaterial3: false,
          colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: Colors.red,
            onPrimary: Colors.white,
            secondary: Color(0xFF013B55),
            onSecondary: Colors.white,
            error: Colors.red,
            onError: Colors.white,
            background: Colors.white,
            onBackground: Color(0xFFFFFFFF),
            surface: Color(0xFF2A576E),
            onSurface: Color(0xFF9AB0BB),
          ),
        ),
        debugShowCheckedModeBanner: false,
        routerConfig: RouterDefinition.router,
        builder: EasyLoading.init(),
      ),
    );
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // final service = AuthService();
    // service.createAccountForTesting(600, 700);
    checkLogin().then((value) {
      if (value==LoginType.user) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const StartPage(),
          ),
        );
      }else if(value==LoginType.admin){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AdminPage(),
          ),
        );
      }
       else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      }
    });
    super.initState();
  }

Future<LoginType> checkLogin() async {
  final username = await LocalStorageUtility.getData('username');
  final userType = await LocalStorageUtility.getData('userType');
  
  if (username != null && username.isNotEmpty) {
    if (userType == 'user') {
      return LoginType.user;
    } else if (userType == 'admin') {
      return LoginType.admin;
    }
  }
  return LoginType.none;
}

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(
            Assets.images.background.path,
          ),
        ),
      ),
    );
  }
}

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final service = ResultService();
  bool canTakeTest = false;

  @override
  void initState() {
    getResult();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Assets.images.background.image(
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                // Assets.images.logo.image(height: 150.h),
                // Assets.images.title.image(height: 450.h),
                const SizedBox(height: 300,),
                canTakeTest
                    ? TakeTestButton(
                        canTakeTest: canTakeTest,
                        onClick: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TestPage(
                                type: TestType.customType,
                              ),
                            ),
                          ).then((value) {
                            getResult();
                          });
                        },
                      )
                    : Text(
                        'You have already done this test. We will send you the result as soon as possible. Thank you.',
                        style: TextStyle(
                          fontSize: 36.sp,
                          color: Colors.black,
                        ),
                      ),
                SizedBox(height: 40.h),
                InkWell(
                  borderRadius: BorderRadius.circular(24.r),
                  onTap: () {
                    final authService = AuthService();
                    authService.logout().then((value) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.r),
                      color: Colors.black,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
                    child: Text(
                      'Sign out',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getResult() async {
    service.getResult().then((value) {
      canTakeTest = value == null;
      if (mounted) {
        setState(() {});
      }
    });
  }

  
}

class TakeTestButton extends StatefulWidget {
  final bool canTakeTest;
  final VoidCallback onClick;
  const TakeTestButton({super.key, required this.canTakeTest, required this.onClick});

  @override
  State<TakeTestButton> createState() => _TakeTestButtonState();

  
}

class _TakeTestButtonState extends State<TakeTestButton> {
  final service = ResultService();
  bool isHover = false;

  Future<void> submitPlaceholderResult() async {
    final placeholderAnswer = AnswerModel(
      answer: 'Placeholder Answer',
      point: 0,
    );
      final placeholderQuestion = QuestionModel(
    question: 'Placeholder Question',
    answers: [placeholderAnswer],
    scenario: 'Placeholder Scenario',
    url: 'https://example.com',
  );
    final placeholderUserAnswer = UserAnswerModel(
    point: 0,
    question: placeholderQuestion,
    answer: 0,
    time: 0.0,
  );
  List<UserAnswerModel> placeholderAnswers = [placeholderUserAnswer];
  final username = await LocalStorageUtility.getData('username');
  ResultModel blankResult = ResultModel(
    type: TestType.customType,
    time: 0.0,
    answers: placeholderAnswers,
    point: 0,
    username: username!,
  );


    service.submitResult(blankResult);
  }
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.canTakeTest,
      child: InkWell(
        onHover: (value) {
          setState(() {
            isHover = value;
          });
        },
        onTap:(){
          widget.onClick();
          submitPlaceholderResult();
        }, 
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: isHover ? const Border() : Border.all(color: Colors.black),
            color: isHover ? Colors.red : Colors.transparent,
          ),
          padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 16.h),
          child: Text(
            'TAKE TEST',
            style: TextStyle(
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
              color: isHover ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
