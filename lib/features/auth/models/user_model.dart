import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  int status;
  String message;
  Data data;

  UserModel({required this.status, required this.message, required this.data});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
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
  String accessToken;
  String refreshToken;
  ThongTin thongTin;

  Data({
    required this.accessToken,
    required this.refreshToken,
    required this.thongTin,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    accessToken: json["accessToken"],
    refreshToken: json["refreshToken"],
    thongTin: ThongTin.fromJson(json["ThongTin"]),
  );

  Map<String, dynamic> toJson() => {
    "accessToken": accessToken,
    "refreshToken": refreshToken,
    "ThongTin": thongTin.toJson(),
  };
}

class ThongTin {
  String tenDangNhap;
  String hoTen;
  String chucVu;
  String maChucVu;
  String maNhanSu;
  String maNhanVien;

  ThongTin({
    required this.tenDangNhap,
    required this.hoTen,
    required this.chucVu,
    required this.maChucVu,
    required this.maNhanSu,
    required this.maNhanVien,
  });

  factory ThongTin.fromJson(Map<String, dynamic> json) => ThongTin(
    tenDangNhap: json["TenDangNhap"],
    hoTen: json["HoTen"],
    chucVu: json["ChucVu"],
    maChucVu: json["MaChucVu"],
    maNhanSu: json["MaNhanSu"],
    maNhanVien: json["MaNhanVien"],
  );

  Map<String, dynamic> toJson() => {
    "TenDangNhap": tenDangNhap,
    "HoTen": hoTen,
    "ChucVu": chucVu,
    "MaChucVu": maChucVu,
    "MaNhanSu": maNhanSu,
    "MaNhanVien": maNhanVien,
  };
}
