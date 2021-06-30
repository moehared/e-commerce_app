class CartItem {
  final String title;
  final String size;
  final String color;
  final String image;
  final int quantity;
  final double price;
  final String id;
  CartItem({
    required this.id,
    required this.title,
    required this.size,
    required this.price,
    required this.color,
    required this.image,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': this.title,
      'size': this.size,
      'color': this.color,
      'image': this.image,
      'quantity': this.quantity,
      'price': this.price,
      'id': this.id,
    };
  }

  CartItem.fromJson(Map<String, dynamic> jsonData)
      : this.id = jsonData['id'],
        this.title = jsonData['title'],
        this.price = jsonData['price'],
        this.color = jsonData['color'],
        this.size = jsonData['size'],
        this.image = jsonData['image'],
        this.quantity = jsonData['quantity'];
}
