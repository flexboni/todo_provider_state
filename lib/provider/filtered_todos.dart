import 'package:equatable/equatable.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:todo_provider/model/todo_model.dart';
import 'package:todo_provider/provider/todo_filter.dart';
import 'package:todo_provider/provider/todo_list.dart';
import 'package:todo_provider/provider/todo_search.dart';

class FilteredTodosState extends Equatable {
  final List<Todo> filteredTodos;

  const FilteredTodosState({required this.filteredTodos});

  factory FilteredTodosState.initial() =>
      const FilteredTodosState(filteredTodos: []);

  @override
  List<Object> get props => [filteredTodos];

  @override
  bool get stringify => true;

  FilteredTodosState copyWith({
    List<Todo>? filteredTodos,
  }) {
    return FilteredTodosState(
      filteredTodos: filteredTodos ?? this.filteredTodos,
    );
  }
}

class FilteredTodos extends StateNotifier<FilteredTodosState>
    with LocatorMixin {
  FilteredTodos() : super(FilteredTodosState.initial());

  @override
  void update(Locator watch) {
    final Filter filter = watch<TodoFilterState>().filter;
    final String searchTerm = watch<TodoSearchState>().searchTerm;
    final List<Todo> todos = watch<TodoListState>().todos;

    List<Todo> _filteredTodos;
    switch (filter) {
      case Filter.active:
        _filteredTodos = todos.where((todo) => !todo.completed).toList();
        break;

      case Filter.completed:
        _filteredTodos = todos.where((todo) => todo.completed).toList();
        break;

      case Filter.completed:
      default:
        _filteredTodos = todos;
    }

    if (searchTerm.isNotEmpty) {
      _filteredTodos = _filteredTodos
          .where(
            (todo) =>
                todo.desc.toUpperCase().contains(searchTerm.toUpperCase()),
          )
          .toList();
    }

    state = state.copyWith(filteredTodos: _filteredTodos);

    super.update(watch);
  }
}
