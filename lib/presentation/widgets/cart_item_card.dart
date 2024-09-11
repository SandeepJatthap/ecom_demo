import 'package:cached_network_image/cached_network_image.dart';
import 'package:task_ecom_app/domain/entities/cart/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/router/app_router.dart';

class CartItemCard extends StatelessWidget {
  final CartItem? cartItem;
  final Function? onFavoriteToggle;
  final Function? onClick;
  final Function? onRemoveClick;
  final Function()? onLongClick;
  final bool isSelected;

  const CartItemCard({
    super.key,
    this.cartItem,
    this.onFavoriteToggle,
    this.onClick,
    this.onLongClick,
    this.onRemoveClick,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return cartItem == null
        ? Shimmer.fromColors(
            highlightColor: Colors.white,
            baseColor: Colors.grey.shade100,
            child: buildBody(context),
          )
        : buildBody(context);
  }

  Widget buildBody(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (cartItem != null) {
          Navigator.of(context).pushNamed(AppRouter.productDetails,
              arguments: cartItem!.product);
        }
      },
      onLongPress: onLongClick,
      child: SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            Card(
              margin: const EdgeInsets.only(top: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade50,
                          blurRadius: 1,
                        ),
                      ],
                    ),
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: Card(
                        color: Colors.white,
                        elevation: 2,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: cartItem == null
                            ? Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Container(
                                  color: Colors.grey.shade300,
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: CachedNetworkImage(
                                  imageUrl: cartItem!.product.image!,
                                  placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      const Center(child: Icon(Icons.error)),
                                ),
                              ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: const EdgeInsets.fromLTRB(4, 8, 30, 0),
                            child: SizedBox(
                              // height: 18,
                              child: cartItem == null
                                  ? Container(
                                      width: 150,
                                      height: 18,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    )
                                  : SizedBox(
                                      child: Text(
                                        cartItem!.product.title ?? "",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                            )),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(4, 4, 30, 0),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 18,
                                child: cartItem == null
                                    ? Container(
                                        width: 100,
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      )
                                    : Text(
                                        r'$' +
                                            cartItem!.product.price.toString(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            if (onRemoveClick != null)
              Positioned(
                top: 1,
                right: 0,
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        onRemoveClick!();
                      },
                      icon: Icon(
                        Icons.clear,
                        color: Colors.redAccent,
                      )),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
