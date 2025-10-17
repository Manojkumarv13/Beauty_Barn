import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../blocs/cart/cart_event.dart';
import '../blocs/cart/cart_state.dart';
import '../models/product_model.dart';
import '../blocs/cart/cart_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final price = product.specialPrice ?? product.price ?? 0;

    // Ensure main image is first in carousel
    final List<String> carouselImages = [
      if (product.thumbnail != null && product.thumbnail!.isNotEmpty)
        "https://beautybarn.blr1.cdn.digitaloceanspaces.com/${product.thumbnail}"
      else if (product.images.isNotEmpty)
        "https://beautybarn.blr1.cdn.digitaloceanspaces.com/${product.images.first}"
      else
        "https://beautybarn.blr1.cdn.digitaloceanspaces.com/default_image.png", // fallback
      // Add the rest of images
      ...product.images
          .where((img) => img != product.thumbnail)
          .map((img) => "https://beautybarn.blr1.cdn.digitaloceanspaces.com/$img")
          .toList(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.4,
        title: Text(
          product.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼️ Product Image Carousel
            _buildImageCarousel(carouselImages),

            // 🏷️ Product Info Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (product.subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        product.subtitle!,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: Colors.grey[700]),
                      ),
                    ),

                  const SizedBox(height: 8),

                  // ⭐ Rating + Reviews
                  Row(
                    children: [
                      RatingBarIndicator(
                        rating: product.averageRating ?? 4.5,
                        itemCount: 5,
                        itemSize: 20,
                        unratedColor: Colors.grey[300],
                        itemBuilder: (context, index) =>
                        const Icon(Icons.star, color: Colors.amber),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "(${product.reviewCount ?? 58} reviews)",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // 💰 Price
                  Row(
                    children: [
                      Text(
                        "₹${price.toStringAsFixed(0)}",
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      if (product.specialPrice != null &&
                          product.price != null &&
                          product.specialPrice! < product.price!)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "₹${product.price!.toStringAsFixed(0)}",
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  if (product.description != null && product.description!.isNotEmpty)
                    Html(
                      data: product.description!,
                      style: {
                        "body": Style(
                          fontSize: FontSize(16),
                          color: Colors.black87,
                          lineHeight: LineHeight(1.5),
                        ),
                        "p": Style(
                          margin: Margins.zero, // ✅ Use Margins.zero instead of EdgeInsets.zero
                        ),
                        "strong": Style(fontWeight: FontWeight.bold),
                        "em": Style(fontStyle: FontStyle.italic),
                      },
                    ),

                  const SizedBox(height: 30),

                  // 🏷️ Tags / Categories
                  if (product.categories.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: product.categories
                          .map((cat) => Chip(
                        label: Text(cat),
                        backgroundColor: Colors.grey.shade100,
                      ))
                          .toList(),
                    ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),

      // 🛒 Bottom Add to Cart Section
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              final isInCart = state.products.any((e) => e.id == product.id);

              return ElevatedButton(
                onPressed: () {
                  if (isInCart) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Already in cart')),
                    );
                  } else {
                    context.read<CartBloc>().add(AddToCart(product));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Added to cart')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: const Size.fromHeight(55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isInCart ? "Added to Cart" : "Add to Cart",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // 🖼️ Product image carousel
  Widget _buildImageCarousel(List<String> images) {
    if (images.isEmpty) {
      return Container(
        height: 340,
        color: Colors.grey[100],
        child: const Center(child: Icon(Icons.image_not_supported, size: 80)),
      );
    }

    return SizedBox(
      height: 340,
      child: PageView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Hero(
            tag: 'product_${images[index]}',
            child: Image.network(
              images[index],
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.grey[200],
                child: const Icon(Icons.broken_image, size: 80),
              ),
            ),
          );
        },
      ),
    );
  }
}
