// id
// bid_price
// bid_time
// item_id
// user_id
//create model for this/

class Bids {
  final int id;
  final double bidPrice;
  final String bidTime;
  final int itemId;
  final String userId;

  Bids({
    required this.id,
    required this.bidPrice,
    required this.bidTime,
    required this.itemId,
    required this.userId,
  });

  factory Bids.fromJson(Map<String, dynamic> json) {
    return Bids(
      id: json['id'],
      bidPrice: json['bidPrice'],
      bidTime: json['bidTime'],
      itemId: json['itemId'],
      userId: json['userId'],
    );
  }
}
