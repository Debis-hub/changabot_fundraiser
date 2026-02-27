class Fundraiser {
  final String id;
  final String title;
  final String description;
  final String targetAmount;

  Fundraiser({
    required this.id,
    required this.title,
    required this.description,
    required this.targetAmount,
  });

  factory Fundraiser.fromJson(Map<String, dynamic> json) {
    return Fundraiser(
      id: json['fundraiser_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      targetAmount: json['target_amount']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'target_amount': targetAmount,
    };
  }
}