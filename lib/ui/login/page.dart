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
    final size = MediaQuery.of(context).size;
    final width = size.width;
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
                // Assets.images.title.image(
                //   height: 450.h,
                // ),
                const SizedBox(height: 300,),
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
                    color: Theme.of(context).colorScheme.primary,
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
                          fillColor: Colors.white,
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
                          fillColor: Colors.white,
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
                        SizedBox(height: 40.hMax),
                        InkWell(
                          onTap: () async {
                            if (form.currentState!.validate()) {
                              try {
                                LoadingUtility.show();
                                final auth = AuthService();

                                final response = await auth.login(email, password);
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
                                        'Error',
                                        style: TextStyle(fontSize: 26.sp, color: Colors.red),
                                      ),
                                      content: Text(
                                        'Your login info is not correct. Please check again.',
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
                const Spacer(),
                // Container(
                //   padding: EdgeInsets.symmetric(vertical: 16.h),
                //   width: double.infinity,
                //   color: Colors.red,
                //   child: MarqueeList(
                //     scrollDuration: const Duration(milliseconds: 1500),
                //     children: [
                //       Container(
                //         width: width / 2,
                //         alignment: Alignment.center,
                //         child: Text(
                //           'Career Leap',
                //           style: TextStyle(
                //             fontWeight: FontWeight.w900,
                //             fontSize: 30.sp,
                //             color: Colors.white,
                //           ),
                //         ),
                //       ),
                //       Text(
                //         '-',
                //         style: TextStyle(
                //           fontWeight: FontWeight.w900,
                //           fontSize: 30.sp,
                //           color: Colors.white,
                //         ),
                //       ),
                //       Container(
                //         width: width / 2,
                //         alignment: Alignment.center,
                //         child: Text(
                //           'Healthy Growth',
                //           style: TextStyle(
                //             fontWeight: FontWeight.w900,
                //             fontSize: 30.sp,
                //             color: Colors.white,
                //           ),
                //         ),
                //       ),
                //       Text(
                //         '-',
                //         style: TextStyle(
                //           fontWeight: FontWeight.w900,
                //           fontSize: 30.sp,
                //           color: Colors.white,
                //         ),
                //       ),
                //       Container(
                //         width: width / 2,
                //         alignment: Alignment.center,
                //         child: Text(
                //           'Project Ownership',
                //           style: TextStyle(
                //             fontWeight: FontWeight.w900,
                //             fontSize: 30.sp,
                //             color: Colors.white,
                //           ),
                //         ),
                //       )
                //     ],
                //   ),
                // )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
