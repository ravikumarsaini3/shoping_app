import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping_app/providers.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  void initState() {
    super.initState();
    Provider.of<CartProvider>(context, listen: false).getListData();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          const SizedBox(width: 10),
          Switch.adaptive(value: cartProvider.themeMode==ThemeMode.dark, onChanged: (value) {
            cartProvider.toggleTheme(value);
          },), const SizedBox(width: 10),
          Selector<CartProvider, int>(
            selector: (_, provider) => provider.counter,
            builder: (_, counter, __) => Badge(
              label: Text(counter.toString()),
              child: const Icon(Icons.shopping_cart),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Consumer<CartProvider>(
              builder: (context, value, _) {
                if (value.getList.isEmpty) {
                  value.clearCart();

                  return const Center(
                    child: Text(
                      'Cart is Empty. Add Some Products!',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: value.getList.length,
                  itemBuilder: (context, index) {
                    final item = value.getList[index];
                    return CartItemTile(item: item);
                  },
                );
              },
            ),
          ),
          Selector<CartProvider, double>(
            selector: (_, provider) => provider.totalPrice,
            builder: (context, totalPrice, _) {
              if (totalPrice > 0.0) {
                return Expanded(
                  flex: 1,
                  child: Container(
                    width: 340,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      'Total: ₹${totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}

class CartItemTile extends StatelessWidget {
  final dynamic item; // Replace `dynamic` with your actual model type if available

  const CartItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: Column(
        children: [
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CachedNetworkImage(
                imageUrl: item.productImage ?? '',
                width: 70,
                height: 60,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, progress) =>
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const CircularProgressIndicator(),
                          if (progress.totalSize != null)
                            Text(
                              "${((progress.downloaded / progress.totalSize!) * 100).toStringAsFixed(0)}%",
                              style: const TextStyle(fontSize: 12),
                            ),
                        ],
                      ),
                    ),
                errorWidget: (context, error, stackTrace) =>
                const Icon(Icons.broken_image),
              ),
            ),
            title: Text(
              item.productName ?? '',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              "₹${item.productPrice} per ${item.productUnit}",
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Qty: ${item.quantity}',
                  style: const TextStyle(fontSize: 15),
                ),
                Text(
                  'Price: ₹${item.productBasePrice}',
                  style: const TextStyle(fontSize: 15),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    cartProvider.deleteToCart(item.id!);
                    cartProvider.decrementCounter();
                    cartProvider.clearQuantity();
                    cartProvider.decrementTotalPrice(item.productBasePrice);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
