class UserModel {
  String? id;
  String? chooseType;
  String? name;
  String? user;
  String? password;
  String? nameShop;
  String? nameRider;
  String? address;
  String? phone;
  String? urlPicture;
  String? lat;
  String? lng;
  String? token;
  String? lastNameRider;
  String? addressRider;
  String? phoneRider;
  String? dOBRider;
  String? genderRider;
  String? idNumberRider;
  String? motorNumberRider;

  UserModel(
      {this.id,
      this.chooseType,
      this.name,
      this.user,
      this.password,
      this.nameShop,
      this.nameRider,
      this.address,
      this.phone,
      this.urlPicture,
      this.lat,
      this.lng,
      this.token,
      this.lastNameRider,
      this.addressRider,
      this.phoneRider,
      this.dOBRider,
      this.genderRider,
      this.idNumberRider,
      this.motorNumberRider});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chooseType = json['ChooseType'];
    name = json['Name'];
    user = json['User'];
    password = json['Password'];
    nameShop = json['NameShop'];
    nameRider = json['NameRider'];
    address = json['Address'];
    phone = json['Phone'];
    urlPicture = json['UrlPicture'];
    lat = json['Lat'];
    lng = json['Lng'];
    token = json['Token'];
    lastNameRider = json['LastNameRider'];
    addressRider = json['AddressRider'];
    phoneRider = json['PhoneRider'];
    dOBRider = json['DOBRider'];
    genderRider = json['genderRider'];
    idNumberRider = json['IdNumberRider'];
    motorNumberRider = json['MotorNumberRider'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ChooseType'] = this.chooseType;
    data['Name'] = this.name;
    data['User'] = this.user;
    data['Password'] = this.password;
    data['NameShop'] = this.nameShop;
    data['NameRider'] = this.nameRider;
    data['Address'] = this.address;
    data['Phone'] = this.phone;
    data['UrlPicture'] = this.urlPicture;
    data['Lat'] = this.lat;
    data['Lng'] = this.lng;
    data['Token'] = this.token;
    data['LastNameRider'] = this.lastNameRider;
    data['AddressRider'] = this.addressRider;
    data['PhoneRider'] = this.phoneRider;
    data['DOBRider'] = this.dOBRider;
    data['genderRider'] = this.genderRider;
    data['IdNumberRider'] = this.idNumberRider;
    data['MotorNumberRider'] = this.motorNumberRider;
    return data;
  }
}
