import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/common/loader.dart';
import '../../../../core/utils/show_snackbar.dart';
import '../../../home/home_page.dart';
import '../bloc/auth_bloc.dart';
import 'login_page.dart';

class VerifyOtpPage extends StatefulWidget {
  final String phoneNo;
 final  String verificationId;
  const VerifyOtpPage({super.key,required this.phoneNo,required this.verificationId});

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    String minutesStr = (minutes < 10) ? '0$minutes' : '$minutes';
    String secondsStr = (remainingSeconds < 10) ? '0$remainingSeconds' : '$remainingSeconds';
    return '$minutesStr:$secondsStr';
  }
  int _secondsRemaining = 120;
  late Timer _timer;
  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer.cancel();
        }
      });
    });
  }
  TextEditingController otpController = TextEditingController();
  @override
  void dispose() {
  otpController.dispose();
    super.dispose();
  }
@override
  void initState() {
  Future.delayed(const Duration(minutes: 4,seconds: 1)).then((value) {
    showSnackBar(context, "Session Expired");
    Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => const LoginPage(),), (route) => false);
  });
  Future.delayed(const Duration(minutes: 2,seconds: 1)).then((value) {
    showSnackBar(context, "Otp is Resend to your Mobile Number");
    context.read<AuthBloc>().add(AuthLogin(phoneNo: widget.phoneNo, context: context));
  });
    startTimer();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    var width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body:
      SafeArea(
        child: Container(
          width: width,
          height: height,
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            child:BlocConsumer<AuthBloc,AuthState>(builder: (context, state) {
              if(state is AuthLoading){
                return const Loader();
              }
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height * 0.1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: height * 0.18,
                          width: width*0.4,
                          child: Image.asset("assets/logoWithback.png"),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.06,
                    ),
                    Text(
                      'OTP Verification',
                      style: TextStyle(

                          fontSize: width * 0.045, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: height * 0.035,
                    ),
                    Text(
                      'Enter the verification code we just sent to your number +91 ********${widget.phoneNo.substring(8, 10)}',
                      style: TextStyle(fontSize: width * 0.04),
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Pinput(
                      submittedPinTheme:  PinTheme(
                          textStyle: TextStyle(
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: width*0.05,
                          ),
                          width: width*0.15,
                          height: width*0.15,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(width*0.03),

                              border: Border.all(color: const Color(0xFFA0C129),width: 2)
                          )),
                      defaultPinTheme: PinTheme(
                          textStyle: TextStyle(
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: width*0.05,
                          ),
                          width: width*0.15,
                          height: width*0.15,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(width*0.03),

                              border: Border.all(color: const Color(0xFF26BCB1),width: 2)
                          )),
                      cursor: const SizedBox(),
                      disabledPinTheme: PinTheme(
                          textStyle: TextStyle(
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: width*0.05,
                          ),
                          width: width*0.15,
                          height: width*0.15,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(width*0.03),

                              border: Border.all(color: const Color(0xFF26BCB1),width: 2)
                          )),
                      focusedPinTheme:  PinTheme(
                          textStyle: TextStyle(
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: width*0.05,
                          ),
                          width: width*0.15,
                          height: width*0.15,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(width*0.03),

                              border: Border.all(color: const Color(0xFFA0C129),width: 2)
                          )),

                      controller: otpController,
                      keyboardType: TextInputType.number,
                      length: 6,
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Auto Resend Otp After ",
                          style: TextStyle(fontSize: width * 0.035),
                        ),
                        Text(
                          _formatTime(_secondsRemaining),
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: width * 0.035),
                        )
                      ],
                    ),
                    SizedBox(
                      height: height*0.02,
                    ),
                    InkWell(
                      onTap: () {
                        if(otpController.text.trim().isEmpty||otpController.text.trim().length!=6){
                          showSnackBar(context,"Please enter the Otp");
                        }
                        else{
                          context.read<AuthBloc>().add(AuthOtpVerify(otp: otpController.text.trim(), verificationId: widget.verificationId));
                        }

                      },
                      child: Container(
                        height: height * 0.06,
                        width: width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(height * 0.25),
                          gradient: const LinearGradient(colors: [Color(0xFF26BCB1),Color(0xFFA0C129)]),),
                        child: Center(
                          child: Text(
                            'Verify',
                            style:
                            TextStyle(fontSize: width * 0.04,fontFamily: "Montserrat",fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }, listener: (context, state) async {
              if (state is AuthFailure) {
                showSnackBar(context, state.message.toString());
              } else if (state is AuthSuccess) {
                if(state.success==""){
                  showSnackBar(context, "Otp is Resend to your Phone Number");
                }
                else{
                 final SharedPreferences local=await SharedPreferences.getInstance();
                 local.setString("uid", state.success);

                  showSnackBar(context, "Otp Verification Successful");
                  Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) =>const HomePage() ,), (route) => false);
                }





              }
            },),

          ),
        ),
      ),
    );

  }
}
