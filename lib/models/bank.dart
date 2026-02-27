class Bank {
  final String alias;
  final String name;

  Bank({required this.alias, required this.name});

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      alias: json['alias'],
      name: json['name'],
    );
  }
}