import 'package:todo_list_provider/app/core/ui/notifier/default_change_notifier.dart';
import 'package:todo_list_provider/app/services/tasks/task_service.dart';

class TaskCreateController extends DefaultChangeNotifier {
  final TaskService _taskService;
  DateTime? _selectedDate;

  TaskCreateController({required TaskService taskService}) : _taskService = taskService;

  set selectedDate(DateTime? selectedDate) {
    resetState();
    _selectedDate = selectedDate;
    notifyListeners();
  }

  DateTime? get selectedDate => _selectedDate;

  Future<void> save(String description) async {
    try {
      showLoadingAndResetState();
      notifyListeners();
      if (_selectedDate != null) {
        await _taskService.save(_selectedDate!, description);
        success();
      } else {
        setError('Data ou task não selecionada');
      }
    } catch (err, s) {
      print(err);
      print(s);

      setError('Erro ao cadastrar task');
    } finally {
      hideLoading();
      notifyListeners();
    }
  }
}
