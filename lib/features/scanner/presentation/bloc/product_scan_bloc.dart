import 'package:flutter_bloc/flutter_bloc.dart';

import 'product_scan_event.dart';
import 'product_scan_state.dart';
import '../../domain/repositories/product_scan_repository.dart';

class ProductScanBloc
    extends Bloc<ProductScanEvent, ProductScanState> {
  final ProductScanRepository repository;

  ProductScanBloc({
    required this.repository,
  }) : super(ProductScanInitial()) {
    on<ProductScanSubmitted>(
      _onProductScanSubmitted,
    );
  }

 Future<void> _onProductScanSubmitted(
  ProductScanSubmitted event,
  Emitter<ProductScanState> emit,
) async {
  emit(ProductScanLoading());

  try {
    final data = await repository.scanProduct(
      code: event.code,
      latitude: event.latitude,
      longitude: event.longitude,
      deviceUuid: event.deviceUuid,
      deviceInfo: event.deviceInfo,
      appVersion: event.appVersion,
    );

    emit(
      ProductScanSuccess(
        message: data['message'] ?? 'Product scan successful',

        isAwarded: data['isAwarded'] == true,

        rewardPoints:
            data['pointsAdded'] is num
        ? (data['pointsAdded'] as num).toInt()
        : null,

        campaignReward: data['campaignReward'],

        distanceFromTaggedLocation:
            data['distanceFromTaggedLocation'] is num
                ? data['distanceFromTaggedLocation'] as num
                : null,
      ),
    );
  } catch (e) {
    emit(
      ProductScanFailure(
        message: e.toString().replaceFirst(
          'Exception: ',
          '',
        ),
      ),
    );
  }
}
}