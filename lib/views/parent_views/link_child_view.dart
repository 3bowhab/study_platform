import 'package:flutter/material.dart';
import 'package:study_platform/helper/validators.dart';
import 'package:study_platform/services/authentication/link_child_service.dart';

class LinkChildView extends StatefulWidget {
  const LinkChildView({super.key});

  @override
  State<LinkChildView> createState() => _LinkChildViewState();
}

class _LinkChildViewState extends State<LinkChildView> {
  final _formKey = GlobalKey<FormState>();
  String? childUsername;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ربط حساب الابن')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "اسم المستخدم للابن",
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) => childUsername = val,
                validator: (val) => AppValidators.requiredField(val),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() => _isLoading = true);

                        try {
                          await LinkChildService().linkChild(childUsername!);

                          if (!mounted) return;

                          // ✅ نجاح → نعرض رسالة ونخرج بره
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("✅ تم ربط $childUsername بنجاح"),
                            ),
                          );

                          Navigator.pop(context); // يخرج للشاشة اللي قبلها
                          Navigator.pop(context);
                        } catch (e) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("❌ فشل ربط الابن: $e")),
                          );
                        } finally {
                          if (mounted) setState(() => _isLoading = false);
                        }
                      }
                    },
                    child: const Text('ربط'),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
