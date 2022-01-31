import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo_app/module/archivedtasks/archived_task.dart';
import 'package:flutter_todo_app/module/donetasks/done_task.dart';
import 'package:flutter_todo_app/module/newtaskscreen/new_task.dart';
import 'package:flutter_todo_app/shared/componant/componants.dart';
import 'package:flutter_todo_app/shared/componant/conestants.dart';
import 'package:flutter_todo_app/shared/cubit/cubit.dart';
import 'package:flutter_todo_app/shared/cubit/states.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  HomeLayout({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates states) {
          if (states is AppInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);

          return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                title: Text(cubit.titles[cubit.currentIndex]),
              ),
              body: ConditionalBuilder(
                condition: true,
                builder: (context) => cubit.screens[cubit.currentIndex],
                fallback: (context) => Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (cubit.isBottomSheetShown) {
                    if (formKey.currentState.validate()) {
                      // insertToDatabase(
                      //         title: titleController.text,
                      //         date: dateController.text,
                      //         time: timeController.text)
                      //     .then((value) {
                      //   getDataFromDatabase(database).then((value) {
                      //     Navigator.pop(context);
                      //     // setState(() {
                      //     //   isBottomSheetShown = false;
                      //     //   tasks = value;
                      //     //   print(tasks);
                      //     // });
                      //   });
                      // });

                      cubit.insertToDatabase(
                          title: titleController.text,
                          time: timeController.text,
                          date: dateController.text);
                    }
                  } else {
                    scaffoldKey.currentState
                        .showBottomSheet(
                            (context) => Container(
                                  color: Colors.white,
                                  padding: const EdgeInsets.all(20.0),
                                  child: Form(
                                    key: formKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        defaultFormField(
                                            controller: titleController,
                                            type: TextInputType.text,
                                            validate: (String value) {
                                              if (value.isEmpty) {
                                                return 'title must not be empty';
                                              }
                                              return null;
                                            },
                                            label: 'Task Title',
                                            prefix: Icons.title),
                                        SizedBox(
                                          height: 20.0,
                                        ),
                                        defaultFormField(
                                            controller: timeController,
                                            type: TextInputType.datetime,
                                            onTap: () {
                                              showTimePicker(
                                                      context: context,
                                                      initialTime:
                                                          TimeOfDay.now())
                                                  .then((value) {
                                                timeController.text = value
                                                    .format(context)
                                                    .toString();
                                                print(value.format(context));
                                              });
                                            },
                                            validate: (String value) {
                                              if (value.isEmpty) {
                                                return 'time must not be empty';
                                              }
                                              return null;
                                            },
                                            label: 'Task Time',
                                            prefix: Icons.watch_later_outlined),
                                        SizedBox(
                                          height: 20.0,
                                        ),
                                        defaultFormField(
                                            controller: dateController,
                                            type: TextInputType.datetime,
                                            onTap: () {
                                              showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime.parse(
                                                    '2022-23-02'),
                                              ).then((value) {
                                                print(DateFormat.yMMMd()
                                                    .format(value));
                                                dateController.text =
                                                    DateFormat.yMMMd()
                                                        .format(value);
                                              });
                                            },
                                            validate: (String value) {
                                              if (value.isEmpty) {
                                                return 'Date must not be empty';
                                              }
                                              return null;
                                            },
                                            label: 'Task Date',
                                            prefix: Icons.calendar_today)
                                      ],
                                    ),
                                  ),
                                ),
                            elevation: 20.0)
                        .closed
                        .then((value) {
                      cubit.changeBottomSheetState(
                          isShow: false, icon: Icons.edit);
                    });
                    cubit.isBottomSheetShown = true;
                    cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                  }
                },
                child: Icon(cubit.fabIcon),
              ),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: cubit.currentIndex,
                onTap: (index) {
                  cubit.changeIndex(index);
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.menu),
                    label: 'Tasks',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.check),
                    label: 'Done',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined),
                    label: 'archive',
                  ),
                ],
              ));
        },
      ),
    );
  }
}
