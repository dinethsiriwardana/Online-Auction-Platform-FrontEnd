import 'dart:convert';
import 'dart:js_interop';

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
import 'package:online_auction_platform/utl/dat_time_formatter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:web_socket_channel/io.dart';

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
    itemController.maxBidsfetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 60.w,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Obx(() => itemController.items.isEmpty
                      ? SizedBox(
                          height: 100,
                          width: 100,
                          child: const CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          itemCount: itemController.items.length,
                          itemBuilder: (context, index) {
                            final item = itemController.items[index];
                            final maxbids = itemController.maxbids;

                            return InkWell(
                              onTap: () {
                                _showBidDialog(context, item.id.toString());
                              },
                              child: Container(
                                margin: const EdgeInsets.all(12),
                                padding: const EdgeInsets.all(10),
                                height: 200,
                                //rounded corners
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  //shadow
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 200,
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
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Container(
                                        //max width

                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: 20.w,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(item.name ?? "",
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 35,
                                                                  color: Colors
                                                                      .black)),
                                                      Text(
                                                          item.description ??
                                                              "",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 20,
                                                                  color: Colors
                                                                      .black)),
                                                    ],
                                                  ),
                                                  Container(
                                                    //red color box with rounded coners
                                                    decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    padding: EdgeInsets.all(10),
                                                    child:
                                                        TweenAnimationBuilder(
                                                      tween: Tween(
                                                          end: Duration.zero,
                                                          begin: DayTimeFormatter()
                                                              .timeToDuration(
                                                                  item.expiredAt ??
                                                                      "")),
                                                      duration: DayTimeFormatter()
                                                          .timeToDuration(
                                                              item.expiredAt ??
                                                                  ""),
                                                      builder:
                                                          (BuildContext context,
                                                              Duration value,
                                                              Widget? child) {
                                                        final hours = value
                                                            .inHours
                                                            .remainder(24);
                                                        final minutes = value
                                                            .inMinutes
                                                            .remainder(60);
                                                        final seconds = value
                                                            .inSeconds
                                                            .remainder(60);
                                                        if (value.inDays > 0) {
                                                          final days = value
                                                              .inDays
                                                              .remainder(365);
                                                          return countDown(
                                                              "${days.toString().padLeft(2, '0')} ${days == 1 ? "Day" : "Days"} Left");
                                                        }
                                                        return countDown(
                                                            '${hours.toString().padLeft(2, '0')} : ${minutes.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')} Left');
                                                      },
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  maxbids[item.id.toString()] !=
                                                          null
                                                      ? Text(
                                                          "\$${(maxbids[item.id.toString()]["bidPrice"]) ?? item.startPrice}.00 ",
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 50,
                                                                  color: Colors
                                                                      .black),
                                                        )
                                                      : SizedBox(),
                                                  Text(
                                                    "Start Price : \$${item.startPrice}.00",
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.black),
                                                  ),
                                                  Container(
                                                    height: 40,
                                                    width: 200,
                                                    child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                primary:
                                                                    Colors.blue,
                                                                shape:
                                                                    const RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          50.0),
                                                                ))),
                                                        onPressed: () {
                                                          _showBidDialog(
                                                              context,
                                                              item.id
                                                                  .toString());
                                                        },
                                                        child: Text(
                                                          "Bid Now",
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.white,
                                                          ),
                                                        )),
                                                  )
                                                ])
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )),
                ),
              ),
              SizedBox(
                width: 400,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Obx(() => itemController.itemsexpired.isEmpty
                      ? SizedBox(
                          height: 50,
                          width: 50,
                          child: const CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          itemCount: itemController.itemsexpired.length,
                          itemBuilder: (context, index) {
                            final item = itemController.itemsexpired[index];
                            final maxbids = itemController.maxbids;

                            return InkWell(
                              onTap: () {
                                _showBidDialog(context, item.id.toString());
                              },
                              child: Container(
                                margin: const EdgeInsets.all(12),
                                padding: const EdgeInsets.all(10),
                                height: 400,
                                //rounded corners
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  //shadow
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 400,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        // background img
                                        color: Colors.blue,
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            'http://localhost:8080/apis/v1/file/image/${item.id}',
                                          ),
                                          fit: BoxFit.cover,
                                          alignment: Alignment.center,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      //max width

                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                    //red color box with rounded coners
                                                    decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    padding: EdgeInsets.all(10),
                                                    child:
                                                        countDown("Expired")),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(item.name ?? "",
                                                        style: const TextStyle(
                                                            fontSize: 35,
                                                            color:
                                                                Colors.black)),
                                                  ],
                                                ),
                                                maxbids[item.id.toString()] !=
                                                        null
                                                    ? Text(
                                                        "\$${(maxbids[item.id.toString()]["bidPrice"]) ?? item.startPrice}.00 ",
                                                        style: const TextStyle(
                                                            fontSize: 40,
                                                            color:
                                                                Colors.black),
                                                      )
                                                    : Text(
                                                        "No Bids",
                                                        style: const TextStyle(
                                                            fontSize: 40,
                                                            color:
                                                                Colors.black),
                                                      ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )),
                ),
              ),
            ],
          ),
        ));
  }

  Text countDown(String text) => Text(
        text,
        style: TextStyle(color: Colors.white),
      );

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
