class TokensModel {
  final String access;
  final String refresh;

  TokensModel({required this.access, required this.refresh});

  factory TokensModel.fromJson(Map<String, dynamic> json) {
    return TokensModel(access: json['access'] ?? '', refresh: json['refresh'] ?? '');
  }
}
