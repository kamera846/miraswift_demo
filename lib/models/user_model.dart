class UserModel {
  const UserModel({
    required this.idUser,
    required this.phoneUser,
    required this.isActive,
    required this.nameUser,
  });

  final String idUser;
  final String phoneUser;
  final String isActive;
  final String nameUser;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      idUser: json['id_user'],
      phoneUser: json['phone_user'],
      isActive: json['is_active'],
      nameUser: json['name_user'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id_user': idUser,
        'phone_user': phoneUser,
        'is_active': isActive,
        'name_user': nameUser,
      };
}
