import 'dart:convert';

import 'package:get/get.dart';
import 'package:online_auction_platform/data/api/api.dart';
import 'package:online_auction_platform/data/model/bid_model.dart';
import 'package:online_auction_platform/data/model/item_model.dart';

import 'package:http/http.dart' as http;
import 'package:online_auction_platform/utl/dat_time_formatter.dart';

class ItemController extends GetxController {
  final items = <ItemData>[].obs;
  final itemsexpired = <ItemData>[].obs;
  final bids = <Bids>[].obs;

  final itemsubmiterr = ''.obs;
  final item = ItemData().obs;
  final maxbids = {}.obs;

  final maxbid = 0.0.obs;

  void maxBidsfetchData() async {
    print('Fetching Data');
    try {
      final response = await http.get(
        Uri.parse(Api.maxBid),
      );
      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          return;
        }
        //to map
        maxbids.value = jsonDecode(response.body);
      } else {
        print('Response Status Code: ${response.body}');
      }
    } catch (e, stackTrace) {
      print('Error: $e');
      print('Stack Trace: $stackTrace');
    }
  }

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

  void saveItems(List<dynamic> itemsList) {
// Convert the list of dynamic objects to a list of ItemData objects
    List<ItemData> mapeditems =
        itemsList.map((item) => ItemData.fromJson(item)).toList();

    // Separate items into those that are expired and those that are not
    mapeditems.forEach((item) {
      DateTime now = DateTime.now();
      DateTime itemExpiredDate = DateTime.parse(item.expiredAt ?? '');

      // Check if the item has expired
      bool isExpired = now.isAfter(itemExpiredDate);

      // Add the item to the appropriate list based on its expiration status
      if (isExpired) {
        itemsexpired.add(item);
      } else {
        items.add(item);
      }
    });
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
        if (response.body.isNotEmpty) {
          saveBids(jsonDecode(response.body));
        }
      } else {
        print('Response Status Code: ${response.body}');
      }
    } catch (e, stackTrace) {
      print('Error: $e');
      print('Stack Trace: $stackTrace');
    }
  }

  void saveBids(List<dynamic> bid) {
    if (bid.isEmpty) {
      bids.value = [];
      return;
    }
    bids.value = bid.map((json) => Bids.fromJson(json)).toList();
    maxbid.value = bids[0].bidPrice.toDouble();
  }
}
