class HttpException implements Exception {
  final String massage;
  HttpException(this.massage);

  @override
  String toString() {
    return massage;
    // return super.toString(); // it will be 'Instance of HttpException'
  }
}