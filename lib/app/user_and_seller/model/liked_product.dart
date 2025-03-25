class likedProduct {
  dynamic lid;
  dynamic pid;
  dynamic imageUrl;
  dynamic name;
  dynamic description;
  dynamic price;
  dynamic categoryId;
  dynamic sellerId;
  dynamic gst;
  dynamic emailId;
  dynamic sellerBoost ;

  likedProduct({
    required this.lid,
   required this.pid,
   required this.imageUrl,
   required this.name,
   required this.description,
   required this.price,
   required this.categoryId,
   required this.sellerId,
   required this.gst,
   required this.emailId,
   required this.sellerBoost
  });

  factory likedProduct.fromJson(Map<String, dynamic> json) {
    return likedProduct(
      lid: json['lid'] == null ? "": int.parse(json['lid']),
      pid: json['pid'] == null ? "": int.parse(json['pid']),
      imageUrl: json['imageurl'] ?? "",
      name: json['name']??"",
      description: json['description']??"",
      price: json['price'] == null ? "": double.parse(json['price']), // Convert to double
      categoryId:json['categoryid'] == null ? "" : int.parse(json['categoryid']),
      sellerId:json['seller_id'] == null ? "": int.parse(json['seller_id']),
      gst: json['gst'] == null ? "" : double.parse(json['gst']), // Convert to double
      emailId: json['email_id'] ?? "",
      sellerBoost: json['sellerBoost'] ?? ""
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lid'] = this.lid;
    data['pid'] = this.pid;
    data['imageurl'] = this.imageUrl;
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['categoryid'] = this.categoryId;
    data['seller_id'] = this.sellerId;
    data['gst'] = this.gst;
    data['email_id'] = this.emailId;
    return data;
  }
}
