import 'dart:convert';

List<ServiceModel> serviceModelFromJson(String str) =>
    List<ServiceModel>.from(json.decode(str).map((x) => ServiceModel.fromJson(x)));

class ServiceModel {
  String? id;
  String? service;
  String? seller_id;

  ServiceModel({this.id, this.service, this.seller_id});

  ServiceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    service = json['service'];
    seller_id = json['seller_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['service'] = service;
    data['seller_id'] = seller_id;
    return data;
  }
}