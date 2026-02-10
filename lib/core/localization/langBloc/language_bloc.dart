import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restaurantapp/core/network/language.dart';
import 'language_event.dart';
import 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc()
    : super(
        LanguageState(
          languageCode: 'uz',
          localization: AppLocalization('uz'),
        ),
      ) {
    on<LanguageLoaded>(_onLanguageLoaded);
    on<LanguageChanged>(_onLanguageChanged);
  }

  Future<void> _onLanguageLoaded(
    LanguageLoaded event,
    Emitter<LanguageState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final savedLang = prefs.getString('language') ?? 'uz';
    final localization = AppLocalization(savedLang);
    await localization.load();

    emit(
      state.copyWith(
        languageCode: savedLang,
        localization: localization,
      ),
    );
  }

  Future<void> _onLanguageChanged(
    LanguageChanged event,
    Emitter<LanguageState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
      ),
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', event.languageCode);

    final localization = AppLocalization(event.languageCode);
    await localization.load();

    emit(
      state.copyWith(
        languageCode: event.languageCode,
        localization: localization,
        isLoading: false,
      ),
    );
  }
}
