import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'todo_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List todolist = [];

  onSubmitted(val) {
    BlocProvider.of<TodoBloc>(context).add(TodoEvent.add(val));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple ToDo App'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * .75,
                child: TextField(
                  controller: BlocProvider.of<TodoBloc>(context).textController,
                  onSubmitted: onSubmitted,
                  decoration: InputDecoration(
                      hintText:
                          BlocProvider.of<TodoBloc>(context).validate == true
                              ? 'Should Enter Something'
                              : 'What do you want to do?',
                      hintStyle:
                          BlocProvider.of<TodoBloc>(context).validate == true
                              ? TextStyle(color: Colors.red)
                              : TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: BlocProvider.of<TodoBloc>(context).validate ==
                                  true
                              ? Colors.red
                              : Colors.grey,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: BlocProvider.of<TodoBloc>(context).validate ==
                                  true
                              ? Colors.red
                              : Colors.blue,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      )),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              BlocBuilder<TodoBloc, List>(
                  bloc: BlocProvider.of<TodoBloc>(context),
                  builder: (context, todoList) {
                    return ListView.builder(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * .12,
                            right: MediaQuery.of(context).size.width * .12),
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: todoList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            child: Card(
                              color: Colors.grey.shade400,
                              child: Row(children: [
                                Expanded(
                                  child: CheckboxListTile(
                                    value: todoList[index]['checked'],
                                    onChanged: (val) {
                                      setState(() {
                                        todoList[index]['checked'] = val!;
                                      });
                                    },
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    title: Text('${todoList[index]['todo']}'),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      BlocProvider.of<TodoBloc>(context)
                                          .add(TodoEvent.delete(index));
                                    },
                                    icon: Icon(Icons.cancel))
                              ]),
                            ),
                          );
                        });
                  }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
