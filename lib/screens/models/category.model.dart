import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Category {
  String? code;
  String? name;
  String? image;
  Category({
    required this.code,
    required this.name,
    required this.image,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      code: json['code'],
      name: json['name'],
      image: json['image'],
    );
  }
}
