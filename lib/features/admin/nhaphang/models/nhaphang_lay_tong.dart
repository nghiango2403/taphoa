import 'dart:convert';

PhieuNhapHangLayModel phieuNhapHangLayModelFromJson(String str) =>
    PhieuNhapHangLayModel.fromJson(json.decode(str));

String phieuNhapHangLayModelToJson(PhieuNhapHangLayModel data) =>
    json.encode(data.toJson());

class PhieuNhapHangLayModel {
  int status;
  String message;
  Data data;

  PhieuNhapHangLayModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PhieuNhapHangLayModel.fromJson(Map<String, dynamic> json) =>
      PhieuNhapHangLayModel(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  List<Danhsach> danhsach;
  int sotrang;

  Data({required this.danhsach, required this.sotrang});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    danhsach: List<Danhsach>.from(
      json["danhsach"].map((x) => Danhsach.fromJson(x)),
    ),
    sotrang: json["sotrang"],
  );

  Map<String, dynamic> toJson() => {
    "danhsach": List<dynamic>.from(danhsach.map((x) => x.toJson())),
    "sotrang": sotrang,
  };
}

class Danhsach {
  String id;
  DateTime thoiGianNhap;
  int v;

  Danhsach({required this.id, required this.thoiGianNhap, required this.v});

  factory Danhsach.fromJson(Map<String, dynamic> json) => Danhsach(
    id: json["_id"],
    thoiGianNhap: DateTime.parse(json["ThoiGianNhap"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "ThoiGianNhap": thoiGianNhap.toIso8601String(),
    "__v": v,
  };
}
