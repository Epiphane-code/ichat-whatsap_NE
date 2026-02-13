import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../core/routes/app_routes.dart';
import 'package:ichat/l10n/app_localizations.dart';
import 'package:ichat/features/chats/widgets/langageButton_tile.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();

    final success = await auth.login(
      phoneController.text.trim(), // trim() pour enlever les espaces
    );

    if (!mounted) return;

    if (success) {

      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.home,
        arguments: phoneController.text.trim(),
      );
    } else {
       // ignore: use_build_context_synchronously
       Navigator.pushReplacementNamed(
        context,
        AppRoutes.otp,
        arguments: phoneController.text.trim(),
  );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          AppLocalizations.of(context)!.login,
          overflow: TextOverflow.ellipsis, //  "..."
          maxLines: 1,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    AppLocalizations.of(context)!.welcome,
                    style: Theme.of(context).textTheme.headlineMedium,
                    overflow: TextOverflow.ellipsis, // tronque avec "..."
                    maxLines: 1,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.login_to_continue,
                    style: Theme.of(context).textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis, // tronque avec "..."
                    maxLines: 1,
                  ),
                  const SizedBox(height: 32),
                  Icon(
                    Icons.login_outlined,
                    size: 80,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.phone_number,
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.phone_number;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),


                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: auth.isLoading ? null : () => _login(context),
                      child: auth.isLoading
                          ? const CircularProgressIndicator(
                              color: Color.fromARGB(255, 4, 212, 66),
                            )
                          : Text(AppLocalizations.of(context)!.login,
                    ),
                  ),),
                  const SizedBox(height: 16),
        
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppLocalizations.of(context)!.no_account),
                      TextButton(
                        onPressed: () {
                        },
                        child: Text(AppLocalizations.of(context)!.sign_up),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Afficher un menu pour choisir la langue
                      showModalBottomSheet(
                        context: context,
                        builder: (_) => ListView(
                          children: [
                            languageButton(context, 'fr', 'Français'),
                            languageButton(context, 'en', 'English'),
                            languageButton(context, 'ha', 'Hausa'),
                            languageButton(context, 'dje', 'Zarma'),
                            languageButton(context, 'ff', 'Fulfulde'),
                            languageButton(context, 'taq', 'Touareg'),
                            languageButton(context, 'kr', 'Kanuri'),
                            languageButton(context, 'ar', 'Arabe'),
                          ],
                        ),
                      );
                    },
                    child: Text(AppLocalizations.of(context)!.change_language),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
