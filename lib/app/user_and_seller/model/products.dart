import 'dart:convert';

List<Products> productsFromJson(String str) =>
    List<Products>.from(json.decode(str).map((x) => Products.fromJson(x)));

String productsToJson(List<Products> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Products {
  Products({
    required this.pid,
    required this.imgurl,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.sellerId,
    required this.stock,
    required this.stock_alert,
    required this.gst,
    required this.sellerBoost
  });

  dynamic pid;
  dynamic imgurl;
  dynamic name;
  dynamic description;
  dynamic price;
  dynamic categoryId;
  dynamic sellerId;
  dynamic gst;
  dynamic sellerBoost ;
  dynamic stock ;
  dynamic stock_alert ;

  factory Products.fromJson(Map<String, dynamic> json) => Products(
        pid: json["pid"].toString(),
        imgurl: json["imgurl"],
        name: json["name"],
        description: json["description"],
        price: json["price"].toString(),
        categoryId: json["category_id"].toString(),
        sellerId: json["seller_id"].toString(),
        stock: json["stock"].toString(),
        stock_alert: json["stock_alert"].toString(),
        gst: json["gst"].toString(),
        sellerBoost: json["sellerBoost"].toString()
      );

  Map<String, dynamic> toJson() => {
        "pid": pid,
        "imgurl": imgurl,
        "name": name,
        "description": description,
        "price": price,
        "category_id": categoryId,
        "seller_id": sellerId,
        "stock":stock,
        "stock_alert":stock_alert,
        "gst": gst,
        "sellerBoost": sellerBoost
      };
}
