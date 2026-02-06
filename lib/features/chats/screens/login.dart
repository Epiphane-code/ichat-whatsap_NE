import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/langage_provider.dart';
import '../../../core/routes/app_routes.dart';
import '../../../l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;

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
      passwordController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Numéro ou mot de passe incorrect'),
          backgroundColor: Colors.redAccent,
        ),
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
          overflow: TextOverflow.ellipsis, // tronque avec "..."
          maxLines: 1,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
        
                TextFormField(
                  controller: passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    prefixIcon: const Icon(Icons.lock),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 4) {
                      return 'Mot de passe trop court';
                    }
                    return null;
                  },
                ),
        
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
                        : const Text('Se connecter'),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Pas de compte ?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.register);
                      },
                      child: const Text('S\'inscrire'),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Widget languageButton(
                      BuildContext context,
                      String code,
                      String name,
                    ) {
                      return ListTile(
                        title: Text(name),
                        onTap: () {
                          final lang = context.read<LanguageProvider>();
                          lang.changeLanguage(code); // ← Change la langue
                          Navigator.pop(context); // ferme le bottom sheet
                        },
                      );
                    }
        
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
    );
  }
}
