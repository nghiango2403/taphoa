// To parse this JSON data, do
//
//     final accountEditModel = accountEditModelFromJson(jsonString);

import 'dart:convert';

AccountEditModel accountEditModelFromJson(String str) =>
    AccountEditModel.fromJson(json.decode(str));

String accountEditModelToJson(AccountEditModel data) =>
    json.encode(data.toJson());

class AccountEditModel {
  int status;
  String message;

  AccountEditModel({required this.status, required this.message});

  factory AccountEditModel.fromJson(Map<String, dynamic> json) =>
      AccountEditModel(status: json["status"], message: json["message"]);

  Map<String, dynamic> toJson() => {"status": status, "message": message};
}
