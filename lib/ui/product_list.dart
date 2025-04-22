import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping_app/providers.dart';
import 'package:shoping_app/ui/cart_view.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<String> fruitNames = [
    "Apple", "Banana", "Mango", "Orange", "Pineapple",
    "Strawberry", "Grapes", "Watermelon", "Papaya", "Kiwi"
  ];

  List<String> fruitUnits = [
    "Kg", "Dozen", "Kg", "Kg", "Piece",
    "Box", "Kg", "Piece", "Kg", "Piece"
  ];

  List<double> fruitPrices = [
    120, 60, 150, 80, 50, 200, 90, 40, 45, 30
  ];

  List<String> fruitImages = [
    "https://upload.wikimedia.org/wikipedia/commons/1/15/Red_Apple.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/8/8a/Banana-Single.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/9/90/Hapus_Mango.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/c/c4/Orange-Fruit-Pieces.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/c/cb/Pineapple_and_cross_section.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/2/29/PerfectStrawberry.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/b/bb/Table_grapes_on_white.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/0/04/Watermelon.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/4/4b/Papaya.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/d/d3/Kiwi_aka.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Fruits',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        actions: [
          Consumer<CartProvider>(
            builder: (context, value, child) => GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const CartView()));
              },
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Icon(Icons.shopping_cart, size: 28),
                  ),
                  if (value.counter > 0)
                    CircleAvatar(
                      radius: 9,
                      backgroundColor: Colors.red,
                      child: Text(
                        value.counter.toString(),
                        style: const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: ListView.builder(
        itemCount: fruitNames.length,
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, index) {
          return Card(
            color: theme.cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: fruitImages[index],
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,


                          errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fruitNames[index],
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '₹${fruitPrices[index]} / ${fruitUnits[index]}',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Consumer<CartProvider>(
                    builder: (context, value, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Quantity Selector
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: colorScheme.outline),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    value.decrementQuantity(index);
                                  },
                                  icon: const Icon(Icons.remove),
                                  color: colorScheme.primary,
                                ),
                                Text(
                                  value.getQuantity(index).toString(),
                                  style: theme.textTheme.bodyLarge,
                                ),
                                IconButton(
                                  onPressed: () {
                                    value.incrementQuantity(index);
                                  },
                                  icon: const Icon(Icons.add),
                                  color: colorScheme.primary,
                                ),
                              ],
                            ),
                          ),
                          // Add to Cart Button
                          ElevatedButton.icon(
                            onPressed: () {
                              value.addToCart(
                                index,
                                index,
                                fruitNames[index],
                                fruitPrices[index],
                                value.getQuantity(index),
                                fruitPrices[index] * value.getQuantity(index),
                                fruitImages[index],
                                fruitUnits[index],
                              );
                              value.incrementCounter();
                              value.incrementTotalPrice(
                                  fruitPrices[index] * value.getQuantity(index));
                              value.updateQuantity(
                                  index, value.getQuantity(index));
                            },
                            icon: const Icon(Icons.add_shopping_cart),
                            label: const Text('Add'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
