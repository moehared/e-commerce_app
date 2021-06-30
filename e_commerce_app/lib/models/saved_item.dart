class UserWishListProductModel {
  final String productID;
  final String title;
  final String imageURL;
  final double price;

  UserWishListProductModel({
    required this.productID,
    required this.title,
    required this.imageURL,
    required this.price,
  });

  UserWishListProductModel.fromJson(Map<String, dynamic> jsonData)
      : this.title = jsonData['title'],
        this.imageURL = jsonData['imageURL'],
        this.productID = jsonData['id'],
        this.price = jsonData['price'];
  Map<String, dynamic> toJson() {
    return {
      'id': this.productID,
      'title': this.title,
      'imageURL': this.imageURL,
      'price': this.price,
    };
  }
}
