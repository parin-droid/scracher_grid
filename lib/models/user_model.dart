class UserModel {
  String? city;
  String? name;
  String? state;
  String? phone;
  String? zipcode;

  UserModel({this.city , this.name , this.state , this.phone , this.zipcode});

  // reciving data from server

  factory UserModel.fromMap(map){
    return UserModel(
      city: map['city'],
      name: map['name'],
      state: map['state'],
      phone: map['phone'],
      zipcode: map['zipcode'],
    );

  }

  // sending data to server
  Map<String , dynamic> toMap(){
    return{
      'city' : city,
      'name' : name,
      'state' : state,
      'phone' : phone,
      'zipcode' : zipcode,
    };
  }



}