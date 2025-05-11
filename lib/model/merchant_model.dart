// To parse this JSON data, do
//
//     final merchant = merchantFromJson(jsonString);

import 'dart:convert';

Merchant merchantFromJson(String str) => Merchant.fromJson(json.decode(str));

String merchantToJson(Merchant data) => json.encode(data.toJson());

class Merchant {
  String merchantId;
  String merchantName;
  String merchantDescription;
  String merchantImage;

  Merchant({
    required this.merchantId,
    required this.merchantName,
    required this.merchantDescription,
    required this.merchantImage,
  });

  factory Merchant.fromJson(Map<String, dynamic> json) => Merchant(
    merchantId: json["merchantId"],
    merchantName: json["merchantName"],
    merchantDescription: json["merchantDescription"],
    merchantImage: json["merchantImage"],
  );

  Map<String, dynamic> toJson() => {
    "merchantId": merchantId,
    "merchantName": merchantName,
    "merchantDescription": merchantDescription,
    "merchantImage": merchantImage,
  };
}
