
class PhoneValidatsiyaWidget {
  static const List<String> _uzbekOperatorCodes = [
    '90', '91',
    '93', '94',
    '95', '99',
    '97', '98',
    '33',
    '88', '77',
  ];

  static String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Telefon raqami kiritilishi shart';
    }

    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.length < 9) {
      return 'Telefon raqam to\'liq emas';
    }

    if (digitsOnly.length > 12) {
      return 'Telefon raqam juda uzun';
    }

    if (digitsOnly.length >= 11) {
      final operatorCode = digitsOnly.substring(3, 5);
      if (!_uzbekOperatorCodes.contains(operatorCode)) {
        return 'Noto\'g\'ri operator kodi';
      }
    } else if (digitsOnly.length == 9) {
      final operatorCode = digitsOnly.substring(0, 2);
      if (!_uzbekOperatorCodes.contains(operatorCode)) {
        return 'Noto\'g\'ri operator kodi';
      }
    }

    return null;
  }

  static bool isValidUzbekPhone(String phone) {
    return validate(phone) == null;
  }

  static String formatPhone(String phone) {
    final digitsOnly = phone.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.length == 9) {
      return '+998$digitsOnly';
    } else if (digitsOnly.length == 12 && digitsOnly.startsWith('998')) {
      return '+$digitsOnly';
    }

    return phone;
  }
}