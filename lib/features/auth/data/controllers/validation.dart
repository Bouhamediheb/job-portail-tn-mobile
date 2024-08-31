class Validation {
  Validation._();

  static bool isValidEmail(String email) {
    return RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email);
  }

  static bool isValidPassword(String password) {
    return RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
    ).hasMatch(password);
  }

  static bool isValidName(String name) {
    return RegExp('[a-zA-Z]').hasMatch(name);
  }

  static bool isEqualPassword(String val1, String val2) {
    return val1 == val2;
  }

  static bool isValidPhoneNumber(String phoneNumber) {
    return RegExp(r'^\d+$').hasMatch(phoneNumber);
  }

  static bool isValidFax(String fax) {
    return RegExp(r'^\d+$').hasMatch(fax);
  }

  static bool isValidWebsite(String website) {
    return RegExp(r'^www\.[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$').hasMatch(website);
  }
}

enum InputType { email, password, confirmPassword, name, text, phone, fax, website }
