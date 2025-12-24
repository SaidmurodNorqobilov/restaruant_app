import 'package:restaurantapp/core/utils/language.dart';

class LanguageState {
  final String languageCode;
  final AppLocalization localization;
  final bool isLoading;

  LanguageState({
    required this.languageCode,
    required this.localization,
    this.isLoading = false,
  });

  LanguageState copyWith({
    String? languageCode,
    AppLocalization? localization,
    bool? isLoading,
  }) {
    return LanguageState(
      languageCode: languageCode ?? this.languageCode,
      localization: localization ?? this.localization,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}