class Tenant {
  final String baseUrl;
  const Tenant(this.baseUrl);

  Map<String, dynamic> toJson() => {'baseUrl': baseUrl};

  factory Tenant.fromJson(Map<String, dynamic> json) => Tenant(json['baseUrl'] as String);

  @override
  String toString() => 'Tenant(baseUrl: $baseUrl)';
}
