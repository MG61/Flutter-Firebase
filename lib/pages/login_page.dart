import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseauth/button/square_tile.dart';
import 'package:firebaseauth/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const LoginPage({Key? key, required this.showRegisterPage}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Контроллеры
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future signIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
    );



  //Избавляемся от контроллеров, когда ими не пользуемся
  @override
    void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

Future anonsignIn() async {
  final userCredential = await FirebaseAuth.instance.signInAnonymously();
}

  @override
  Widget build(BuildContext) {

    final String GitHub = 'assets/images/google.png';
    final String assetNamePath = 'assets/images/anon.png';
    AssetImage GitHubi = AssetImage(GitHub);
    AssetImage Anonym = AssetImage(assetNamePath);

    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Приветствие
                  Text(
                    "Авторизация",
                    style: GoogleFonts.bebasNeue(
                      fontWeight: FontWeight.bold,
                      fontSize: 36,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Добро пожаловать!",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),

                  // Ввод Email
                  SizedBox(height: 50),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(12)
                              // color: Colors.grey[200],
                              ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText: 'Почта',
                          fillColor: Colors.grey[200],
                          filled: true),
                    ),
                  ),

                  // Ввод пароля
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextField(
                      obscureText: true,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(12)
                            // color: Colors.grey[200],
                            ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: 'Пароль',
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                    ),
                  ),



                  // Кнопка входа
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: GestureDetector(
                      onTap: signIn,
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text("Войти",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              )),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey[400],
                            ),
                  ),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            "Другие способы входа",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        Expanded(
                            child:Divider(
                              thickness: 0.5,
                              color: Colors.grey[400],
                            ),
                        ),
                      ],
                    ),
                  ),

                  //Кнопка анонима
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      SquareTile(
                        onTap: () => AuthService().signInWithGoogle(),
                          imagePath: 'assets/images/google.png',

                      ),

                      SizedBox(width: 25),

                      SquareTile(
                        onTap: anonsignIn, imagePath: 'assets/images/anon.png'
                      ),
                    ],
                  ),

                  // Кнопка регистрации
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Забыл пароль? ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.showRegisterPage,
                        child: Text(
                          'Зарегистрироваться сейчас',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
