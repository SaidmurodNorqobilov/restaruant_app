import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../../core/utils/status.dart';
import '../../../data/models/promotions_model.dart';
part 'promotions_state.freezed.dart';

@freezed
class PromotionsState with _$PromotionsState {
  const factory PromotionsState({
    required Status status,
    required List<PromotionsModel> promotions,
    String? errorMessage,
  }) = _PromotionsState;

  factory PromotionsState.initial () => const PromotionsState(
    status: Status.initial,
    promotions: [],
    errorMessage: null,
  );
}