import 'package:equatable/equatable.dart';
import '../../models/product_model.dart';

class CartState extends Equatable {
  final List<ProductModel> products;

  const CartState({this.products = const []});

  CartState copyWith({List<ProductModel>? products}) {
    return CartState(products: products ?? this.products);
  }

  @override
  List<Object?> get props => [products];
}
