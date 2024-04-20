

import '../../domain/entities/user_data.dart';

class UserDataModel extends UserData{

  UserDataModel({required super.dob,required super.name,required super.imageUrl,required super.search,required super.phoneNo,required super.authId,required super.email});




  UserDataModel copyWith({
    String? name,
    String? dob,
    List? search,
    String? imageUrl,
    String? phoneNo,
    String? authId,
    String? email,
  }) {
    return UserDataModel(
      name: name ?? this.name,
      dob: dob ?? this.dob,
      search: search ?? this.search,
      imageUrl: imageUrl ?? this.imageUrl,
      phoneNo: phoneNo ?? this.phoneNo,
      authId: authId ?? this.authId,
      email: email ?? this.email,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'dob': this.dob,
      'search': this.search,
      'imageUrl': this.imageUrl,
      'phoneNo': this.phoneNo,
      'authId': this.authId,
      'email': this.email,
    };
  }

  factory UserDataModel.fromMap(Map<String, dynamic> map) {
    return UserDataModel(
      name: map['name'] ??"",
      dob: map['dob'] ??"",
      search: map['search'] ??[],
      imageUrl: map['imageUrl'] ??"",
      phoneNo: map['phoneNo'] ??"",
      authId: map['authId'] ??"",
      email: map['email'] ??"",
    );
  }


//</editor-fold>
}
