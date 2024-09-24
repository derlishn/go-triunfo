import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_triunfo/core/strings/app_strings.dart';
import 'package:go_triunfo/core/utils/helpers/navigator_helper.dart';
import 'package:go_triunfo/core/utils/widgets/show_custom_snackbar.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../manager/auth_viewmodel.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Controlador para el número de teléfono
    final TextEditingController phoneController = TextEditingController();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.registerHeader,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 28,
              ),
            ),
            const SizedBox(height: 8),
            const Text(AppStrings.registerSubHeader),
            const SizedBox(height: 40),
            // Display Name
            TextField(
              onChanged: (value) {
                authViewModel.fields.displayName = value;
                authViewModel.updateFieldErrors();
              },
              decoration: InputDecoration(
                labelText: AppStrings.displayNameHintText,
                prefixIcon: const Icon(Icons.person),
                border: const OutlineInputBorder(),
                errorText: authViewModel.fields.displayNameError,
              ),
            ),
            const SizedBox(height: 20),
            // Email
            TextField(
              onChanged: (value) {
                authViewModel.fields.email = value;
                authViewModel.updateFieldErrors();
              },
              decoration: InputDecoration(
                labelText: AppStrings.emailHintText,
                prefixIcon: const Icon(Icons.email),
                border: const OutlineInputBorder(),
                errorText: authViewModel.fields.emailError,
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            // Password
            TextField(
              onChanged: (value) {
                authViewModel.fields.password = value;
                authViewModel.updateFieldErrors();
              },
              obscureText: !authViewModel.fields.isPasswordVisible,
              decoration: InputDecoration(
                labelText: AppStrings.passwordHintText,
                prefixIcon: const Icon(Icons.lock),
                border: const OutlineInputBorder(),
                errorText: authViewModel.fields.passwordError,
                suffixIcon: IconButton(
                  icon: Icon(
                    authViewModel.fields.isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: authViewModel.togglePasswordVisibility,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Confirm Password
            TextField(
              onChanged: (value) {
                authViewModel.fields.confirmPassword = value;
                authViewModel.updateFieldErrors();
              },
              obscureText: true,
              decoration: InputDecoration(
                labelText: AppStrings.confirmPasswordHintText,
                prefixIcon: const Icon(Icons.lock),
                border: const OutlineInputBorder(),
                errorText: authViewModel.fields.confirmPasswordError,
              ),
            ),
            const SizedBox(height: 20),
            // Phone Number (fixed to Honduras +504)
            InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {
                authViewModel.fields.phoneNumber = number;
                authViewModel.updateFieldErrors();
              },
              selectorConfig: const SelectorConfig(
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                showFlags: false,
              ),
              ignoreBlank: false,
              autoValidateMode: AutovalidateMode.onUserInteraction,
              initialValue: PhoneNumber(isoCode: 'HN', dialCode: '+504'),
              textFieldController: phoneController,
              formatInput: true,
              inputDecoration: InputDecoration(
                labelText: AppStrings.phoneHintText,
                prefixIcon: const Icon(Icons.phone),
                border: const OutlineInputBorder(),
                errorText: authViewModel.fields.phoneNumberError,
              ),
              onSaved: (PhoneNumber number) {},
              countries: const ['HN'],
            ),
            const SizedBox(height: 20),
            // Address
            TextField(
              onChanged: (value) {
                authViewModel.fields.address = value;
                authViewModel.updateFieldErrors();
              },
              decoration: InputDecoration(
                labelText: AppStrings.addressHintText,
                prefixIcon: const Icon(Icons.location_on),
                border: const OutlineInputBorder(),
                errorText: authViewModel.fields.addressError,
              ),
              keyboardType: TextInputType.streetAddress,
            ),
            const SizedBox(height: 20),
            // Gender Dropdown
            DropdownButtonFormField<String>(
              value: authViewModel.fields.gender.isNotEmpty ? authViewModel.fields.gender : null,
              decoration: InputDecoration(
                labelText: AppStrings.gendertitle,
                prefixIcon: const Icon(Icons.person_outline),
                border: const OutlineInputBorder(),
                errorText: authViewModel.fields.genderError,
              ),
              items: [
                DropdownMenuItem(
                  value: 'masculino',
                  child: Text(
                    AppStrings.maleGenderText,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: 'femenino',
                  child: Text(
                    AppStrings.femaleGenderText,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: 'no especificado', // Asegúrate de agregar esta opción
                  child: Text(
                    'No especificado', // El texto que quieres mostrar
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
              onChanged: (value) {
                authViewModel.fields.gender = value!;
                authViewModel.updateFieldErrors();
              },
            ),
            const SizedBox(height: 20),
            // Register Button
            ElevatedButton(
              onPressed: authViewModel.isLoading
                  ? null
                  : () async {
                await authViewModel.signUp();

                if (authViewModel.errorMessage != null) {
                  showCustomSnackBar(
                    context,
                    authViewModel.errorMessage!,
                    isError: true,
                  );
                } else if (authViewModel.currentUser != null) {
                  showCustomSnackBar(
                    context,
                    'Registro exitoso',
                    isError: false,
                  );
                  replaceAndRemoveUntil(context, HomeScreen());
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Theme.of(context).colorScheme.primary,
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: authViewModel.isLoading
                  ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
                  : const Text(AppStrings.registerButtonText),
            ),
          ],
        ),
      ),
    );
  }
}
