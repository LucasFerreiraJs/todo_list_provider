import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_provider/app/core/auth/auth_provider.dart';
import 'package:todo_list_provider/app/core/ui/messages.dart';
import 'package:todo_list_provider/app/core/ui/theme_extensions.dart';
import 'package:todo_list_provider/app/services/user/user_service.dart';

class HomeDrawer extends StatelessWidget {
  HomeDrawer({super.key});
  final nameVN = ValueNotifier<String>('');

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: context.primaryColor.withAlpha(70),
          ),
          child: Row(
            children: [
              // https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg
              // CircleAvatar(),
              Selector<AuthProvider, String>(selector: (context, authProvider) {
                return authProvider.user?.photoURL ?? 'https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg';
              }, builder: (_, value, __) {
                return CircleAvatar(
                  backgroundImage: NetworkImage(value),
                  radius: 30,
                );
              }),
              Expanded(
                child: Selector<AuthProvider, String>(
                  selector: (context, authProvider) {
                    return authProvider.user?.displayName ?? 'Não do informado';
                  },
                  builder: (_, value, __) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(value, style: context.textTheme.bodyMedium),
                    );
                  },
                ),
                //  Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Text('Nome do usuário', style: context.textTheme.bodyMedium),
                // ),
              ),
            ],
          ),
        ),
        ListTile(
          onTap: () {
            showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  title: Text('Alterar Nome'),
                  content: TextField(
                    onChanged: (value) {
                      print(value);
                      nameVN.value = value;
                    },
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Cancelar', style: TextStyle(color: Colors.red)),
                    ),
                    TextButton(
                        onPressed: () {
                          if (nameVN.value.isEmpty) {
                            Messages.of(context).showError('Nome obrigaótio');
                          } else {
                            Loader.show(context);
                            context.read<UserService>().updateDisplayName(nameVN.value);
                            Loader.hide();
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text('Alterar')),
                  ],
                );
              },
            );
          },
          title: Text('Alterar Nome'),
        ),
        ListTile(
          onTap: () => context.read<AuthProvider>().logout(),
          title: Text('Sair'),
        ),
      ],
    ));
  }
}
