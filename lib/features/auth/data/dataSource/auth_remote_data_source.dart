import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:lilac_task/features/auth/data/model/user_data_model.dart';


import '../../../../core/constant/firebase_constant.dart';
import '../../../../core/error/exception.dart';
import '../../presentation/pages/verify_otp_page.dart';

abstract interface class AuthRemoteDataSource {
  Future<String> loginWithPhoneNo({
    required String phoneNo,
    required BuildContext context,
  });
  Future<String>verifyOtp({
    required String verificationId,
    required String otp
});
  Future<String>uploadImage({
    required File image,

  });
  Future<UserDataModel>addUser( UserDataModel userDataModel
  );
  Future<UserDataModel>getUser( {required String authId});

}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final FirebaseStorage firebaseStorage;
  const AuthRemoteDataSourceImpl(this.firebaseAuth,this.firestore,this.firebaseStorage);

  @override
  Future<String> loginWithPhoneNo({
    required String phoneNo,
    required BuildContext  context
  }) async {
    try {

    await firebaseAuth.verifyPhoneNumber(
          phoneNumber: "+91$phoneNo",
          verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
            await firebaseAuth.signInWithCredential(phoneAuthCredential);
          },
          verificationFailed: (FirebaseAuthException error) {
            throw ServerException(message: error.toString());
          },
          codeSent: (String verificationId, int? forceResendingToken) {
            Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) =>  VerifyOtpPage(phoneNo: phoneNo,verificationId: verificationId),), (route) => false);

          },
           codeAutoRetrievalTimeout: (String verificationId) {});

      return "";
    }on FirebaseAuthException catch(e){
      throw ServerException(message: e.toString());
    }
    catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> verifyOtp({required String verificationId, required String otp}) async{
    try{
      PhoneAuthCredential credential=PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otp);
      final res=await firebaseAuth.signInWithCredential(credential);
      if(res.user==null){
        throw const ServerException(message: "Invalid Otp");
      }
    return res.user!.uid;
    }on FirebaseAuthException catch(e){
      throw ServerException(message: e.toString());
    }
    catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserDataModel> addUser(UserDataModel user) async {
    try{

    await firestore.collection(FirebaseConstants.userCollection).doc(user.authId).set(user.toMap());
    return user;
    }on FirebaseException catch(e){
    throw ServerException(message: e.toString());
    } catch(e){
    throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> uploadImage({required File image}) async {
    try{
      final Reference storageRef =
      firebaseStorage.ref().child('images/profile/${DateTime.now().toString()}-${image.path}');
      final UploadTask uploadTask = storageRef.putFile(image);
      final res=await uploadTask;
      // Get download URL
      return (await res.ref.getDownloadURL());

    }on FirebaseException catch(e){
    throw ServerException(message: e.toString());
    } catch(e){
    throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserDataModel> getUser({required String authId}) async {
    try{
      final res=await firestore.collection(FirebaseConstants.userCollection).doc(authId).get().then((value) => UserDataModel.fromMap(value.data() as Map<String,dynamic>));

      // Get download URL
      return (res);

    }on FirebaseException catch(e){
    throw ServerException(message: e.toString());
    } catch(e){
    throw ServerException(message: e.toString());
    }
  }
}
