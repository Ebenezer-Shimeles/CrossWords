abstract class Service {}

/*
  Interface segrigation
 */
abstract class Initable<T> {
  Future<T> init();
}

abstract class Disposable<T> {
  Future<T> dispose();
}
