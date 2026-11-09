import 'package:xchat/core/errors/exceptions.dart';
import 'package:xchat/core/errors/failures.dart';
import 'package:fpdart/fpdart.dart';

/// Runs [action] and converts any thrown exception into a [Failure].
Future<Either<Failure, T>> guard<T>(Future<T> Function() action) async {
  try {
    return Either<Failure, T>.right(await action());
  } on AppException catch (e) {
    return Either<Failure, T>.left(mapException(e));
  } catch (e) {
    return Either<Failure, T>.left(UnexpectedFailure(e.toString()));
  }
}

Failure mapException(AppException e) => switch (e) {
      NetworkException() => NetworkFailure(e.message),
      ServerException() => ServerFailure(e.message, code: e.code),
      UnauthorizedException() => UnauthorizedFailure(e.message),
      CacheException() => CacheFailure(e.message),
      RealtimeException() => ServerFailure(e.message),
    };
