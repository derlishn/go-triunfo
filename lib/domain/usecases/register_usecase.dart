import 'package:go_triunfo/data/repositories/auth_repository.dart';
import 'package:go_triunfo/domain/models/user_model.dart';
import 'package:go_triunfo/domain/usecases/user_management_usecase.dart';

class RegisterUseCase {
  final AuthRepository _authRepository;
  final UserManagementUseCase _userManagementUseCase;

  RegisterUseCase(this._authRepository, this._userManagementUseCase);

  Future<UserModel?> execute(String email, String password, String displayName, String gender) async {
    // Creación de la cuenta en Firebase Authentication
    final user = await _authRepository.createUserWithEmailAndPassword(email, password, UserModel(
      uid: '', // Esto será reemplazado después de que el usuario sea creado
      email: email,
      displayName: displayName,
      photoUrl: 'default_photo_url', // Asigna una URL de foto predeterminada
      gender: gender,
      role: 'user', // Rol por defecto
      isActive: true, // Por defecto, el usuario está activo
      createdAt: DateTime.now(),
    ));

    if (user == null) return null;

    // Creación del modelo de usuario con los datos completos
    final userModel = UserModel(
      uid: user.uid,
      email: user.email!,
      displayName: displayName,
      photoUrl: 'default_photo_url', // Asigna una URL de foto predeterminada
      gender: gender,
      role: 'user', // Rol por defecto
      isActive: true, // Por defecto, el usuario está activo
      createdAt: DateTime.now(),
    );

    // Almacenar el usuario en Firestore
    await _userManagementUseCase.createUser(userModel);

    return userModel;
  }
}
