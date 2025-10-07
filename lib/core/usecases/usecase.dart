// Esta clase base nos ayudará a estandarizar nuestros casos de uso.
// En este caso, no necesitamos parámetros ni un tipo de retorno específico,
// pero es una buena práctica tenerla para futuros casos de uso más complejos.
abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}