class CurrencyModel {
  final int id;
  final String code;
  final String title;
  final bool isDefault;
  final double exchange;
  final String? icon = null;

  CurrencyModel({
    required this.id,
    required this.code,
    required this.title,
    required this.isDefault,
    required this.exchange,
  });

  @override
  bool operator ==(Object other) => other is CurrencyModel && id == other.id;

  @override
  int get hashCode => id.hashCode;

  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    return CurrencyModel(
      id: json['id'] ?? 0,
      code: json['code'] ?? 'Unknown',
      title: "${json['code'] ?? 'Unknown'} - ${json['title'] ?? 'Unknown'}",
      isDefault: json['isDefault'] ?? false,
      exchange: double.tryParse(json['exchange'].toString()) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'title': title,
      'isDefault': isDefault,
      'exchange': exchange,
    };
  }
}
