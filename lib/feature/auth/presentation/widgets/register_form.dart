import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_triunfo/core/strings/app_strings.dart';
import 'package:go_triunfo/core/utils/helpers/navigator_helper.dart';
import 'package:go_triunfo/core/utils/widgets/show_custom_snackbar.dart';
import 'package:go_triunfo/feature/auth/presentation/manager/auth_viewmodel.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart'; // Importar el paquete
import '../../../home/presentation/screens/home_screen.dart';

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
              onChanged: authViewModel.setDisplayName,
              decoration: InputDecoration(
                labelText: AppStrings.displayNameHintText,
                prefixIcon: const Icon(Icons.person),
                labelStyle: const TextStyle(fontSize: 16),
                border: const OutlineInputBorder(),
                errorText: authViewModel.displayNameError,
              ),
            ),
            const SizedBox(height: 20),
            // Email
            TextField(
              onChanged: authViewModel.setEmail,
              decoration: InputDecoration(
                labelText: AppStrings.emailHintText,
                prefixIcon: const Icon(Icons.email),
                labelStyle: const TextStyle(fontSize: 16),
                border: const OutlineInputBorder(),
                errorText: authViewModel.emailError,
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            // Password
            TextField(
              onChanged: authViewModel.setPassword,
              obscureText: !authViewModel.isPasswordVisible,
              decoration: InputDecoration(
                labelText: AppStrings.passwordHintText,
                prefixIcon: const Icon(Icons.lock),
                labelStyle: const TextStyle(fontSize: 16),
                border: const OutlineInputBorder(),
                errorText: authViewModel.passwordError,
                suffixIcon: IconButton(
                  icon: Icon(
                    authViewModel.isPasswordVisible
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
              onChanged: authViewModel.setConfirmPassword,
              obscureText: true,
              decoration: InputDecoration(
                labelText: AppStrings.confirmPasswordHintText,
                prefixIcon: const Icon(Icons.lock),
                labelStyle: const TextStyle(fontSize: 16),
                border: const OutlineInputBorder(),
                errorText: authViewModel.confirmPasswordError,
              ),
            ),
            const SizedBox(height: 20),
            // Phone Number
            InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {
                authViewModel.setPhoneNumber(number);
              },
              selectorConfig: const SelectorConfig(
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
              ),
              ignoreBlank: false,
              autoValidateMode: AutovalidateMode.onUserInteraction,
              initialValue: PhoneNumber(isoCode: 'PE'),
              textFieldController: phoneController,
              formatInput: true,
              inputDecoration: InputDecoration(
                labelText: AppStrings.phoneHintText,
                prefixIcon: const Icon(Icons.phone),
                labelStyle: const TextStyle(fontSize: 16),
                border: const OutlineInputBorder(),
                errorText: authViewModel.phoneNumberError,
              ),
              onSaved: (PhoneNumber number) {},
            ),
            const SizedBox(height: 20),
            // Address
            TextField(
              onChanged: authViewModel.setAddress,
              decoration: InputDecoration(
                labelText: AppStrings.addressHintText,
                prefixIcon: const Icon(Icons.location_on),
                labelStyle: const TextStyle(fontSize: 16),
                border: const OutlineInputBorder(),
                errorText: authViewModel.addressError,
              ),
              keyboardType: TextInputType.streetAddress,
            ),
            const SizedBox(height: 20),
            // Gender Dropdown
            DropdownButtonFormField<String>(
              value: authViewModel.gender,
              decoration: InputDecoration(
                labelText: AppStrings.gendertitle,
                prefixIcon: const Icon(Icons.person_outline),
                labelStyle: const TextStyle(fontSize: 16),
                border: const OutlineInputBorder(),
                errorText: authViewModel.genderError,
              ),
              items: [
                DropdownMenuItem(
                  value: 'no especificado',
                  child: Text(
                    'No especificado',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: 'masculino',
                  child: Text(
                    AppStrings.maleGenderText,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: 'femenino',
                  child: Text(
                    AppStrings.femaleGenderText,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: 'otro',
                  child: Text(
                    AppStrings.otherGenderText,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
              onChanged: authViewModel.setGender,
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
