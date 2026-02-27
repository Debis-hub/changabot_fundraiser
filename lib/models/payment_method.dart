enum PaymentType { bank, paybill, buygoods }

class PaymentMethod {
  final PaymentType type;
  final String? bankAlias;
  final String? account;
  final String? paybill;
  final String? tillNumber;

  PaymentMethod({
    required this.type,
    this.bankAlias,
    this.account,
    this.paybill,
    this.tillNumber,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "type": type.name,
    };

    if (type == PaymentType.bank) {
      data['bank_alias'] = bankAlias;
      data['account'] = account;
    }

    if (type == PaymentType.paybill) {
      data['paybill'] = paybill;
      data['account'] = account;
    }

    if (type == PaymentType.buygoods) {
      data['till_number'] = tillNumber;
    }

    return data;
  }
}