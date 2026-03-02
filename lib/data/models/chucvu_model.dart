import 'dart:convert';

ChucVuModel chucVuModelFromJson(String str) => ChucVuModel.fromJson(json.decode(str));

String chucVuModelToJson(ChucVuModel data) => json.encode(data.toJson());

class ChucVuModel {
  int status;
  String message;
  List<Datum> data;

  ChucVuModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ChucVuModel.fromJson(Map<String, dynamic> json) => ChucVuModel(
    status: json["status"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String id;
  String tenChucVu;
  int v;

  Datum({
    required this.id,
    required this.tenChucVu,
    required this.v,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["_id"],
    tenChucVu: json["TenChucVu"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "TenChucVu": tenChucVu,
    "__v": v,
  };
}
