import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:logger/web.dart';
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
        title: 'Online test Tầm Nhìn Thương Hiệu',
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
  bool timeTakeTest = false;

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
                if(!timeTakeTest)...[

                
                  Text(
                    'Thí sinh không thể truy cập vào đề do chưa đến giờ thi hoặc đã quá thời gian tham gia dự thi.',
                    style: TextStyle(
                      fontSize: 36.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: const Offset(20.0,20.0), // Adjust the offset to position the shadow
                          blurRadius:
                              10.0, // Adjust the blur for a softer or sharper shadow
                          color: Colors.black.withOpacity(
                              1), // Adjust the color and opacity for visibility
                        ),
                      ],
                    ),
                  ),
                ] else ...[
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
                        'BẠN ĐÃ HOÀN THÀNH BÀI THI TRẮC NGHIỆM VÒNG 1 CỦA CUỘC THI TẦM NHÌN THƯƠNG HIỆU!',
                        style: TextStyle(
                      fontSize: 36.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: const Offset(20.0,20.0), // Adjust the offset to position the shadow
                          blurRadius:
                              10.0, // Adjust the blur for a softer or sharper shadow
                          color: Colors.black.withOpacity(
                              1), // Adjust the color and opacity for visibility
                        ),
                      ],
                    ),
                      ),
                ],
                
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
                      'ĐĂNG XUẤT',
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
      DateTime now = DateTime.now().toUtc().add(const Duration(hours: 7));

      DateTime startTime = DateTime.utc(2024, 9, 4, 18);
      DateTime endTime = DateTime.utc(2024, 9, 5, 22);

      final logger = Logger();
      logger.i('Now: $now \nStart time:$startTime \nEnd time: $endTime');
      // canTakeTest = value == null && now.isAfter(startTime) && now.isBefore(endTime);
      // if (value == null && now.isAfter(startTime) && now.isBefore(endTime)) {
      //   canTakeTest = true;
      // } else if (value != null) {
      //   // If the test was already taken, display the first message
      //   canTakeTest = false;
      // } else {
      //   // If the time is not within the allowed test window, display the second message
      //   canTakeTest = false;
      // }
      if(value==null){
        canTakeTest = true;
      }
      else{
        canTakeTest = false;
      }
      if(now.isAfter(startTime) && now.isBefore(endTime)){
        timeTakeTest = true;
      }
      else{
        timeTakeTest = false;
      }
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
      answer: 'Empty Answer',
      point: 0,
    );
