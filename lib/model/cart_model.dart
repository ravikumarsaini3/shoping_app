class CartModel {
  final int? id;
  final int? productId;
  final String? productName;
  final double? productPrice;
  final int? quantity;
  final double? productBasePrice;
  final String? productImage;
  final String? productUnit;

  CartModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.quantity,
    required this.productBasePrice,
    required this.productImage,
    required this.productUnit,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'productPrice': productPrice,
      'quantity': quantity,
      'productBasePrice': productBasePrice,
      'productImage': productImage,
      'productUnit': productUnit
    };
  }

  factory CartModel.fromMap(Map<String, dynamic>res){
    return CartModel(
        id: res['id'],
        productId: res['productId'],
        productName: res['productName'],
        productPrice: res['productPrice'],
        quantity: res['quantity'],
        productBasePrice: res['productBasePrice'],
        productImage: res['productImage'],
        productUnit: res['productUnit'],);
  }
}
