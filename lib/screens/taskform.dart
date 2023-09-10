import 'dart:convert';
import 'dart:js_interop';
import 'package:task/models/config.dart';
import 'package:task/models/users.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:task/models/task.dart';
import 'package:http/http.dart' as http;

class taskfrompage extends StatefulWidget {
  static const routeName = '/Task';
  const taskfrompage({super.key});

  @override
  State<taskfrompage> createState() => _taskfrompageState();
}

class _taskfrompageState extends State<taskfrompage> {
    var _formkey = GlobalKey<FormState>();
  // late Task tasks;
  Task tasks = Task();

// del

//updatedata
  Future<void> updateData(tasks) async {
    var url = Uri.http(Configure.server, "tasks/${tasks.id}");
    var resp = await http.put(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(tasks.toJson()));
    var rs = usersFromJson("[${resp.body}]");
    if (rs.length == 1) {
      Navigator.pop(context, "refresh");
    }
  }
 
//addnewUser
  Future<void> addNewUser(tasks) async {
    var url = Uri.http(Configure.server, "tasks");
    var resp = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(tasks.toJson()));
    var rs = usersFromJson("[${resp.body}]");

    if (rs.length == 1) {
      Navigator.pop(context, "refresh");
    }
    return;
  }

//1
  Widget fnameInputField() {
    return TextFormField(
      initialValue: tasks.taskName,
      decoration:
          InputDecoration(labelText: "taskName:", icon: Icon(Icons.note_add)),
      validator: (value) {
        if (value!.isEmpty) {
          return "This field is required";
        }
        return null;
      },
      onSaved: (newValue) => tasks.taskName = newValue,
    );
  }

// email
  Widget emailInputField() {
    return TextFormField(
      initialValue: tasks.details,
      decoration: InputDecoration(labelText: "details", icon: Icon(Icons.details_rounded)),
      validator: (value) {
        if (value!.isEmpty) {
          return "This field is required";
        }
        if (!EmailValidator.validate(value)) {
          return "It is not email format";
        }
        return null;
      },
      onSaved: (newValue) => tasks.details = newValue,
    );
  }

// pasasword
  Widget passwordInputField() {
    return TextFormField(
      initialValue: tasks.date,
      decoration:
          InputDecoration(labelText: "date", icon: Icon(Icons.date_range)),
      validator: (value) {
        if (value!.isEmpty) {
          return "This field is required";
        }
        return null;
      },
      onSaved: (newValue) => tasks.date = newValue!,
    );
  }

  // button
  Widget submitButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formkey.currentState!.validate()) {
          _formkey.currentState!.save();
          print(tasks.toJson().toString());
          if (tasks.id == null) {
            addNewUser(tasks);
          } else {
            // updateData(tasks);
          }
        }
      },
      child: Text("Save"),
    );
  }

  @override
  Widget build(BuildContext context) { 
     try {
      print(tasks.details);
    } catch (e) {
      // tasks = Task();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Form"),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              fnameInputField(),
              emailInputField(),
              passwordInputField(),
              SizedBox(
                height: 10,
              ),
              submitButton()
            ], //to do
          ),
        ),
      ),
    );
  }
}





