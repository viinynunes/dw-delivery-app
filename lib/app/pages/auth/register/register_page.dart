import 'package:dw_delivery_app/app/core/ui/base_state/base_state.dart';
import 'package:dw_delivery_app/app/core/ui/styles/text_styles.dart';
import 'package:dw_delivery_app/app/core/ui/widgets/delivery_app_bar.dart';
import 'package:dw_delivery_app/app/core/ui/widgets/delivery_button.dart';
import 'package:dw_delivery_app/app/pages/auth/register/register_controller.dart';
import 'package:dw_delivery_app/app/pages/auth/register/register_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends BaseState<RegisterPage, RegisterController> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterController, RegisterState>(
        listener: (context, state) {
          state.status.matchAny(
            any: (() {
              hideLoader();
            }),
            register: (() => showLoader()),
            error: () => showError(message: 'Erro ao registrat usuário'),
            success: () {
              hideLoader();
              showSuccess(message: 'Cadastro realizado com sucesso');
              Navigator.pop(context);
            },
          );
        },
        child: Scaffold(
          appBar: DeliveryAppBar(),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cadastro',
                      style: context.textStyles.textTitle,
                    ),
                    Text(
                      'Preencha os campos para completar o cadastro.',
                      style:
                          context.textStyles.textMedium.copyWith(fontSize: 18),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Nome'),
                      validator: Validatorless.required('Nome Obrigatório'),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'E-mail'),
                        validator: Validatorless.multiple([
                          Validatorless.required('E-mail Obrigatório'),
                          Validatorless.email('E-mail Inválido')
                        ])),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Senha'),
                      validator: Validatorless.multiple([
                        Validatorless.required('Senha Obrigatória'),
                        Validatorless.min(
                            6, 'Senha deve ter pelo menos 6 caracteres')
                      ]),
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Confirme a Senha'),
                      validator: Validatorless.multiple([
                        Validatorless.required(
                            'Confirmação de Senha Obrigatória'),
                        Validatorless.compare(
                            _passwordController, 'As senhas não são iguais')
                      ]),
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: DeliveryButton(
                        width: double.infinity,
                        label: 'Cadastrar',
                        onPressed: () {
                          final valid =
                              _formKey.currentState?.validate() ?? false;
                          if (valid) {
                            controller.register(
                                name: _nameController.text.trim(),
                                email: _emailController.text.trim(),
                                password: _passwordController.text);
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
