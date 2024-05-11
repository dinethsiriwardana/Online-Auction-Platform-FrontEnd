import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'dart:html' show window;

import 'package:online_auction_platform/data/api/api.dart';
import 'package:online_auction_platform/data/controller/item_controller.dart';
import 'package:online_auction_platform/utl/dat_time_formatter.dart';

class SingleItemScreen extends StatefulWidget {
  final String id;

  const SingleItemScreen({super.key, required this.id});

  @override
  State<SingleItemScreen> createState() => _SingleItemScreenState();
}

class _SingleItemScreenState extends State<SingleItemScreen> {
  ItemController itemController = Get.put(ItemController());
  final TextEditingController _addBidController = TextEditingController();

  String get _addBid => _addBidController.text;
  double get maxpaceBid => itemController.maxbid.value;

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  void dispose() {
    _addBidController.dispose();
    super.dispose();
  }

  void fetchData() async {
    print('Fetching Data');
    try {
      final response = await http.get(
        Uri.parse("${Api.item}/${widget.id}"),
      );
      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          return;
        }
        itemController.showSingleItem(jsonDecode(response.body));
        itemController.fetchBidData();
      } else {
        print('Response Status Code: ${response.body}');
      }
    } catch (e, stackTrace) {
      print('Error fetchData: $e');
      print('Stack Trace: $stackTrace');
    }
  }

  Future<void> _submit() async {
    if (_addBid.isEmpty) {
      itemController.itemSubmitError('Add A Bid');
      return;
    }
    if (double.parse(_addBid) <= itemController.maxbid.value) {
      itemController.itemSubmitError('Add A Bid Greater Than $maxpaceBid');
      return;
    }
    if (window.localStorage["token"] == null) {
      return;
    }
    try {
      final response = await http.post(
        Uri.parse(Api.bid),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          "itemId": itemController.item.value.id.toString(),
          "userId": window.localStorage["token"] ?? "",
          "bidPrice": _addBid,
          "bidTime": DayTimeFormatter().formatLocalTime(DateTime.now())
        }),
      );
      itemController.itemsubmiterr('');
      _addBidController.text = '';
      itemController.fetchBidData();
    } catch (e) {
      print(e.toString());
      itemController.itemSubmitError(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: 800,
        child: Obx(
          () => itemController.item.value.id == null
              ? SizedBox()
              : Column(
                  children: [
                    SizedBox(
                      width: 800,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ItemImg(),
                          SizedBox(
                            height: 400,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [ItemDetails(), AddBidButton()],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: 800,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Text(
                                "Reason Bids ${itemController.bids.isEmpty ? ' - No Bids' : ''}",
                                style: TextStyle(fontSize: 30),
                              ),

                              //foreach for list of bids
                              itemController.bids.isEmpty
                                  ? const SizedBox()
                                  : Column(
                                      children: itemController.bids
                                          .map((bid) => resonBid(
                                              bid.userId.toString(),
                                              bid.bidPrice,
                                              bid.bidTime))
                                          .take(5)
                                          .toList(),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }

  Column AddBidButton() {
    return Column(
      children: [
        Obx(() => itemController.itemsubmiterr.value == ''
            ? const SizedBox()
            : Column(
                children: [
                  Text(
                    itemController.itemsubmiterr.value,
                    style: TextStyle(color: Colors.red),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                ],
              )),
        Row(
          children: [
            emailInput(),
            SizedBox(
              width: 10,
            ),
            SizedBox(
              height: 55,
              width: 55,
              child: IconButton(
                  onPressed: () {
                    _submit();
                  },
                  icon: const Icon(Icons.add),
                  color: Colors.white,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.blue,
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                    ),
                  )),
            )
          ],
        ),
      ],
    );
  }

  Column ItemImg() {
    return Column(
      children: [
        SizedBox(
          // height: 380,
          width: 380,
          child: Image.network(
            'http://localhost:8080/apis/v1/file/image/${itemController.item.value.id}',
          ),
        ),
      ],
    );
  }

  Column ItemDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          itemController.item.value.name!,
          style: TextStyle(fontSize: 30),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "By",
          style: TextStyle(fontSize: 20),
        ),
        Text(
          itemController.item.value.addedBy!,
          style: TextStyle(fontSize: 30),
        ),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 400,
          child: Text(
            itemController.item.value.description!,
            style: TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }

  SizedBox resonBid(String name, double price, String time) {
    return SizedBox(
      width: 800,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: TextStyle(fontSize: 20)),
          Text(time.toString(), style: TextStyle(fontSize: 20)),
          Text(price.toString(), style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }

  SizedBox emailInput() {
    return SizedBox(
      width: 250.0,
      height: 55.0,
      child: TextField(
        controller: _addBidController,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        decoration: const InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue,
              width: 2.0,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 216, 122, 0),
              width: 2.0,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          hintText: 'Add A Bid',
          labelText: 'Add a Bid',
          hintStyle: TextStyle(
            fontSize: 15,
          ),
          labelStyle: TextStyle(
            fontSize: 15,
          ),
        ),
        onChanged: (paceBid) => _updateState(paceBid),
      ),
    );
  }

  _updateState(paceBid) {
    setState(() {});
  }
}
