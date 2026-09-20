abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'حدث خطأ في الاتصال بالخادم']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'تعذر استرجاع البيانات المحفوظة محلياً']);
}

class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'بيانات الإدخال غير صحيحة']);
}

class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'حدث خطأ في الخادم']);
  @override
  String toString() => message;
}

