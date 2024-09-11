import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:task_ecom_app/core/error/failures.dart';
import 'package:task_ecom_app/core/usecases/usecase.dart';
import 'package:task_ecom_app/domain/usecases/cart/add_cart_item_usecase.dart';
import 'package:task_ecom_app/domain/usecases/cart/clear_cart_usecase.dart';
import 'package:task_ecom_app/domain/usecases/cart/get_cached_cart_usecase.dart';
import 'package:task_ecom_app/domain/usecases/cart/sync_cart_usecase.dart';
import 'package:task_ecom_app/presentation/blocs/cart/cart_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/constant_objects.dart';

class MockGetCachedCartUseCase extends Mock implements GetCachedCartUseCase {}

class MockAddCartUseCase extends Mock implements AddCartUseCase {}

class MockSyncCartUseCase extends Mock implements SyncCartUseCase {}

class MockClearCartUseCase extends Mock implements ClearCartUseCase {}
class MockRemoveCartUseCase extends Mock implements RemoveCartUseCase {}

void main() {
  group('CartBloc', () {
    late CartBloc cartBloc;
    late MockGetCachedCartUseCase mockGetCachedCartUseCase;
    late MockAddCartUseCase mockAddCartUseCase;
    late MockSyncCartUseCase mockSyncCartUseCase;
    late MockClearCartUseCase mockClearCartUseCase;
    late MockRemoveCartUseCase removeCartUseCase;

    setUp(() {
      mockGetCachedCartUseCase = MockGetCachedCartUseCase();
      mockAddCartUseCase = MockAddCartUseCase();
      mockSyncCartUseCase = MockSyncCartUseCase();
      mockClearCartUseCase = MockClearCartUseCase();
      removeCartUseCase = MockRemoveCartUseCase();

      cartBloc = CartBloc(
        mockGetCachedCartUseCase,
        mockAddCartUseCase,
        mockSyncCartUseCase,
        mockClearCartUseCase,
        removeCartUseCase,
      );
    });

    test('initial state should be CartInitial', () {
      expect(cartBloc.state, const CartInitial(cart: []));
    });

    blocTest<CartBloc, CartState>(
      'emits [CartLoading, CartLoaded, CartLoading, CartLoaded] when GetCart is added',
      build: () {
        when(() => mockGetCachedCartUseCase(NoParams()))
            .thenAnswer((_) async => const Right([]));
        when(() => mockSyncCartUseCase(NoParams()))
            .thenAnswer((_) async => const Right([]));
        return cartBloc;
      },
      act: (bloc) => bloc.add(const GetCart()),
      expect: () => [
        const CartLoading(cart: []),
        const CartLoaded(cart: []),
        const CartLoading(cart: []),
        const CartLoaded(cart: []),
      ],
    );

    blocTest<CartBloc, CartState>(
      'emits [CartLoading, CartLoaded] when AddProduct is added',
      build: () {
        when(() => mockAddCartUseCase(tCartItemModel))
            .thenAnswer((_) async => const Right(''));
        return cartBloc;
      },
      act: (bloc) => bloc.add(AddProduct(cartItem: tCartItemModel)),
      expect: () => [
        const CartLoading(cart: []),
        const CartLoaded(cart: []),
      ],
    );

    blocTest<CartBloc, CartState>(
      'emits [CartLoading, CartLoaded] when ClearCart is added',
      build: () {
        when(() => mockClearCartUseCase(NoParams()))
            .thenAnswer((_) async => const Right(true));
        return cartBloc;
      },
      act: (bloc) => bloc.add(const ClearCart()),
      expect: () => [
        const CartLoading(cart: []),
        const CartLoaded(cart: []),
      ],
    );

    blocTest<CartBloc, CartState>(
      'emits [CartLoading, CartError] when GetCart fails',
      build: () {
        when(() => mockGetCachedCartUseCase(NoParams()))
            .thenAnswer((_) async => Left(CacheFailure()));
        return cartBloc;
      },
      act: (bloc) => bloc.add(const GetCart()),
      expect: () => [
        const CartLoading(cart: []),
        CartError(cart: const [], failure: CacheFailure()),
      ],
    );

    blocTest<CartBloc, CartState>(
      'emits [CartLoading, CartError] when AddProduct fails',
      build: () {
        when(() => mockAddCartUseCase(tCartItemModel))
            .thenAnswer((_) async => Left(NetworkFailure()));
        return cartBloc;
      },
      act: (bloc) => bloc.add(AddProduct(cartItem: tCartItemModel)),
      expect: () => [
        const CartLoading(cart: []),
        CartError(cart: const [], failure: NetworkFailure()),
      ],
    );
  });
}
