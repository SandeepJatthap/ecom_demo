import 'package:dartz/dartz.dart';
import 'package:task_ecom_app/core/error/failures.dart';
import 'package:task_ecom_app/core/usecases/usecase.dart';
import 'package:task_ecom_app/domain/repositories/order_repository.dart';
import 'package:task_ecom_app/domain/usecases/order/get_cached_orders_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures/constant_objects.dart';

class MockOrderRepository extends Mock implements OrderRepository {}

void main() {
  late GetCachedOrdersUseCase usecase;
  late MockOrderRepository mockOrderRepository;

  setUp(() {
    mockOrderRepository = MockOrderRepository();
    usecase = GetCachedOrdersUseCase(mockOrderRepository);
  });

  test(
    'Should get order from the repository when Order Repository add data successfully',
        () async {
      /// Arrange
      when(() => mockOrderRepository.getCachedOrders())
          .thenAnswer((_) async => Right([tOrderDetailsModel]));

      /// Act
      final result = await usecase(NoParams());

      /// Assert
      result.fold(
            (failure) => fail('Test Fail!'),
            (cart) => expect(cart, [tOrderDetailsModel]),
      );
      verify(() => mockOrderRepository.getCachedOrders());
      verifyNoMoreInteractions(mockOrderRepository);
    },
  );

  test('should return a Failure from the repository', () async {
    /// Arrange
    final failure = NetworkFailure();
    when(() => mockOrderRepository.getCachedOrders())
        .thenAnswer((_) async => Left(failure));

    /// Act
    final result = await usecase(NoParams());

    /// Assert
    expect(result, Left(failure));
    verify(() => mockOrderRepository.getCachedOrders());
    verifyNoMoreInteractions(mockOrderRepository);
  });
}
