import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      {"title": "What's New", "icon": Icons.fiber_new},
      {"title": "Skin", "icon": Icons.spa},
      {"title": "Makeup", "icon": Icons.brush},
      {"title": "Hair", "icon": Icons.content_cut},
      {"title": "Men’s Skincare", "icon": Icons.male},
      {"title": "Brands", "icon": Icons.store},
      {"title": "Bestsellers", "icon": Icons.star},
      {"title": "Travel Kits & Minis", "icon": Icons.card_travel},
      {"title": "Bundles", "icon": Icons.shopping_basket},
      {"title": "Clearance", "icon": Icons.remove_circle_outline},
      {"title": "Sale", "icon": Icons.local_offer},
      {"title": "Offers", "icon": Icons.discount},
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          "Menu",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: menuItems.length,
        separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.black12),
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return InkWell(
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Tapped on ${item["title"]}'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.pinkAccent,
                ),
              );
            },
            borderRadius: BorderRadius.circular(10),
            splashColor: Colors.pinkAccent.withOpacity(0.2),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
              child: Row(
                children: [
                  Icon(item["icon"] as IconData, color: Colors.pinkAccent),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      item["title"] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black38),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
