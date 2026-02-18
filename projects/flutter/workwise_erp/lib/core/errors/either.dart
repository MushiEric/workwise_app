/// Simple Either implementation (Left = Failure/Exception, Right = Value)
sealed class Either<L, R> {
  const Either._();

  const factory Either.left(L l) = Left<L, R>;
  const factory Either.right(R r) = Right<L, R>;

  T fold<T>(T Function(L l) leftF, T Function(R r) rightF) {
    if (this is Left<L, R>) return leftF((this as Left).value as L);
    return rightF((this as Right).value as R);
  }

  bool get isLeft => this is Left<L, R>;
  bool get isRight => this is Right<L, R>;

  R getOrElse(R Function() orElse) {
    if (this is Right<L, R>) return (this as Right).value as R;
    return orElse();
  }
}

final class Left<L, R> extends Either<L, R> {
  final L value;
  const Left(this.value) : super._();
}

final class Right<L, R> extends Either<L, R> {
  final R value;
  const Right(this.value) : super._();
}
