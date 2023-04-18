class Userr {
  final String? email;

  Userr({
    this.email,
  });
  factory Userr.fromJson(jsonData) {
    return Userr(
      email: jsonData['email'],
    );
  }
}
