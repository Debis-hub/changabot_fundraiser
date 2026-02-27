import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/bank.dart';
import '../models/payment_method.dart';

class ApiService {
  static const String baseUrl = "https://changabot.online";

  // GET BANKS
  Future<List<Bank>> getBanks() async {
    final response = await http.get(Uri.parse('$baseUrl/banks'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['banks'] as List)
          .map((b) => Bank.fromJson(b))
          .toList();
    } else {
      throw Exception("Failed to load banks");
    }
  }

  // CREATE FUNDRAISER
  Future<String> createFundraiser(
      String title, String description, String targetAmount) async {

    final response = await http.post(
      Uri.parse('$baseUrl/fundraisers'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": title,
        "description": description,
        "target_amount": targetAmount,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['fundraiser_id'];
    } else {
      throw Exception("Failed to create fundraiser");
    }
  }

  // ADD PAYMENT METHOD
  Future<void> addPaymentMethod(
      String fundraiserId, PaymentMethod payment) async {

    final response = await http.post(
      Uri.parse('$baseUrl/fundraisers/$fundraiserId/payment-methods'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(payment.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Failed to add payment method");
    }
  }
}