import 'package:xchat/core/errors/failures.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class UseCase<T, P> {
  Future<Either<Failure, T>> call(P params);
}

final class NoParams {
  const NoParams();
}
