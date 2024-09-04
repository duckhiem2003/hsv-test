// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:web_test/common/extension/num_extension.dart';
import 'package:web_test/common/widget/text_field_widget.dart';
import 'package:web_test/generated/assets.gen.dart';
import 'package:web_test/main.dart';
import 'package:web_test/service/auth.dart';
import 'package:web_test/service/local.dart';
import 'package:web_test/ui/admin/page.dart';
import 'package:web_test/utility/loading.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final form = GlobalKey<FormState>();
  String email = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Assets.images.background.image(
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          // Positioned(
          //   left: 30.w,
          //   top: 20.h,
          //   width: 150.w,
          //   child: Assets.images.logo.image(),
          // ),
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                
                // const SizedBox(height: 300,),
                Padding(
                  padding: EdgeInsets.only(left: 700.w),
                  child: Column(
                    children: [
                      Assets.images.title.image(
                        height: 450.h
                      ),
                      Container(
                        width: 600.w,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.8),
                              spreadRadius: 1,
                              blurRadius: 8,
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                        child: Form(
                          key: form,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFieldWidget(
                                label: 'Username',
                                labelStyle: const TextStyle(color: Colors.black),
                                fillColor: const Color(0xFF759B82),
                                filled: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your username.';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  email = value;
                                },
                              ),
                              SizedBox(
                                height: 24.hMax,
                              ),
                              TextFieldWidget(
                                label: 'Password',
                                fillColor: const Color(0xFF759B82),
                                labelStyle: const TextStyle(color: Colors.black),
                                filled: true,
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password.';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  password = value;
                                },
                              ),
                              SizedBox(height: 30.hMax),
                              InkWell(
                                onTap: () async {
                                  if (form.currentState!.validate()) {
                                    try {
                                      LoadingUtility.show();
                                      final auth = AuthService();
                                      email = email.replaceAll('.', ',');
                                      final response = await auth.login(email, password);
                                      email = email.replaceAll(',', '.');
                                      if (response==LoginType.user) {
                                        LocalStorageUtility.storeData('username', email);
                                        LocalStorageUtility.storeData('userType', 'user');
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const StartPage(),
                                          ),
                                        );
                                      }
                                      else if(response==LoginType.admin){
                                        LocalStorageUtility.storeData('username', email);
                                        LocalStorageUtility.storeData('userType', 'admin');
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const AdminPage(),
                                          ),
                                        );
                                      }
                                      else {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text(
                                              'Lỗi',
                                              style: TextStyle(fontSize: 26.sp, color: Colors.red),
                                            ),
                                            content: Text(
                                              'Thông tin đăng nhập của bạn chưa đúng. Xin hãy thử lại',
                                              style: TextStyle(
                                                fontSize: 18.sp,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text(
                                            'Error',
                                            style: TextStyle(fontSize: 26.sp, color: Colors.red),
                                          ),
                                          content: Text(
                                            e.toString(),
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      );
                                    } finally {
                                      LoadingUtility.dismiss();
                                    }
                                  }
                                },
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.r),
                                    color: Colors.black,
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Sign In',
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
                      ),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
