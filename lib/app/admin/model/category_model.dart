import 'dart:convert';

List<CategoryModel> categoryModelFromJson(String str) =>
    List<CategoryModel>.from(json.decode(str).map((x) => CategoryModel.fromJson(x)));

class CategoryModel {
  String? cid;
  String? category;

  CategoryModel({this.cid, this.category});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    cid = json['cid'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['cid'] = cid;
    data['category'] = category;
    return data;
  }
}