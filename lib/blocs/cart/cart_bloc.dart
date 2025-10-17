import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';
import '../../models/product_model.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
  }

  void _onAddToCart(AddToCart event, Emitter<CartState> emit) {
    final updatedProducts = List<ProductModel>.from(state.products)
      ..add(event.product);
    emit(state.copyWith(products: updatedProducts));
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) {
    final updatedProducts = List<ProductModel>.from(state.products)
      ..removeWhere((p) => p.id == event.product.id);
    emit(state.copyWith(products: updatedProducts));
  }
}
