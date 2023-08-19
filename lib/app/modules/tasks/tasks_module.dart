import 'package:provider/provider.dart';
import 'package:todo_list_provider/app/core/database/sqlite_connect_factory.dart';
import 'package:todo_list_provider/app/core/modules/todo_list_module.dart';
import 'package:todo_list_provider/app/modules/tasks/task_create_controller.dart';
import 'package:todo_list_provider/app/modules/tasks/task_create_page.dart';
import 'package:todo_list_provider/app/repositories/tasks/task_repository.dart';
import 'package:todo_list_provider/app/repositories/tasks/task_repository_impl.dart';
import 'package:todo_list_provider/app/services/tasks/task_service.dart';
import 'package:todo_list_provider/app/services/tasks/task_service_impl.dart';

class TasksModule extends TodoListModule {
  TasksModule()
      : super(
          bindings: [
            Provider<TaskRepository>(
              create: (context) => TaskRepositoryImpl(
                sqliteConnectionFactory: context.read<SqliteConnectionFactory>(),
              ),
            ),
            Provider<TaskService>(
              create: (context) => TaskServiceImpl(taskRepository: context.read<TaskRepository>()),
            ),
            ChangeNotifierProvider(
              create: (context) => TaskCreateController(taskService: context.read<TaskService>()),
            ),
          ],
          routers: {
            '/task/create': (context) => TaskCreatePage(controller: context.read<TaskCreateController>()),
          },
        );
}
