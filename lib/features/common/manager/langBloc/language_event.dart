abstract class LanguageEvent {}

class LanguageChanged extends LanguageEvent {
  final String languageCode;
  LanguageChanged(this.languageCode);
}

class LanguageLoaded extends LanguageEvent {}