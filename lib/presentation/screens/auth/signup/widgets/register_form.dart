import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_triunfo/core/utils/localizations.dart';
import 'package:go_triunfo/core/utils/validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../data/providers/auth_providers.dart';

class RegisterForm extends HookConsumerWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayNameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final genderController = useState<String?>('Male');
    final authViewModel = ref.read(authProvider.notifier);

    final formKey = GlobalKey<FormState>();

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.registerHeader,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 28,
            ),
          ),
          const SizedBox(height: 8),
          const Text(AppLocalizations.registerSubHeader),
          const SizedBox(height: 40),
          TextFormField(
            controller: displayNameController,
            decoration: const InputDecoration(
              labelText: AppLocalizations.displayNameHintText,
              labelStyle: TextStyle(fontSize: 16),
              border: OutlineInputBorder(),
            ),
            validator: Validators.validateName,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: AppLocalizations.emailHintText,
              labelStyle: TextStyle(fontSize: 16),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: Validators.validateEmail,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: passwordController,
            decoration: const InputDecoration(
              labelText: AppLocalizations.passwordHintText,
              labelStyle: TextStyle(fontSize: 16),
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.visibility_off),
            ),
            obscureText: true,
            validator: Validators.validatePassword,
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: genderController.value,
            decoration: const InputDecoration(
              labelText: AppLocalizations.genderHintText,
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'Male', child: Text('Hombre')),
              DropdownMenuItem(value: 'Female', child: Text('Mujer')),
              DropdownMenuItem(value: 'Other', child: Text('Otro')),
            ],
            onChanged: (value) {
              genderController.value = value;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                await authViewModel.register(
                  emailController.text,
                  passwordController.text,
                  displayNameController.text,
                  genderController.value!,
                );
                Navigator.pushReplacementNamed(context, '/home');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Por favor, corrige los errores en el formulario'),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              backgroundColor: Theme.of(context).colorScheme.primary,
              textStyle: const TextStyle(fontSize: 18),
            ),
            child: const Text(AppLocalizations.registerButtonText),
          ),
        ],
      ),
    );
  }
}
