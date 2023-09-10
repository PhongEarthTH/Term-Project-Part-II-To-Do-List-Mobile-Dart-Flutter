import 'package:task/models/config.dart';
import 'package:task/models/users.dart';
import 'package:task/models/task.dart';
import 'package:task/screens/login.dart';
import 'package:task/screens/userform.dart';
import 'package:task/screens/userinfo.dart';
import 'package:task/screens/taskform.dart';
// import 'package:task/screens/taskinfo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HOME extends StatefulWidget {
  static const routeName = '/';
  const HOME({super.key});

  @override
  State<HOME> createState() => _HOMEState();
}

class _HOMEState extends State<HOME> {
  Widget mainBody = Container();
  List<Task> _taskList = [];

  Future<void> getTasks() async {
    var url = Uri.http(Configure.server, "tasks");
    var resp = await http.get(url);
    setState(() {
      _taskList = taskFromJson(resp.body);
      mainBody = showTasks();
    });
  }

  List<Users> _userList = [];

  Future<void> getUsers() async {
    var url = Uri.http(Configure.server, "users");
    var resp = await http.get(url);
    setState(() {
      _userList = usersFromJson(resp.body);
      mainBody = showUsers();
    });
    return;
  }

  // delete
  Future<void> removeUsers(user) async {
    var url = Uri.http(Configure.server, "users/${user.id}");
    var resp = await http.delete(url);
    print(resp.body);
    return;
  }

// initstate
  @override
  void initState() {
    super.initState();
    getTasks();
    Users user = Configure.login;
    if (user.id != null) {
      getUsers();
    }
  }

  Widget showTasks() {
    return ListView.builder(
      itemCount: _taskList.length,
      itemBuilder: (context, index) {
        Task task = _taskList[index];
        return GestureDetector(
          onTap: () {
            // Handle the click action for the task here
            // For example, you can navigate to a task details page.
            // Replace the following line with your desired action.
            print("Task clicked: ${task.taskName}");
          },
          child: ListTile(
            title: Text("${task.taskName}"),
            subtitle: Text("${task.details}"),
            // You can customize how you want to display task details here.
          ),
        );
      },
    );
  }

// welcome
  Widget welcome() {
    return Container(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 100.0),
            alignment: Alignment.center,
            child: ClipOval(
              child: Container(
                width: 150.0,
                height: 150.0,
                color: Colors.blue,
                child: Center(
                  child: Image.network(
                    'https://cdn.pic.in.th/file/picinth/icon-5577198_1280.png',
                    width: 80.0,
                    height: 80.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
                top: 20.0), // เปลี่ยนระยะห่างด้านบนเป็น 20.0
            child: const Text(
              "TODO List",
              style: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
                top: 10.0, bottom: 60.0), // เปลี่ยนระยะห่างด้านบนเป็น 20.0
            child: const Text(
              "Description",
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, Login.rountName);
              },
              child: const Text("Login"),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(
                  Size(200.0, 50.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // showUsers
  Widget showUsers() {
    return ListView.builder(
      itemCount: _userList.length,
      itemBuilder: (context, index) {
        Users users = _userList[index];
        return Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.endToStart,
          child: Card(
            child: ListTile(
              title: Text("${users.fullname}"),
              subtitle: Text("${users.email}"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserInfo(),
                        settings: RouteSettings(arguments: users)));
              }, //to show info
              trailing: IconButton(
                onPressed: () async {
                  String result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserForm(),
                          settings: RouteSettings(arguments: users)));
                  if (result == "refresh") {
                    getUsers();
                  }
                }, // to edit
                icon: Icon(Icons.edit),
              ),
            ),
          ),
          onDismissed: (direction) {
            removeUsers(users);
          }, //to delete,
          background: Container(
            color: Colors.red,
            margin: EdgeInsets.symmetric(horizontal: 15),
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

// mainWidget
  @override
  Widget build(BuildContext context) {
    if (Configure.login.id != null) {
      // If logged in, show the main content
      return Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
        ),
        drawer: const SideMenu(),
        body: showTasks(), // Show the main content for logged-in users
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            String result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const taskfrompage())); // Navigate to TaskForm
            if (result == "refresh") {
              getTasks(); // Reload tasks if needed
            }
          },
          child: const Icon(Icons.add),
        ),
      );
    } else {
      // If not logged in, show the "Welcome" content
      return Scaffold(
        appBar: AppBar(
          title: const Text("Welcome"),
        ),
        body: welcome(), // Show the "Welcome" content for non-logged-in users
      );
    }
  }
}

Widget showUsers() {
  // เรียกใช้ FutureBuilder เพื่อดึงข้อมูลผู้ใช้
  return FutureBuilder<List<Users>>(
    future:
        fetchUsers(), // เรียกใช้ฟังก์ชัน fetchUsers ที่คุณต้องสร้างเพื่อดึงข้อมูลผู้ใช้
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        // แสดงรายการโหลดข้อมูล
        return CircularProgressIndicator();
      } else if (snapshot.hasError) {
        // แสดงข้อความเมื่อเกิดข้อผิดพลาด
        return Text('Error: ${snapshot.error}');
      } else {
        // แสดงรายการผู้ใช้เมื่อโหลดข้อมูลสำเร็จ
        List<Users> users = snapshot.data!;
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            Users user = users[index];
            return ListTile(
              title: Text("${user.fullname}"),
              subtitle: Text("${user.email}"),
              onTap: () {
                // ทำสิ่งที่คุณต้องการเมื่อคลิกผู้ใช้
                // เช่น แสดงรายละเอียดผู้ใช้
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserInfo(),
                    settings: RouteSettings(arguments: user),
                  ),
                );
              },
            );
          },
        );
      }
    },
  );
}

// สร้างฟังก์ชัน fetchUsers เพื่อดึงข้อมูลผู้ใช้
Future<List<Users>> fetchUsers() async {
  var url = Uri.http(Configure.server, "users");
  var resp = await http.get(url);
  if (resp.statusCode == 200) {
    return usersFromJson(resp.body);
  } else {
    throw Exception('Failed to load users');
  }
}

// Less

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    String accountName = 'N/A';
    String accountEmail = 'N/A';
    String accountUrl =
        'https://instagram.furt3-1.fna.fbcdn.net/v/t51.2885-19/328970434_144791398442933_9145920708887023430_n.jpg?stp=dst-jpg_s150x150&_nc_ht=instagram.furt3-1.fna.fbcdn.net&_nc_cat=105&_nc_ohc=rI5GFrwOxjoAX-eBtr6&edm=ACWDqb8BAAAA&ccb=7-5&oh=00_AfDcYt011kwkQX4xeHa6-OfXrur6x02yMQ8wNk9UuL8a2Q&oe=64F19D0F&_nc_sid=ee9879';

    Users user = Configure.login;
    if (user.id != null) {
      accountName = user.fullname!;
      accountEmail = user.email!;
    }
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(accountName),
            accountEmail: Text(accountEmail),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(accountUrl),
              backgroundColor: Colors.white,
            ),
          ),
          ListTile(
            title: Text("Users"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Scaffold(
                      appBar: AppBar(
                        title: Text("All Users"),
                      ),
                      body: showUsers(), // Show all users here
                    );
                  },
                ),
              );
            },
          ),
          ListTile(
            title: Text("Tasks"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return HOME();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
