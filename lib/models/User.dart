class User {
  String firstName;
  String lastName;
  String email;
  String identityToken;
  String accessToken;
  String refreshToken;
  String refreshTokenExpiration;

  User(
    this.firstName,
    this.lastName,
    this.email,
    this.identityToken,
    this.accessToken,
    this.refreshToken,
    this.refreshTokenExpiration
  );
}