final placeholderQuestion = QuestionModel(
  question: 'Empty Question',
  answers: [placeholderAnswer],
  scenario: 'Empty Scenario',
  url: 'https://example.com',
  category: QuestionCategory.theory,
  level: QuestionLevel.easy, 
  shuffle: false,
);
    final placeholderUserAnswer = UserAnswerModel(
    point: 0,
    question: placeholderQuestion,
    answers: [-1],
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
    tabSwitch: 0,
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
          showTestRulesDialog(context, () {
            widget.onClick();
            submitPlaceholderResult();
          });
        }, 
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: isHover ? const Border() : Border.all(color: Colors.black),
            color: isHover ? Colors.red : Colors.transparent,
          ),
          padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 16.h),
          child: Text(
            'LÀM BÀI',
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

void showTestRulesDialog(BuildContext context, VoidCallback onStartTest) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
          title: const Text(
          'THỂ LỆ DỰ THI',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Container(
            width: 1000.h,
            alignment: Alignment.topLeft,
            child: RichText(
              textAlign: TextAlign.start,
              text: const TextSpan(
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  height: 1.5, // line height
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'VÒNG 1 - DISCOVER\n(ONLINE TEST)\n\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: 'Nền tảng: Website cuộc thi\n\n',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  TextSpan(
                    text: 'Thời gian và hình thức thi:\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: 'Bài thi vòng 1 (Online test) sẽ diễn ra trong thời gian từ 18h00 đến 22h00, Thứ Năm ngày 05/09/2024.\n'
                        'Đề thi bao gồm 45 câu hỏi, các đội thi làm bài trong vòng 50 phút.\n'
                        'Mỗi đội thi sẽ chỉ sử dụng đại diện 1 thiết bị và tham gia thi 1 lần duy nhất, bài thi sẽ tự động nộp khi hết thời gian làm bài.\n'
                        'Đối với các thí sinh thực hiện bài thi NGOÀI khoảng thời gian quy định trên, BTC sẽ không công nhận kết quả thi.\n\n',
                  ),
                  TextSpan(
                    text: 'Cách tính điểm:\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: 'Ban Tổ chức tính điểm dựa trên bài thi duy nhất đã nộp.\n'
                        'Với mỗi câu trả lời đúng được số điểm tương ứng theo từng mức độ câu hỏi.\n'
                        'Với mỗi câu trả lời sai không được điểm.\n'
                        'Đối với các câu hỏi Multiple choice, câu trả lời chỉ được tính điểm khi thí sinh chọn đúng tất cả các đáp án.\n'
                        'Các đội thi cần trả lời đủ 45 câu hỏi mới có đủ điều kiện nộp bài thi.\n'
                        'Đối với trường hợp các đội thi bằng điểm nhau, xếp hạng điểm số sẽ dựa trên thời gian nộp bài.\n\n',
                  ),
                  TextSpan(
                    text: 'Quy định:\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: 'Các đội thi đăng nhập vào phòng thi theo thông tin sau:\n'
                        '- Username: Email đội trưởng\n'
                        '- Password: Số điện thoại đội trưởng\n\n'
                        'Các thí sinh CHỈ CÓ THỂ DỰ THI TRONG MỘT NGÀY DUY NHẤT (05/09), vào khung giờ thi BTC quy định: từ 18:00 - 22:00. Đối với các thí sinh thực hiện bài thi NGOÀI khoảng thời gian quy định, BTC sẽ không công nhận kết quả bài thi của đội thi.\n'
                        'Điền chính xác các thông tin đăng nhập của đội thi, TUYỆT ĐỐI KHÔNG TIẾT LỘ THÔNG TIN CHO CÁC ĐỘI THI KHÁC.\n'
                        'Thí sinh chỉ sử dụng DUY NHẤT 01 Tab và 01 trình duyệt để làm bài thi, trong quá trình làm bài, thí sinh không được chuyển tab và KHÔNG THỂ QUAY LẠI CÂU ĐÃ LÀM TRƯỚC ĐÓ.\n'
                        'Thí sinh cần giữ bảo mật của đề thi, mọi trường hợp tuyên truyền, làm lộ đề thi trái phép đều bị LOẠI tư cách thi.\n'
                        'Đội thi được tính là nộp bài thành công khi có thông báo “BẠN ĐÃ HOÀN THÀNH BÀI THI TRẮC NGHIỆM VÒNG 1 CỦA CUỘC THI TẦM NHÌN THƯƠNG HIỆU!”\n'
                        'Sau khi nộp bài thi, yêu cầu thí sinh chụp lại ảnh màn hình làm minh chứng đã nộp bài và gửi vào link form BTC cung cấp.\n\n',
                  ),
                  TextSpan(
                    text: 'Lưu ý:\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: 'Đảm bảo Internet không bị gián đoạn trong thời gian làm bài.\n'
                        'Để có trải nghiệm tốt nhất, các đội thi NÊN tham gia thi trên thiết bị máy tính/ Laptop.\n'
                        'Để tránh sự cố kỹ thuật xảy ra, các đội thi chú ý:\n'
                        '- Không reload/ tắt trang web làm bài trong thời gian thi.\n'
                        '- Không đăng nhập cùng lúc nhiều tab khác nhau trên thiết bị làm bài. Phần mềm có tính năng track địa chỉ IP, trong trường hợp thí sinh chuyển tab, bài thi sẽ tự động kết thúc và đội thi bị hủy kết quả thi.\n'
                        'Nếu có sự cố kỹ thuật phát sinh vì các hành động trên, Ban Tổ chức sẽ không chịu trách nhiệm giải quyết và không công nhận kết quả bài thi của các thí sinh.\n'
                        'Sau khi hoàn thành bài thi, thí sinh NÊN chụp lại màn hình đề phòng các rủi ro và gửi minh chứng vào link sau: Link nộp minh chứng.\n'
                        'Các khiếu nại đến từ phía thí sinh phải kèm theo minh chứng xác thực nhằm phục vụ cho quá trình giải quyết khiếu nại của Ban Tổ chức.\n'
                        'Nếu đội thi tham gia vào khoảng 21h50, đội thi vẫn có thể làm bài thi đến 22h40, tuy nhiên đội thi sẽ không thể truy cập vào đề từ 22h00. Chính vì vậy BTC khuyến khích đội thi sắp xếp thời gian để làm bài thi trong thời gian quy định. Nếu có bất kỳ sự cố kỹ thuật nào sau 22h00, BTC sẽ không hỗ trợ giải quyết cho đội thi.\n\n',
                  ),
                  TextSpan(
                    text: 'Thông tin liên hệ:\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: 'Khi xảy ra sự cố kỹ thuật hay có thắc mắc về đề thi (trường hợp hy hữu), thí sinh cần nhanh chóng liên hệ với đại diện BTC phụ trách thông qua những số hotline sau:\n\n',
                  ),
                  TextSpan(
                    text: 'Hotline: 0359860686\n'
                        'Fanpage: Tầm Nhìn Thương Hiệu | Hanoi\n'
                        'Email: tamnhinthuonghieu2024@gmail.com\n\n',
                  ),
                  TextSpan(
                    text: 'Chúc các đội thi sẽ bình tĩnh, tự tin để hoàn thành thật tốt bài thi và đạt kết quả cao!\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Quay lại', style: TextStyle(color:Colors.red,fontSize: 18.sp)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); 
              onStartTest(); 
            },
            child: Text('Bắt đầu', style: TextStyle(fontSize: 18.sp)),
          ),
        ],
      );
    },
  );
}

}
