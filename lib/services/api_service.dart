import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/payment_method.dart';
import '../models/bank.dart';

class ApiService {
  final String baseUrl = "https://changabot.online";

  // Add Payment Method (POST)
  Future<void> addPaymentMethod(String fundraiserId, PaymentMethod payment) async {
    final response = await http.post(
      Uri.parse('$baseUrl/fundraisers/$fundraiserId/payment-methods'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payment.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) return;

    final data = jsonDecode(response.body);

    // If payment exists, call update
    if (data['error'] == 'Payment method already exists') {
      await updatePaymentMethod(fundraiserId, payment);
    } else {
      throw Exception(data['message'] ?? 'Failed to add payment method');
    }
  }

  // Update Payment Method (PUT)
  Future<void> updatePaymentMethod(String fundraiserId, PaymentMethod payment) async {
    final response = await http.put(
      Uri.parse('$baseUrl/fundraisers/$fundraiserId/payment-methods'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payment.toJson()),
    );

    if (response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Failed to update payment method');
    }
  }

  // Fetch Banks
  Future<List<Bank>> getBanks() async {
    final response = await http.get(Uri.parse('$baseUrl/banks'));
    if (response.statusCode != 200) throw Exception("Failed to load banks");

    final data = jsonDecode(response.body);
    return (data['banks'] as List).map((b) => Bank.fromJson(b)).toList();
  }

  // Create Fundraiser
  Future<String> createFundraiser(String title, String description, String target) async {
    final res = await http.post(
      Uri.parse('$baseUrl/fundraisers'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "title": title,
        "description": description,
        "target_amount": target,
      }),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      final data = jsonDecode(res.body);
      throw Exception(data['message'] ?? "Failed to create fundraiser");
    }

    final data = jsonDecode(res.body);
    return data['fundraiser_id'];
  }
}