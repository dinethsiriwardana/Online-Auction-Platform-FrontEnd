import 'package:flutter/material.dart';

class ItemData {
  final int id;
  final String name;
  final String description;
  final double startPrice;
  final String createdAt;
  final String expiredAt;
  final int addedBy;

  ItemData({
    required this.id,
    required this.name,
    required this.description,
    required this.startPrice,
    required this.createdAt,
    required this.expiredAt,
    required this.addedBy,
  });

  factory ItemData.fromJson(Map<String, dynamic> json) {
    return ItemData(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      startPrice: json['start_price'].toDouble(),
      createdAt: json['createdAt'],
      expiredAt: json['expiredAt'],
      addedBy: json['add_by'],
    );
  }
}
