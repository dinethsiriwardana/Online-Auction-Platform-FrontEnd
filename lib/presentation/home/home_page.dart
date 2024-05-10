import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:online_auction_platform/data/api/api.dart';

import 'dart:html' show window;
import 'package:http/http.dart' as http;
import 'package:online_auction_platform/data/controller/item_controller.dart';
import 'package:online_auction_platform/data/model/item_model.dart';
import 'package:online_auction_platform/presentation/bid/add_bid_screen.dart';
import 'package:online_auction_platform/presentation/item/single_item.dart';

import 'package:online_auction_platform/presentation/landing_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ItemController itemController = Get.put(ItemController());

  @override
  void initState() {
    itemController.fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.blue,
          title: const Text(
            "Home Page",
            textAlign: TextAlign.start,
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                onPressed: () {
                  window.localStorage.remove("token");
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (_) {
                      return const LandinPage();
                    },
                  ));
                },
                icon: const Icon(Icons.logout, size: 30, color: Colors.white),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () {
            _showDialog(context);
          },
          child: SizedBox(child: const Icon(Icons.add, color: Colors.white)),
        ),
        body: Center(
          //create item grid for each item
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Obx(
              () => itemController.items.isEmpty
                  ? const CircularProgressIndicator()
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: itemController.items.length,
                      itemBuilder: (context, index) {
                        final item = itemController.items[index];
                        return InkWell(
                          onTap: () {
                            _showBidDialog(context, item.id.toString());
                          },
                          child: Container(
                            //rounded corners
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              // background img
                              color: Colors.blue,
                              image: DecorationImage(
                                image: NetworkImage(
                                  'http://localhost:8080/apis/v1/file/image/${item.id}',
                                ),
                                fit: BoxFit.cover,
                                alignment: Alignment.topCenter,
                              ),
                            ),

                            // color: Colors.blue,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  color: Color.fromARGB(227, 44, 44, 44)
                                      .withOpacity(0.8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(item.name ?? "",
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.white)),
                                          Text(
                                            item.startPrice.toString(),
                                            style: const TextStyle(
                                                fontSize: 20,
                                                color: Colors.white),
                                          )
                                        ],
                                      ),
                                      ElevatedButton(
                                          onPressed: () {}, child: Text("Bid"))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ));
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: AddBidScreen(),
        );
      },
    );
  }

  void _showBidDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleItemScreen(
            id: id,
          ),
        );
      },
    );
  }
}
