class User {
  int _id;
  String _userName;
  String _userFamilyName;
  String _userEmail;
  String _password;
  String _dateCreated;

  User(this._userName, this._userFamilyName, this._userEmail, this._password,
      this._dateCreated);

  User.map(dynamic obj) {
    this._userName = obj['username'];
    this._userFamilyName = obj['family_name'];
    this._userEmail = obj['user_email'];
    this._password = obj['password'];
    this._dateCreated = obj['date_created'];
    this._id = obj['id'];
  }

  String get userName => _userName;
  String get userFamilyName => _userFamilyName;
  String get userEmail => _userEmail;
  String get password => _password;
  String get dateCreated => _dateCreated;
  int get id => _id;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["username"] = _userName;
    map["family_name"] = _userFamilyName;
    map["user_email"] = _userEmail;
    map["password"] = _password;
    map["date_created"] = _dateCreated;
    if (id != null) {
      map["id"] = _id;
    } return map;
  }
  User.fromMap(Map<String, dynamic> map) {
    this._userName = map['username'];
    this._userFamilyName = map["family_name"];
    this._userEmail = map["user_email"];
    this._password = map['password'];
    this._dateCreated = map['date_created'];
    this._id = map['id'];
  }

}