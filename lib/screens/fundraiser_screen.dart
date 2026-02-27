import 'package:flutter/material.dart';
import '../models/bank.dart';
import '../models/payment_method.dart';
import '../services/api_service.dart';

class FundraiserScreen extends StatefulWidget {
  const FundraiserScreen({super.key});

  @override
  State<FundraiserScreen> createState() => _FundraiserScreenState();
}

class _FundraiserScreenState extends State<FundraiserScreen> {

  final ApiService api = ApiService();

  List<Bank> banks = [];
  String? fundraiserId;
  String selectedType = "bank";

  final titleController = TextEditingController();
  final descController = TextEditingController();
  final targetController = TextEditingController();
  final accountController = TextEditingController();
  final paybillController = TextEditingController();
  final paybillAccountController = TextEditingController();
  final tillController = TextEditingController();

  String? selectedBankAlias;

  @override
  void initState() {
    super.initState();
    loadBanks();
  }

  void loadBanks() async {
    final bankList = await api.getBanks();
    setState(() => banks = bankList);
  }

  void createFundraiser() async {
    final id = await api.createFundraiser(
      titleController.text,
      descController.text,
      targetController.text,
    );

    setState(() => fundraiserId = id);

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Fundraiser Created")));
  }

  void addPayment() async {
    if (fundraiserId == null) return;

    PaymentMethod payment;

    if (selectedType == "bank") {
  payment = PaymentMethod(
    type: PaymentType.bank,   // ✅ FIXED
    bankAlias: selectedBankAlias,
    account: accountController.text,
  );
} else if (selectedType == "paybill") {
  payment = PaymentMethod(
    type: PaymentType.paybill,   // ✅ FIXED
    paybill: paybillController.text,
    account: paybillAccountController.text,
  );
} else {
  payment = PaymentMethod(
    type: PaymentType.buygoods,   // ✅ FIXED
    tillNumber: tillController.text,
  );
}

    await api.addPaymentMethod(fundraiserId!, payment);

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Payment Added")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ChangaBot")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const Text("Create Fundraiser",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            TextField(controller: titleController, decoration: const InputDecoration(labelText: "Title")),
            TextField(controller: descController, decoration: const InputDecoration(labelText: "Description")),
            TextField(controller: targetController, decoration: const InputDecoration(labelText: "Target Amount")),

            ElevatedButton(
              onPressed: createFundraiser,
              child: const Text("Create Fundraiser"),
            ),

            const SizedBox(height: 30),

            const Text("Add Payment Method",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            Row(
              children: [
                Expanded(child: ElevatedButton(onPressed: () => setState(() => selectedType="bank"), child: const Text("Bank"))),
                Expanded(child: ElevatedButton(onPressed: () => setState(() => selectedType="paybill"), child: const Text("Paybill"))),
                Expanded(child: ElevatedButton(onPressed: () => setState(() => selectedType="buygoods"), child: const Text("Buy Goods"))),
              ],
            ),

            if (selectedType == "bank") ...[
              DropdownButtonFormField(
                items: banks.map((b) =>
                  DropdownMenuItem(
                    value: b.alias,
                    child: Text(b.name),
                  )).toList(),
                onChanged: (val) => selectedBankAlias = val,
                decoration: const InputDecoration(labelText: "Select Bank"),
              ),
              TextField(controller: accountController, decoration: const InputDecoration(labelText: "Account Number")),
            ],

            if (selectedType == "paybill") ...[
              TextField(controller: paybillController, decoration: const InputDecoration(labelText: "Paybill Number")),
              TextField(controller: paybillAccountController, decoration: const InputDecoration(labelText: "Account (optional)")),
            ],

            if (selectedType == "buygoods")
              TextField(controller: tillController, decoration: const InputDecoration(labelText: "Till Number")),

            ElevatedButton(
              onPressed: addPayment,
              child: const Text("Add Payment"),
            ),
          ],
        ),
      ),
    );
  }
}