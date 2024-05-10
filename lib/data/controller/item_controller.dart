import 'dart:convert';

import 'package:get/get.dart';
import 'package:online_auction_platform/data/api/api.dart';
import 'package:online_auction_platform/data/model/bid_model.dart';
import 'package:online_auction_platform/data/model/item_model.dart';

import 'package:http/http.dart' as http;

class ItemController extends GetxController {
  final items = <ItemData>[].obs;
  final bids = <Bids>[].obs;

  final itemsubmiterr = ''.obs;
  final item = ItemData().obs;

  final maxbid = 0.0.obs;

  void fetchData() async {
    print('Fetching Data');
    try {
      final response = await http.get(
        Uri.parse(Api.items),
      );
      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          return;
        }
        saveItems(jsonDecode(response.body));
      } else {
        print('Response Status Code: ${response.body}');
      }
    } catch (e, stackTrace) {
      print('Error: $e');
      print('Stack Trace: $stackTrace');
    }
  }

  void saveItems(List<dynamic> item) {
    items.value = item.map((json) => ItemData.fromJson(json)).toList();
  }

  void itemSubmitError(String error) {
    itemsubmiterr.value = error;
  }

  void showSingleItem(Map<String, dynamic> singitem) {
    item.value = ItemData.fromJson(singitem);
  }

  Future<void> fetchBidData() async {
    print('Fetching Data');
    try {
      final response = await http.get(
        Uri.parse("${Api.aitembids}/${item.value.id}"),
      );
      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          return;
        }
        saveBids(jsonDecode(response.body));
      } else {
        print('Response Status Code: ${response.body}');
      }
    } catch (e, stackTrace) {
      print('Error: $e');
      print('Stack Trace: $stackTrace');
    }
  }

  void saveBids(List<dynamic> bid) {
    bids.value = bid.map((json) => Bids.fromJson(json)).toList();
    maxbid.value = bids[0].bidPrice.toDouble();
  }
}
