import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_provider/app/core/ui/notifier/default_listener_notifier.dart';
import 'package:todo_list_provider/app/core/ui/theme_extensions.dart';
import 'package:todo_list_provider/app/core/validators/validators.dart';
import 'package:todo_list_provider/app/core/widget/todo_list_field.dart';
import 'package:todo_list_provider/app/core/widget/todo_list_logo.dart';
import 'package:todo_list_provider/app/modules/auth/register/register_controller.dart';
import 'package:validatorless/validatorless.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();
  final _connfirmPasswordEC = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailEC.dispose();
    _passwordEC.dispose();
    _connfirmPasswordEC.dispose();
    // context.read<RegisterController>().addListener(() {});
  }

  @override
  void initState() {
    super.initState();
    context.read<RegisterController>().addListener(() {
      var defaultListener = DefaultListenerNotifier(changeNotifier: context.read<RegisterController>());
      defaultListener.listener(
        context: context,
        successCallback: (notifier, listenerInstance) {
          // listenerInstance.dispose();

          // auteração do authprovider
          // Navigator.of(context).pop();
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: .5,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Todo List', style: TextStyle(fontSize: 10, color: context.primaryColor)),
            Text('Cadastro', style: TextStyle(fontSize: 15, color: context.primaryColor)),
          ],
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: ClipOval(
            child: Container(
              padding: const EdgeInsets.all(8),
              color: context.primaryColor.withAlpha(20),
              child: Icon(
                Icons.arrow_back_ios_outlined,
                size: 20,
                color: context.primaryColor,
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.width * .5,
            child: FittedBox(
              // * conteúdo com tamanho ajustável
              fit: BoxFit.fitHeight,
              child: TodoListLogo(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(children: [
                TodoListField(
                  label: 'E-mail',
                  controller: _emailEC,
                  validator: Validatorless.multiple([
                    Validatorless.required('Email obrigatório'),
                    Validatorless.email('Email inválido'),
                  ]),
                ),
                SizedBox(height: 20),
                TodoListField(
                  label: 'Senha',
                  obscureText: true,
                  controller: _passwordEC,
                  validator: Validatorless.multiple([
                    Validatorless.required('Senha obrigatória'),
                    Validatorless.min(6, 'Senha deve ter pelo menos 6 caracteres'),
                  ]),
                ),
                SizedBox(height: 20),
                TodoListField(
                  label: 'Confirmar Senha',
                  obscureText: true,
                  controller: _connfirmPasswordEC,
                  validator: Validatorless.multiple([
                    Validatorless.required('Senha obrigatória'),
                    Validators.compare(_passwordEC, 'Senhas diferentes'),
                  ]),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {
                      final isValid = _formKey.currentState?.validate() ?? false;

                      if (isValid) {
                        final email = _emailEC.text;
                        final password = _passwordEC.text;
                        context.read<RegisterController>().registerUser(email, password);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      child: Text('Salvar'),
                    ),
                  ),
                )
              ]),
            ),
          )
        ],
      ),
    );
  }
}
