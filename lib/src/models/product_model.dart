import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  String id;
  String title;
  double value;
  bool active;
  String fotoUrl;

  ProductModel({
    this.id,
    this.title = '',
    this.value = 0.0,
    this.active = true,
    this.fotoUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        title: json["title"],
        value: json["value"],
        active: json["active"],
        fotoUrl: json["fotoUrl"],
      );

  Map<String, dynamic> toJson() => {
        // "id": id,
        "title": title,
        "value": value,
        "active": active,
        "fotoUrl": fotoUrl,
      };
}
