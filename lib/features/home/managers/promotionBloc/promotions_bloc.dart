import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurantapp/data/repositories/promotions_repository.dart';
import 'package:restaurantapp/features/home/managers/promotionBloc/promotions_state.dart';
import '../../../../core/utils/status.dart';

part 'promotions_event.dart';

class PromotionsBloc extends Bloc<PromotionsEvent, PromotionsState> {
  final PromotionsRepository _promotionsRepository;

  PromotionsBloc({required PromotionsRepository promotionsRepository})
      : _promotionsRepository = promotionsRepository,
        super(PromotionsState.initial()) {
    on<PromotionsLoading>(_onPromotionsLoading);
  }

  Future<void> _onPromotionsLoading(
      PromotionsLoading event,
      Emitter<PromotionsState> emit,
      ) async {
    if (state.promotions.isEmpty) {
      emit(state.copyWith(status: Status.loading));
    }

    final result = await _promotionsRepository.postPromotions();

    result.fold(
          (error) {
        emit(
          state.copyWith(
            status: Status.error,
            errorMessage: error.toString(),
          ),
        );
      },
          (promotions) {
        emit(
          state.copyWith(
            status: Status.success,
            promotions: promotions,
          ),
        );
      },
    );
  }
}