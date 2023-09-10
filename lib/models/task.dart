// To parse this JSON data, do
//
//     final task = taskFromJson(jsonString);

import 'dart:convert';

List<Task> taskFromJson(String str) => List<Task>.from(json.decode(str).map((x) => Task.fromJson(x)));

String taskToJson(List<Task> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Task {
    int? id;
    String? taskName;
    String? details;
    String? date;

    Task({
        this.id,
        this.taskName,
        this.details,
        this.date,
    });

    factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        taskName: json["taskName"],
        details: json["details"],
        date: json["date"] ,
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "taskName": taskName,
        "details": details,
        "date": date,
    };
}
