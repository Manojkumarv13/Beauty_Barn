class ProductModel {
  final int id;
  final String title;
  final String? subtitle;
  final String? description;
  final String? handle;
  final String? thumbnail;

  final double? price;
  final double? specialPrice;
  final double? priceStart;
  final double? priceEnd;
  final double? averageRating;

  final int? reviewCount;
  final int? ordersCount;
  final int? stock;
  final int? brandId;

  final List<String> images;
  final List<String> categories;
  final List<String> tags;
  final List<VariantModel> variants;

  ProductModel({
    required this.id,
    required this.title,
    this.subtitle,
    this.description,
    this.handle,
    this.thumbnail,
    this.price,
    this.specialPrice,
    this.priceStart,
    this.priceEnd,
    this.averageRating,
    this.reviewCount,
    this.ordersCount,
    this.stock,
    this.brandId,
    this.images = const [],
    this.categories = const [],
    this.tags = const [],
    this.variants = const [],
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Extract variants
    final List<dynamic> variantList = json['variants'] is List ? json['variants'] : [];
    final VariantModel? firstVariant = variantList.isNotEmpty
        ? VariantModel.fromJson(variantList.first as Map<String, dynamic>)
        : null;

    // Determine main thumbnail
    String? mainImage;
    if (firstVariant?.thumbnail != null && firstVariant!.thumbnail!.isNotEmpty) {
      mainImage = firstVariant.thumbnail;
    } else if (json['thumbnail'] != null && json['thumbnail'].toString().isNotEmpty) {
      mainImage = json['thumbnail'].toString();
    } else if (json['productImages'] is List && (json['productImages'] as List).isNotEmpty) {
      final firstImg = (json['productImages'] as List).first;
      if (firstImg is Map && firstImg['image'] != null) {
        mainImage = firstImg['image'].toString();
      }
    }

    // Parse all images
    final List<String> images = (json['productImages'] is List)
        ? (json['productImages'] as List)
        .map((img) => img is Map && img['image'] != null ? img['image'].toString() : '')
        .where((url) => url.isNotEmpty)
        .toList()
        : [];

    // Parse categories
    final List<String> categories = (json['productCategories'] is List)
        ? (json['productCategories'] as List)
        .map((cat) => cat is Map
        ? (cat['category'] is Map ? cat['category']!['name']?.toString() ?? '' : '')
        : '')
        .where((name) => name.isNotEmpty)
        .toList()
        : [];

    // Parse tags
    final List<String> tags = (json['tags'] is List)
        ? (json['tags'] as List)
        .map((t) => t is Map
        ? (t['tag'] is Map ? t['tag']!['title']?.toString() ?? '' : '')
        : '')
        .where((title) => title.isNotEmpty)
        .toList()
        : [];

    // Parse variants list
    final List<VariantModel> variants = variantList
        .whereType<Map<String, dynamic>>()
        .map((v) => VariantModel.fromJson(v))
        .toList();

    // Price logic
    final double? price = firstVariant?.price ??
        (json['priceStart'] != null ? (json['priceStart'] as num).toDouble() : null);
    final double? specialPrice = firstVariant?.specialPrice;

    return ProductModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id'].toString()) ?? 0,
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString(),
      description: json['description']?.toString(),
      handle: json['handle']?.toString(),
      thumbnail: mainImage,
      price: price,
      specialPrice: specialPrice,
      priceStart: json['priceStart'] != null ? (json['priceStart'] as num).toDouble() : null,
      priceEnd: json['priceEnd'] != null ? (json['priceEnd'] as num).toDouble() : null,
      averageRating: json['averageRating'] != null ? (json['averageRating'] as num).toDouble() : 0.0,
      reviewCount: json['reviewCount'] is int ? json['reviewCount'] as int : 0,
      ordersCount: json['ordersCount'] is int ? json['ordersCount'] as int : null,
      stock: json['stock'] is int ? json['stock'] as int : null,
      brandId: json['brandId'] is int ? json['brandId'] as int : null,
      images: images,
      categories: categories,
      tags: tags,
      variants: variants,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'subtitle': subtitle,
    'description': description,
    'handle': handle,
    'thumbnail': thumbnail,
    'price': price,
    'specialPrice': specialPrice,
    'priceStart': priceStart,
    'priceEnd': priceEnd,
    'averageRating': averageRating,
    'reviewCount': reviewCount,
    'ordersCount': ordersCount,
    'stock': stock,
    'brandId': brandId,
    'images': images,
    'categories': categories,
    'tags': tags,
    'variants': variants.map((v) => v.toJson()).toList(),
  };
}

class VariantModel {
  final int? id;
  final String? title;
  final String? sku;
  final double? price;
  final double? specialPrice;
  final String? thumbnail;
  final bool? inStock;

  VariantModel({
    this.id,
    this.title,
    this.sku,
    this.price,
    this.specialPrice,
    this.thumbnail,
    this.inStock,
  });

  factory VariantModel.fromJson(Map<String, dynamic> json) {
    return VariantModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id'].toString()),
      title: json['title']?.toString(),
      sku: json['sku']?.toString(),
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      specialPrice: json['specialPrice'] != null ? (json['specialPrice'] as num).toDouble() : null,
      thumbnail: json['thumbnail']?.toString(),
      inStock: json['inStock'] is bool ? json['inStock'] as bool : true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'sku': sku,
    'price': price,
    'specialPrice': specialPrice,
    'thumbnail': thumbnail,
    'inStock': inStock,
  };
}
