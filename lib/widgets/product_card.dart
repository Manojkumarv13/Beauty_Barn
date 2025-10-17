import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductCard extends StatefulWidget {
  final ProductModel product;
  final void Function(ProductModel product, bool isAdded)? onWishlistChanged;
  final void Function(ProductModel product)? onAddedToBag;

  const ProductCard({
    super.key,
    required this.product,
    this.onWishlistChanged,
    this.onAddedToBag,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isFavorite = false;
  bool isInBag = false;

  void _showCustomSnackBar(BuildContext context,
      {required String message, required IconData icon, required Color color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        elevation: 6,
        duration: const Duration(seconds: 1),
        backgroundColor: color.withOpacity(0.8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    final double? discount = (product.price != null && product.specialPrice != null)
        ? 100 - (product.specialPrice! / product.price! * 100)
        : null;

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🖼️ Image + discount + wishlist
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                child: Image.network(
                  "https://beautybarn.blr1.cdn.digitaloceanspaces.com/${product.thumbnail ?? ''}",
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                  const Icon(Icons.image, size: 80, color: Colors.grey),
                ),
              ),
              if (discount != null)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.yellow[700],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "SAVE ${discount.toStringAsFixed(0)}% OFF",
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              Positioned(
                top: 6,
                right: 6,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isFavorite = !isFavorite;
                    });

                    widget.onWishlistChanged?.call(product, isFavorite);

                    _showCustomSnackBar(
                      context,
                      message: isFavorite
                          ? 'Added to wishlist ❤️'
                          : 'Removed from wishlist',
                      icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors. pink: Colors.grey.shade700,
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey.shade100,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(6),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, anim) =>
                          ScaleTransition(scale: anim, child: child),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        key: ValueKey(isFavorite),
                        size: 18,
                        color: isFavorite ? Colors.red : Colors.black54,
                      ),
                    ),
                  ),
                ),
              ),

              // Positioned(
              //   top: 6,
              //   right: 6,
              //   child: GestureDetector(
              //     onTap: () {
              //       setState(() {
              //         isFavorite = !isFavorite;
              //       });
              //
              //       widget.onWishlistChanged?.call(product, isFavorite);
              //
              //       _showCustomSnackBar(
              //         context,
              //         message: isFavorite
              //             ? 'Added to wishlist ❤️'
              //             : 'Removed from wishlist',
              //         icon: isFavorite
              //             ? Icons.favorite
              //             : Icons.favorite_border,
              //         color: isFavorite ? Colors.pink : Colors.grey.shade700,
              //       );
              //     },
              //     child: AnimatedContainer(
              //       duration: const Duration(milliseconds: 250),
              //       curve: Curves.easeInOut,
              //       child: CircleAvatar(
              //         radius: 14,
              //         backgroundColor: Colors.white,
              //         child: AnimatedSwitcher(
              //           duration: const Duration(milliseconds: 300),
              //           transitionBuilder: (child, anim) =>
              //               ScaleTransition(scale: anim, child: child),
              //           child: Icon(
              //             isFavorite ? Icons.favorite : Icons.favorite_border,
              //             key: ValueKey(isFavorite),
              //             size: 18,
              //             color: isFavorite ? Colors.red : Colors.black54,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),

          const SizedBox(height: 6),

          // 🏷️ Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              product.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),

          // ⭐ Rating Row
          if (product.averageRating != null && product.averageRating! > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < product.averageRating!.floor()
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber,
                        size: 14,
                      );
                    }),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    product.averageRating!.toStringAsFixed(1),
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),

          const Spacer(),

          // 💰 Price
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Text(
                  "Rs. ${product.specialPrice?.toStringAsFixed(0) ?? product.price?.toStringAsFixed(0) ?? ''}",
                  style: const TextStyle(
                      color: Colors.pink,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                const SizedBox(width: 6),
                if (product.specialPrice != null)
                  Text(
                    "Rs. ${product.price?.toStringAsFixed(0) ?? ''}",
                    style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                        fontSize: 12),
                  ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              width: double.infinity,
              height: 36,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.pink),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  setState(() {
                    isInBag = !isInBag;
                  });

                  widget.onAddedToBag?.call(product);

                  _showCustomSnackBar(
                    context,
                    message: isInBag
                        ? 'Added to bag 🛍️'
                        : 'Removed from bag',
                    icon: isInBag
                        ? Icons.shopping_bag
                        : Icons.remove_shopping_cart,
                    color: isInBag ? Colors.pink : Colors.grey.shade700,
                  );
                },
                child: Text(
                  isInBag ? "In Bag" : "Add to Bag",
                  style: TextStyle(
                    color: isInBag ? Colors.pink : Colors.pink,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
