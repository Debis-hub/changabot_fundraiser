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
  final map = <String, dynamic>{'type': type.name};

  switch (type) {
    case PaymentType.bank:
      if (bankAlias != null) map['bank_alias'] = bankAlias;
      if (account != null) map['account'] = account;
      break;

    case PaymentType.paybill:
      if (paybill != null) map['paybill'] = paybill;
      if (account != null) map['account'] = account;
      break;

    case PaymentType.buygoods:
      if (tillNumber != null) map['till_number'] = tillNumber;
      break;
  }

  return map;
}
}