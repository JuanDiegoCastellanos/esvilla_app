import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class SecureStorageService {

  Future<void> saveToken(String accessToken);
  Future<String?> getToken();
  Future<void> clearToken();
  
  Future<void> saveRefreshToken(String refreshToken);
  Future<String?> getRefreshToken();
  Future<void> clearRefreshToken();
  
  Future<void> saveExpiration(int expiresIn);
  Future<int?> getExpiration();
  Future<void> clearExpiration();
}

class SecureStorageServiceImpl  implements SecureStorageService{
  final FlutterSecureStorage _storage;

  SecureStorageServiceImpl(this._storage);

  @override
  Future<void> saveToken(String accessToken) async {
    await _storage.write(key: 'ACCESS_TOKEN', value: accessToken);
  }

  @override
  Future<void> saveExpiration(int expiresIn) async {
    final expirationTime = DateTime.now()
        .add(Duration(seconds: expiresIn))
        .millisecondsSinceEpoch;
    await _storage.write(key: 'EXPIRES_IN', value: expirationTime.toString());
  }
  
  @override
  Future<void> saveRefreshToken(String refreshToken) async {
    await _storage.write(key: 'REFRESH_TOKEN', value: refreshToken);
  }
  
  @override
  Future<int?> getExpiration() async {
    final expiration = await _storage.read(key: 'EXPIRES_IN');
    return int.parse(expiration ?? '0');
  }
  
  @override
  Future<String?> getRefreshToken() async{
    return await _storage.read(key: 'REFRESH_TOKEN');
  }
  
  @override
  Future<String?> getToken() async {
   return await _storage.read(key: 'ACCESS_TOKEN');
  }
  
  @override
  Future<void> clearExpiration() async{
    await _storage.delete(key: 'EXPIRES_IN');
  }
  
  @override
  Future<void> clearRefreshToken() async {
    await _storage.delete(key: 'REFRESH_TOKEN');
  }
  
  @override
  Future<void> clearToken() async  {
    await _storage.delete(key: 'ACCESS_TOKEN');
  }

}