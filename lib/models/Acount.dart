class Acount {
  
  late String _uid;
  late String _username;
  late String _imageUrl;
Acount(this._uid,this._imageUrl,this._username,);
 
  get uid => _uid;

  set uid(value) => _uid = value;

  get username => _username;

  set username(value) => _username = value;

  get imageUrl => _imageUrl;

  set imageUrl(value) => _imageUrl = value;
}
