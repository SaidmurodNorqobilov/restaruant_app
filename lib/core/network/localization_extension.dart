import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurantapp/core/network/language.dart';
import '../localization/langBloc/language_bloc.dart';

extension LocalizationExtension on BuildContext {
  AppLocalization get localization {
    return watch<LanguageBloc>().state.localization;
  }

  String translate(String key) {
    return watch<LanguageBloc>().state.localization.translate(key);
  }
}