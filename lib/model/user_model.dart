
import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? firstName;
  String? lastName;
  String? gender;
  dynamic dateOfBirth;
  String? id;
  DateTime? createDate;
  String? email;
  String? contactNo;
  String? profileImg;
  int? userCoins;
  int? userStreakPoint;
  String? referralCode;
  String? referredBy;

  UserModel({
    this.firstName,
    this.lastName,
    this.gender,
    this.dateOfBirth,
    this.id,
    this.createDate,
    this.email,
    this.contactNo,
    this.profileImg,
    this.userCoins,
    this.userStreakPoint,
    this.referralCode,
    this.referredBy,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    firstName: json["firstName"],
    lastName: json["lastName"],
    gender: json["gender"],
    dateOfBirth: json["dateOfBirth"],
    id: json["id"],
    createDate: json["create_date"] == null ? null : DateTime.parse(json["create_date"]),
    email: json["email"],
    contactNo: json["contactNo"],
    profileImg: json["profile_img"],
    userCoins: json["userCoins"],
    userStreakPoint: json["userStreakPoint"],
    referralCode: json["referralCode"],
    referredBy: json["referredBy"],
  );

  Map<String, dynamic> toJson() => {
    "firstName": firstName,
    "lastName": lastName,
    "gender": gender,
    "dateOfBirth": dateOfBirth,
    "id": id,
    "create_date": createDate?.toIso8601String(),
    "email": email,
    "contactNo": contactNo,
    "profile_img": profileImg,
    "userCoins": userCoins,
    "userStreakPoint": userStreakPoint,
    "referralCode": referralCode,
    "referredBy": referredBy,
  };
}
