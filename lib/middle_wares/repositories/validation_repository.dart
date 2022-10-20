class ValidationRepository {
  bool isPassValid(String pass) {
    if (pass.length >= 8) {
      return true;
    }
    return false;
  }

  bool isUsernameValid(String username) {
    if (username.isNotEmpty) {
      return true;
    }
    return false;
  }

  bool isBirtDateValid(DateTime selectDate) {
    if (DateTime.now().difference(selectDate).inDays > 5843) {
      return true;
    }
    return false;
  }

  bool isNameValid(String LastName) {
    if (LastName.isNotEmpty) {
      return true;
    }
    return false;
  }

  bool isEmailValid(String email) {
    final regex = RegExp(
        r"[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z0-9][a-zA-Z0-9]*$");
    if (email.isEmpty || !regex.hasMatch(email)) {
      return false;
    }
    return true;
  }

  bool isNumberValid(String phoneNumber) {
    if (phoneNumber.isNotEmpty) {
      return true;
    }
    return false;
  }
}
