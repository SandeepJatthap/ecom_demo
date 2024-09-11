import 'package:flutter/material.dart';
import '../../domain/entities/cart/cart_item.dart';
import '../../domain/entities/product/product.dart';
import '../../presentation/views/authentication/signin_view.dart';
import '../../presentation/views/main/main_view.dart';
import '../../presentation/views/order_chekout/order_checkout_view.dart';
import '../../presentation/views/product/product_details_view.dart';
import '../error/exceptions.dart';

class AppRouter {
  //main menu
  static const String home = '/';

  //authentication
  static const String signIn = '/sign-in';

  //products
  static const String productDetails = '/product-details';

  //other
  static const String orderCheckout = '/order-checkout';
  static const String deliveryDetails = '/delivery-details';

  static Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const MainView());
      case signIn:
        return MaterialPageRoute(builder: (_) => const SignInView());
      case productDetails:
        Product product = routeSettings.arguments as Product;
        return MaterialPageRoute(
            builder: (_) => ProductDetailsView(product: product));
      case orderCheckout:
        List<CartItem> items = routeSettings.arguments as List<CartItem>;
        return MaterialPageRoute(
            builder: (_) => OrderCheckoutView(
                  items: items,
                ));
      default:
        throw const RouteException('Route not found!');
    }
  }
}
