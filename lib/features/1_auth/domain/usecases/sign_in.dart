import 'package:untitled2/core/usecases/usecase.dart';
import 'package:untitled2/features/1_auth/domain/entities/user.dart';
import 'package:untitled2/features/1_auth/domain/repositories/auth_repository.dart';

class SignInUseCase implements UseCase<User?, SignInParams> {
  final AuthRepository authRepository;

  SignInUseCase(this.authRepository);

  @override
  Future<User?> call(SignInParams params) async {
    return await authRepository.signIn(
      email: params.email,
      password: params.password,
    );
  }
}

class SignInParams {
  final String email;
  final String password;

  SignInParams({required this.email, required this.password});
}