import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo_app/shared/componant/componants.dart';
import 'package:flutter_todo_app/shared/componant/conestants.dart';
import 'package:flutter_todo_app/shared/cubit/cubit.dart';
import 'package:flutter_todo_app/shared/cubit/states.dart';

class NewTask extends StatelessWidget {
  const NewTask({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).newTasks;

        return tasksBuilder(
          tasks: tasks,
        );
      },
    );
  }
}
