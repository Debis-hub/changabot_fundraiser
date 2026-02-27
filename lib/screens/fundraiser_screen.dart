import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // needed for Clipboard
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
  bool isLoadingBanks = true;

  @override
  void initState() {
    super.initState();
    loadBanks();
  }

  void loadBanks() async {
    final bankList = await api.getBanks();
    setState(() {
      banks = bankList;
      isLoadingBanks = false;
    });
  }

  void createFundraiser() async {
    if (titleController.text.isEmpty ||
        descController.text.isEmpty ||
        targetController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill all fundraiser fields")));
      return;
    }

    final id = await api.createFundraiser(
      titleController.text,
      descController.text,
      targetController.text,
    );

    setState(() => fundraiserId = id);

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fundraiser Created Successfully")));
  }

  void showFundraiserLink(String link) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Payment method added!"),
        content: TextFormField(
          initialValue: link,
          readOnly: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: link));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Link copied to clipboard")));
            },
            child: const Text("Copy"),
          ),
        ],
      ),
    );
  }

  void addPayment() async {
  if (fundraiserId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Create fundraiser first")));
    return;
  }

  PaymentMethod payment;

  // 1️⃣ Build the payment method object
  if (selectedType == "bank") {
    if (selectedBankAlias == null || accountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Select bank and enter account")));
      return;
    }
    payment = PaymentMethod(
      type: PaymentType.bank,
      bankAlias: selectedBankAlias,
      account: accountController.text,
    );
  } else if (selectedType == "paybill") {
    if (paybillController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Enter paybill number")));
      return;
    }
    payment = PaymentMethod(
      type: PaymentType.paybill,
      paybill: paybillController.text,
      account: paybillAccountController.text,
    );
  } else {
    if (tillController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Enter till number")));
      return;
    }
    payment = PaymentMethod(
      type: PaymentType.buygoods,
      tillNumber: tillController.text,
    );
  }

  try {
    // 2️⃣ Call API (void return)
    await api.addPaymentMethod(fundraiserId!, payment);

    // 3️⃣ Build the payment link manually since API returns void
    final paymentLink = 'https://use.changabot.online/$fundraiserId/pay';

    // 4️⃣ Show the link in a dialog with copy option
    showFundraiserLink(paymentLink);
  } catch (e) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Error: $e")));
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ChangaBot Fundraiser")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Create Fundraiser",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            TextField(
              controller: targetController,
              decoration: const InputDecoration(labelText: "Target Amount"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: createFundraiser,
              child: const Text("Create Fundraiser"),
            ),
            const SizedBox(height: 30),
            const Text("Add Payment Method",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      onPressed: () => setState(() => selectedType = "bank"),
                      child: const Text("Bank")),
                ),
                Expanded(
                  child: ElevatedButton(
                      onPressed: () => setState(() => selectedType = "paybill"),
                      child: const Text("Paybill")),
                ),
                Expanded(
                  child: ElevatedButton(
                      onPressed: () => setState(() => selectedType = "buygoods"),
                      child: const Text("Buy Goods")),
                ),
              ],
            ),
            const SizedBox(height: 15),
            if (selectedType == "bank") ...[
              isLoadingBanks
                  ? const Center(child: CircularProgressIndicator())
                  : DropdownButtonFormField<String>(
                      items: banks
                          .map((b) => DropdownMenuItem(
                                value: b.alias,
                                child: Text(b.name),
                              ))
                          .toList(),
                      onChanged: (val) => selectedBankAlias = val,
                      decoration: const InputDecoration(labelText: "Select Bank"),
                    ),
              TextField(
                controller: accountController,
                decoration: const InputDecoration(labelText: "Account Number"),
                keyboardType: TextInputType.number,
              ),
            ],
            if (selectedType == "paybill") ...[
              TextField(
                controller: paybillController,
                decoration: const InputDecoration(labelText: "Paybill Number"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: paybillAccountController,
                decoration: const InputDecoration(labelText: "Account (optional)"),
              ),
            ],
            if (selectedType == "buygoods")
              TextField(
                controller: tillController,
                decoration: const InputDecoration(labelText: "Till Number"),
                keyboardType: TextInputType.number,
              ),
            const SizedBox(height: 15),
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