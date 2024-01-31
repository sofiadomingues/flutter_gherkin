import 'package:example_with_integration_test/models/todo_model.dart';
import 'package:example_with_integration_test/widgets/view_utils_mixin.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class AddTodoComponent extends StatefulWidget {
  final void Function(Todo) onAdded;
  final Stream<Todo> todo;

  const AddTodoComponent({
    required this.todo,
    required this.onAdded,
  }) : super();

  @override
  _AddTodoComponentState createState() => _AddTodoComponentState();
}

class _AddTodoComponentState extends State<AddTodoComponent>
    with ViewUtilsMixin {
  final TextEditingController _textEditingController = TextEditingController();
  final Subject<void> disposed$ = PublishSubject<void>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    widget.todo.takeUntil(disposed$).listen(
          (model) {
        setState(() {
          _textEditingController.text = model.action ?? '';
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Form(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                right: 16,
              ),
              child: SizedBox(
                width: 200,
                child: TextFormField(
                  controller: _textEditingController,
                  style: Theme.of(context).textTheme.subtitle1,
                  key: const Key('todo'),
                  decoration: InputDecoration(
                    labelText: 'Add todo item...  ',
                  ),
                  validator: (text) => text == null || text.isEmpty
                      ? 'You must add a todo item'
                      : null,
                ),
              ),
            ),
            FloatingActionButton(
              key: const Key('add'),
              onPressed: onAdd,
              backgroundColor: Theme.of(context).primaryColor,
              focusElevation: 3,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              child: !_isLoading
                  ? const Icon(Icons.add)
                  : CircularProgressIndicator(
                color: Colors.amber,
                backgroundColor: Colors.amberAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onAdd() {
    setState(() {
      _isLoading = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
    disposed$.add(null);
    _textEditingController.dispose();
    disposed$.close();
  }
}
