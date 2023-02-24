// @dart=2.9

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tasks_app/core/network/network_info.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker{}

void main() {
  NetworkInfoImplementation networkInfo;
  MockDataConnectionChecker mockDataConnectionChecker;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfo = NetworkInfoImplementation(mockDataConnectionChecker);
  });
  
  group('isConnected property', () {
    test('Should forward the call to DataConnectionChecker.hasConnection', () async {
      final matcher = Future.value(true);

      when(mockDataConnectionChecker.hasConnection).thenAnswer((realInvocation) => matcher);

      final actual = networkInfo.isConnected;

      verify(mockDataConnectionChecker.hasConnection);
      expect(actual, matcher);
    });
  });
}