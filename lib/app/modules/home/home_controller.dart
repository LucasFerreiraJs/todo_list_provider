import 'package:todo_list_provider/app/core/ui/notifier/default_change_notifier.dart';
import 'package:todo_list_provider/app/models/task_filter_enum.dart';
import 'package:todo_list_provider/app/models/task_model.dart';
import 'package:todo_list_provider/app/models/total_tasks_modal.dart';
import 'package:todo_list_provider/app/models/week_task_model.dart';
import 'package:todo_list_provider/app/services/tasks/task_service.dart';

class HomeController extends DefaultChangeNotifier {
  final TaskService _taskService;

  TaskFilterEnum filterSelected = TaskFilterEnum.today;
  TotalTasksModel? todayTotalTasks;
  TotalTasksModel? tomorrowTotalTasks;
  TotalTasksModel? weekTotalTasks;
  List<TaskModel> allTasks = [];
  List<TaskModel> filteredTasks = [];

  HomeController({required TaskService taskService}) : _taskService = taskService;

  Future<void> loadTotalTasks() async {
    // retorna lista de object
    final allTasks = await Future.wait([
      _taskService.getToday(),
      _taskService.getTomorrow(),
      _taskService.getWeek(),
    ]);

    final todayTasks = allTasks[0] as List<TaskModel>;
    final tomorrowTasks = allTasks[1] as List<TaskModel>;
    final weekTasks = allTasks[2] as WeekTaskModel;

    todayTotalTasks = TotalTasksModel(
      totalTasks: todayTasks.length,
      totalTasksFinish: todayTasks.where((task) => task.finished).length,
    );

    tomorrowTotalTasks = TotalTasksModel(
      totalTasks: tomorrowTasks.length,
      totalTasksFinish: tomorrowTasks.where((task) => task.finished).length,
    );
    weekTotalTasks = TotalTasksModel(
      totalTasks: weekTasks.tasks.length,
      totalTasksFinish: weekTasks.tasks.where((task) => task.finished).length,
    );

    notifyListeners();
  }

  Future<void> findTasks({required TaskFilterEnum filter}) async {
    try {
      filterSelected = filter;
      showLoading();
      notifyListeners();
      List<TaskModel> tasks;
      print('filter ${filter}');
      switch (filter) {
        case TaskFilterEnum.today:
          tasks = await _taskService.getToday();
          break;
        case TaskFilterEnum.tomorrow:
          tasks = await _taskService.getTomorrow();
          break;
        case TaskFilterEnum.week:
          final weekModel = await _taskService.getWeek();
          tasks = weekModel.tasks;
          break;
      }

      allTasks = tasks;
      filteredTasks = tasks;
    } catch (err, s) {
      print('err $err');
      print('stacktrace $s');
      hideLoading();
    } finally {
      print('finally');
      hideLoading();
      notifyListeners();
    }
  }

  Future<void> refreshPage() async {
    await findTasks(filter: filterSelected);
    await loadTotalTasks();
    notifyListeners();
  }
}
