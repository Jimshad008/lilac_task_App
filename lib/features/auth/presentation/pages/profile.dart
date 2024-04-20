import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lilac_task/features/home/presentation/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/common/loader.dart';
import '../../../../core/utils/pick_image.dart';
import '../../../../core/utils/show_snackbar.dart';
import '../bloc/auth_bloc.dart';

class ProfilePage extends StatefulWidget {
  final String authId;
  final String phoneNo;
  const ProfilePage({super.key,required this.phoneNo,required this.authId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  String? validateEmail(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    return value!.isNotEmpty && !regex.hasMatch(value)
        ? 'Enter a valid email address'
        : null;
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      });
    }
  }
  File? image;

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }
  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
   _dateController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;
    return Scaffold(
body: SafeArea(
  child:   SingleChildScrollView(
    child: Container(
      height: height,
      width: width,
      color: Theme.of(context).primaryColor,
      child: Padding(

        padding:  EdgeInsets.only(left: width*0.05,right: width*0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding:  EdgeInsets.only(left: width*0.05,right: width*0.05),
              child: Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Create Profile ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: width*0.07,fontFamily: "Montserrat",),),
                ],
              ),
            ),
            SizedBox(height: height*0.03,),
            BlocConsumer<AuthBloc,AuthState>(builder: (context, state) {
              if(state is AuthLoading){
                return const Loader();
              }
              return  Form(
                key: _formKey,
                child: Container(
                  width: width*0.8,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border:Border.all(color: Theme.of(context).hintColor,width: 2)
                  ),

                  child: Padding(
                    padding:  EdgeInsets.only(left: width*0.05,right: width*0.05),
                    child: Column(

                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: height*0.02,),
                        SizedBox(
                          width: width,
                          child: Center(
                            child: GestureDetector(
                                onTap: () {
                                  selectImage();

                                },
                                child: image==null?CircleAvatar(
                                  radius: width*0.11,
                                  backgroundImage: const AssetImage('assets/default_avatar.png'),
                                ):CircleAvatar(
                                  radius: width*0.11,
                                  backgroundImage:  FileImage(image!),
                                )),
                          ),
                        ),
                        SizedBox(height: height*0.015,),
                        const Text('Name'),
                        SizedBox(height: height*0.015,),
                        SizedBox(
                          height: height * 0.06,
                          child: TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                              hintText: 'Enter Name',
                              hintStyle: TextStyle(
                                fontSize: width * 0.035, color: Theme.of(context).hintColor,),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0xFF26BCB1),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0xFF26BCB1),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:  const BorderSide(
                                  color:Color(0xFFA0C129),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        SizedBox(height: height*0.015,),
                        const Text('Email'),
                        SizedBox(height: height*0.015,),
                        SizedBox(
                          height: height * 0.06,
                          child: TextFormField(
                            controller: emailController,
                            validator: (value) {
                              return  validateEmail(value);
                            },
                            decoration: InputDecoration(
                              hintText: 'Enter Email',
                              hintStyle: TextStyle(
                                fontSize: width * 0.035, color: Theme.of(context).hintColor,),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0xFF26BCB1),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0xFF26BCB1),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:  const BorderSide(
                                  color:Color(0xFFA0C129),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        SizedBox(height: height*0.015,),
                        const Text('Date of Birth'),
                        SizedBox(height: height*0.015,),
                        SizedBox(
                          height: height * 0.06,
                          child: TextFormField(
                            controller: _dateController,
                            readOnly: true,
                            onTap: () => _selectDate(context),
                            decoration:  InputDecoration(

                              hintText: 'Select Date',
                              prefixIcon: const Icon(Icons.calendar_today),
                              hintStyle: TextStyle(
                                fontSize: width * 0.035, color: Theme.of(context).hintColor,),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0xFF26BCB1),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0xFF26BCB1),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:  const BorderSide(
                                  color:Color(0xFFA0C129),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: Theme.of(context).primaryColor,
                            ),
                          ),

                        ),
                        SizedBox(height: height*0.05,),
                        Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if(image!=null&&nameController.text.isNotEmpty&&_dateController.text.trim().isNotEmpty&&emailController.text.isNotEmpty) {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<AuthBloc>().add(AuthAddUser(
                                        image: image!,
                                        authId: widget.authId,
                                        phoneNo: widget.phoneNo,
                                        name: nameController.text.trim(),
                                        email: emailController.text.trim(),
                                        dob: _dateController.text.trim()));
                                  }
                                }
                                else{
                                  image==null?showSnackBar(context,"Please select an Image"):nameController.text.isEmpty?showSnackBar(context,"Please enter  name"):emailController.text.isEmpty?showSnackBar(context,"Please enter email"):showSnackBar(context,"Please select Date of Birth");
                                }

                              },
                              child: Container(
                                width: width*0.5,
                                height: height*0.06,
                                decoration: BoxDecoration(
                                    gradient: const LinearGradient(colors: [Color(0xFF26BCB1),Color(0xFFA0C129)]),
                                    borderRadius: BorderRadius.circular(width*0.08)
                                ),
                                child: Center(child: Text("Create",style: TextStyle(fontSize: width*0.05,fontWeight: FontWeight.bold,fontFamily: "Montserrat",),)),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: height*0.05,),
                      ],),
                  ),
                ),
              );
            }, listener: (context, state) async {
              if (state is AuthFailure) {
                showSnackBar(context, state.message.toString());
              } else if (state is AuthSuccess2) {
                final SharedPreferences local=await SharedPreferences.getInstance();
                local.setString("uid", state.user.authId);
                  Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) =>HomePage(user: state.user) ,), (route) => false);






              }
            },)

          ],
        ),
      ),
    ),
  ),
),
    );
  }
}
