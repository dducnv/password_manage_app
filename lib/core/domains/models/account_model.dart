class AccountModel {
  final String? title;
  final String? email;
  final String? phone;
  final String? address;
  final String? avatar;

  AccountModel({
    this.title,
    this.email,
    this.phone,
    this.address,
    this.avatar,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      title: json['title'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'email': email,
      'phone': phone,
      'address': address,
      'avatar': avatar,
    };
  }
}
