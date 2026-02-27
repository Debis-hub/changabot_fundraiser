class Bank {
  final String name;
  final String alias;

  Bank({
    required this.name,
    required this.alias,
  });

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      name: json['name'] ?? '',
      alias: json['alias'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "alias": alias,
    };
  }
}