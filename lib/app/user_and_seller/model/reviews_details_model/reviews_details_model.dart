import 'dart:convert';

/// product_id : 18
/// product_image : "assets/headphone_9.png"
/// average_rating : 4.2
/// total_reviews : 5
/// reviews : [{"user_name":"Amit ","user_image":"https://iili.io/2BVKvEP.png","rating":5,"review":"bghghgfvvxg","comments":[{"comment_id":1,"review_id":16,"user_id":1,"parent_comment_id":null,"comment_text":"vgghrtg gd hgeru g  fhiuhfwi  fhuig"},{"comment_id":2,"review_id":16,"user_id":6,"parent_comment_id":1,"comment_text":"rgfreg fhhi ht  hct3b thbtbfc3"}]},{"user_name":"Amit ","user_image":"https://iili.io/2BVKvEP.png","rating":4,"review":"svdnfw","comments":[]},{"user_name":"Amit ","user_image":"https://iili.io/2BVKvEP.png","rating":4,"review":"svdnfw","comments":[]},{"user_name":"Amit ","user_image":"https://iili.io/2BVKvEP.png","rating":4,"review":"svdnfw","comments":[]},{"user_name":"Amit ","user_image":"https://iili.io/2BVKvEP.png","rating":4,"review":"svdnfw","comments":[]}]

ReviewsDetailsModel ssFromJson(String str) =>
    ReviewsDetailsModel.fromJson(json.decode(str));
String ssToJson(ReviewsDetailsModel data) => json.encode(data.toJson());

class ReviewsDetailsModel {
  ReviewsDetailsModel({
    this.productId,
    this.averageRating,
    this.totalReviews,
    this.reviews,
  });

  ReviewsDetailsModel.fromJson(dynamic json) {
    productId = json['product_id'];
    averageRating = json['average_rating'];
    totalReviews = json['total_reviews'];
    if (json['reviews'] != null) {
      reviews = [];
      json['reviews'].forEach((v) {
        reviews?.add(Reviews.fromJson(v));
      });
    }
  }
  num? productId;
  num? averageRating;
  num? totalReviews;
  List<Reviews>? reviews;
  ReviewsDetailsModel copyWith({
    num? productId,
    String? productImage,
    num? averageRating,
    num? totalReviews,
    List<Reviews>? reviews,
  }) =>
      ReviewsDetailsModel(
        productId: productId ?? this.productId,
        averageRating: averageRating ?? this.averageRating,
        totalReviews: totalReviews ?? this.totalReviews,
        reviews: reviews ?? this.reviews,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['product_id'] = productId;
    map['average_rating'] = averageRating;
    map['total_reviews'] = totalReviews;
    if (reviews != null) {
      map['reviews'] = reviews?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// user_name : "Amit "
/// user_image : "https://iili.io/2BVKvEP.png"
/// rating : 5
/// review : "bghghgfvvxg"
/// comments : [{"comment_id":1,"review_id":16,"user_id":1,"parent_comment_id":null,"comment_text":"vgghrtg gd hgeru g  fhiuhfwi  fhuig"},{"comment_id":2,"review_id":16,"user_id":6,"parent_comment_id":1,"comment_text":"rgfreg fhhi ht  hct3b thbtbfc3"}]

Reviews reviewsFromJson(String str) => Reviews.fromJson(json.decode(str));
String reviewsToJson(Reviews data) => json.encode(data.toJson());

class Reviews {
  Reviews({
    this.userName,
    this.userImage,
    this.rating,
    this.review,
    this.comments,
  });

  Reviews.fromJson(dynamic json) {
    userName = json['user_name'];
    userImage = json['user_image'];
    rating = json['rating'];
    review = json['review'];
    if (json['comments'] != null) {
      comments = [];
      json['comments'].forEach((v) {
        comments?.add(Comments.fromJson(v));
      });
    }
  }
  String? userName;
  String? userImage;
  num? rating;
  String? review;
  List<Comments>? comments;
  Reviews copyWith({
    String? userName,
    String? userImage,
    num? rating,
    String? review,
    List<Comments>? comments,
  }) =>
      Reviews(
        userName: userName ?? this.userName,
        userImage: userImage ?? this.userImage,
        rating: rating ?? this.rating,
        review: review ?? this.review,
        comments: comments ?? this.comments,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_name'] = userName;
    map['user_image'] = userImage;
    map['rating'] = rating;
    map['review'] = review;
    if (comments != null) {
      map['comments'] = comments?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// comment_id : 1
/// review_id : 16
/// user_id : 1
/// parent_comment_id : null
/// comment_text : "vgghrtg gd hgeru g  fhiuhfwi  fhuig"

Comments commentsFromJson(String str) => Comments.fromJson(json.decode(str));
String commentsToJson(Comments data) => json.encode(data.toJson());

class Comments {
  Comments({
    this.commentId,
    this.reviewId,
    this.userId,
    this.parentCommentId,
    this.commentText,
  });

  Comments.fromJson(dynamic json) {
    commentId = json['comment_id'];
    reviewId = json['review_id'];
    userId = json['user_id'];
    parentCommentId = json['parent_comment_id'];
    commentText = json['comment_text'];
  }
  num? commentId;
  num? reviewId;
  num? userId;
  dynamic parentCommentId;
  String? commentText;
  Comments copyWith({
    num? commentId,
    num? reviewId,
    num? userId,
    dynamic parentCommentId,
    String? commentText,
  }) =>
      Comments(
        commentId: commentId ?? this.commentId,
        reviewId: reviewId ?? this.reviewId,
        userId: userId ?? this.userId,
        parentCommentId: parentCommentId ?? this.parentCommentId,
        commentText: commentText ?? this.commentText,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['comment_id'] = commentId;
    map['review_id'] = reviewId;
    map['user_id'] = userId;
    map['parent_comment_id'] = parentCommentId;
    map['comment_text'] = commentText;
    return map;
  }
}
