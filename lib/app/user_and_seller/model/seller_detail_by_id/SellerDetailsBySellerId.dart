import 'dart:convert';

/// id : 2
/// shop_name : "SarShop"
/// email : "sar1@k.com"
/// password : 12345678
/// lat : 25.5941
/// lng : 85.1376
/// address : "dfsf"
/// phone : 1234567890
/// delivery_area : "Prayagraj"
/// gst : 19
/// isRestrict : 1
/// is_third_party : 0
/// service_type : null
/// service_locations : null

SellerDetailsBySellerId sellFromJson(String str) =>
    SellerDetailsBySellerId.fromJson(json.decode(str));
String sellToJson(SellerDetailsBySellerId data) => json.encode(data.toJson());

class SellerDetailsBySellerId {
  SellerDetailsBySellerId({
    this.id,
    this.shopName,
    this.email,
    // this.password,
    this.lat,
    this.lng,
    this.address,
    this.phone,
    this.deliveryArea,
    this.gst,
    this.isRestrict,
    this.isThirdParty,
    // this.serviceType,
    // this.serviceLocations,
  });

  SellerDetailsBySellerId.fromJson(dynamic json) {
    id = json['id'];
    shopName = json['shop_name'];
    email = json['email'];
    // password = json['password'];
    lat = json['lat'];
    lng = json['lng'];
    address = json['address'];
    phone = json['phone'];
    deliveryArea = json['delivery_area'];
    gst = json['gst'];
    isRestrict = json['isRestrict'];
    isThirdParty = json['is_third_party'];
    // serviceType = json['service_type'];
    // serviceLocations = json['service_locations'];
  }
  dynamic id;
  String? shopName;
  String? email;
  double? lat;
  double? lng;
  String? address;
  String? phone;
  String? deliveryArea;
  int? gst;
  int? isRestrict;
  int? isThirdParty;

  SellerDetailsBySellerId copyWith({
    dynamic id,
    String? shopName,
    String? email,
    double? lat,
    double? lng,
    String? address,
    String? phone,
    String? deliveryArea,
  }) =>
      SellerDetailsBySellerId(
        id: id ?? this.id,
        shopName: shopName ?? this.shopName,
        email: email ?? this.email,
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
        address: address ?? this.address,
        phone: phone ?? this.phone,
        deliveryArea: deliveryArea ?? this.deliveryArea,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['shop_name'] = shopName;
    map['email'] = email;

    map['lat'] = lat;
    map['lng'] = lng;
    map['address'] = address;
    map['phone'] = phone;
    map['delivery_area'] = deliveryArea;

    return map;
  }
}
