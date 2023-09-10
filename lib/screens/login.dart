import 'package:task/models/config.dart';
import 'package:task/models/users.dart';
import 'package:task/screens/home.dart';
import 'package:task/screens/userform.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  static const rountName = "/login";
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

Widget textHeaderWithImage() {
  return Row(
    children: [
      Container(
        margin: const EdgeInsets.only(top: 50.0, bottom: 20.0, left: 20.0),
        alignment: Alignment.center,
        child: ClipOval(
          child: Container(
            width: 100.0, // ปรับขนาดของวงกลมตามต้องการ
            height: 100.0, // ปรับขนาดของวงกลมตามต้องการ
            color: Colors.blue, // สีของวงกลมหรือลากไปเปลี่ยนรูปภาพ
            child: Center(
              child: Image.network(
                'https://cdn.pic.in.th/file/picinth/icon-5577198_1280.png', // รูปภาพของคุณ
                width: 80.0, // ปรับขนาดของรูปภาพในวงกลมตามต้องการ
                height: 80.0, // ปรับขนาดของรูปภาพในวงกลมตามต้องการ
                fit: BoxFit.cover, // ปรับขนาดรูปภาพให้พอดีกับวงกลม
              ),
            ),
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(top: 50.0, bottom: 20.0, left: 30.0),
        alignment: Alignment.bottomCenter,
        child: Text(
          "TO Do List",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  );
}

// login
class _LoginState extends State<Login> {
  final _formkey = GlobalKey<FormState>();
  Users user = Users();

  Future<void> login(Users user) async {
    var params = {"email": user.email, "password": user.password};
    var url = Uri.http(Configure.server, "users", params);
    var resp = await http.get(url);

    if (resp.statusCode == 200) {
      // The request was successful.
      List<Users> loginResult = usersFromJson(resp.body);
      print(loginResult.length);
      if (loginResult.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("username or password invalid")));
      } else {
        Configure.login = loginResult[0];
        Navigator.pushNamed(context, HOME.routeName);
      }
    } else {
      // The request failed.
      print(resp.statusCode);
      print(resp.body);
    }

    return;
  }

// email
  Widget emailInputField() {
    return TextFormField(
      initialValue:
          "p@gmail.com", // ตั้งค่าค่าเริ่มต้นให้กับ email field ที่นี่
      decoration: InputDecoration(
        labelText: "Email",
        icon: Icon(Icons.email),
        alignLabelWithHint: true,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "This field is required";
        }
        if (!EmailValidator.validate(value)) {
          return "It is not email format";
        }
        return null;
      },
      onSaved: (newValue) => user.email = newValue!,
    );
  }

// pasasword
  Widget passwordInputField() {
    return TextFormField(
      initialValue: "12345",
      decoration:
          const InputDecoration(labelText: "password", icon: Icon(Icons.lock)),
      validator: (value) {
        if (value!.isEmpty) {
          return "This field is required";
        }
        return null;
      },
      onSaved: (newValue) => user.password = newValue!,
    );
  }

// back
  Widget BackButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(
            context,
            MaterialPageRoute(
              builder: (context) => const HOME(),
            ));
      },
      child: const Text("Back"),
    );
  }

// link
  Widget registerLink() {
    return InkWell(
      child: Text(
        "Register",
        style: TextStyle(
          fontWeight: FontWeight.bold, // ตั้งค่าตัวหนา
        ),
      ),
      onTap: () async {
        String result = await Navigator.push(
            context, MaterialPageRoute(builder: (context) => const UserForm()));
      },
    );
  }

  // button
  Widget submitButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formkey.currentState!.validate()) {
          _formkey.currentState!.save();
          print(user.toJson().toString());
          login(user);
        }
      },
      child: const Text("Login"),
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(
            Size(200.0, 50.0)), // ปรับขนาดของปุ่มที่นี่
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(10.0),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 50.0, bottom: 20.0),
                  child: textHeaderWithImage(),
                ),
              ),
              emailInputField(),
              passwordInputField(),
              const SizedBox(
                height: 10.0,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: submitButton(),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: Row(
                          children: [
                            Text("Don't have an account?"),
                            SizedBox(
                                width:
                                    5.0), // เพิ่มระยะห่างระหว่างข้อความและ Register Link
                            registerLink(),
                            // BackButton(),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
