import 'package:flutter/material.dart';
import '../../contstants.dart' as Constants;
import '../../sharedServices/Auth.dart';
import '../../widgets/InputText.dart';
import '../../widgets/InputButton.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Register extends StatefulWidget {
  Register() : super();

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<Register> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  String emailValidationResult;
  String errorMessage;
  bool showLogin = false;
  bool showRegister = false;
  bool showMenu = true;
  bool registering = false;

  signIn() async {
    if (emailController.text == null ||
        emailController.text.isEmpty ||
        passwordController.text == null ||
        passwordController.text.isEmpty) {
      setState(() {
        errorMessage = 'Complete fields';
      });
      return;
    }
    setState(() {
      registering = true;
      errorMessage = null;
    });
    FocusScope.of(context).requestFocus(new FocusNode());
    AuthContainerState auth = AuthContainer.of(context);
    String res = await auth.login(
        emailController.text, passwordController.text, context);
    if (res != 'ok') {
      setState(() {
        registering = false;
        errorMessage = res;
      });
    } else {
      FlutterSecureStorage storage = new FlutterSecureStorage();

      String identityToken = await storage.read(key: 'idToken');
      String refreshTokenExpiration = await storage.read(key: 'refreshTokenExpiration');
      Navigator.of(context).pushNamedAndRemoveUntil(
          Constants.HOME, (Route<dynamic> route) => false, arguments: {'identityToken': identityToken, 'refreshTokenExpiration' :refreshTokenExpiration});
    }
  }

  signUp() async {
    String firstName = firstNameController.text;
    String lastName = lastNameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    bool formComplete = firstName.isNotEmpty &&
        lastName.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        password == confirmPassword;
    if (!formComplete) {
      setState(() {
        errorMessage = 'Complete fields';
      });
      return;
    }
    setState(() {
      registering = true;
      errorMessage = null;
    });
    FocusScope.of(context).requestFocus(new FocusNode());
    AuthContainerState data = AuthContainer.of(context);
    String res = await data.register(firstNameController.text,
        lastNameController.text, emailController.text, passwordController.text);
    if (res == 'ok') {
      FlutterSecureStorage storage = new FlutterSecureStorage();
      await storage.deleteAll();
      Navigator.of(context).pushNamedAndRemoveUntil(
          Constants.REGISTER, (Route<dynamic> route) => false);
    } else {
      setState(() {
        registering = false;
        errorMessage = res;
      });
    }
  }

  showLogInForm() {
    setState(() {
      showMenu = false;
      showRegister = false;
      showLogin = true;
    });
  }

  showRegisterForm() {
    setState(() {
      showMenu = false;
      showLogin = false;
      showRegister = true;
    });
  }

  back() {
    setState(() {
      showMenu = true;
      showLogin = false;
      showRegister = false;
      errorMessage = null;
    });
  }

  validateEmail(email) {
    String validationResult = 'Invalid email';
    if (email != null) {
      var parts = email.split('@');
      if (parts.length == 2 && parts[0].length > 0 && parts[1].length > 3) {
        var domain = parts[1].split('.');
        if (domain.length > 1 && domain[0].length > 0 && domain[1].length > 0) {
          validationResult = null;
        }
      }
    }
    setState(() {
      emailValidationResult = validationResult;
    });
  }

  Widget buildMenu() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          IconData(0xe547, fontFamily: 'MaterialIcons'),
          size: 50,
          color: Colors.white,
        ),
        Text(
          "Pantry Pal",
          style: TextStyle(
              fontSize: 30,
              fontFamily: 'Helvetica',
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        InputButton("Sign In", showLogInForm, Colors.white),
        InputButton("Sign Up", showRegisterForm, Colors.white)
      ],
    );
  }

  Widget buildLoginForm() {
    List<Widget> formChildren = [
      Icon(
        IconData(0xe547, fontFamily: 'MaterialIcons'),
        size: 50,
        color: Colors.white,
      ),
      Text(
        "Pantry Pal",
        style: TextStyle(
            fontSize: 30,
            fontFamily: 'Helvetica',
            fontWeight: FontWeight.bold,
            color: Colors.white),
      ),
      InputText(
        controller: emailController,
        hint: 'your@email.com',
        label: 'Email',
        onChange: (email) => validateEmail(email),
        error: emailValidationResult,
      ),
      SizedBox(
        height: 10,
      ),
      InputText(
        controller: passwordController,
        hint: 'Ic3 Cre4m L0ck',
        label: 'Password',
        password: true,
      )
    ];

    if (registering) {
      formChildren.add(SizedBox(
        height: 10,
      ));
      formChildren.add(CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white)));
    } else {
      formChildren.add(InputButton("Sign In", signIn, Colors.white));
      formChildren.add(InputButton("Back", back, Colors.white));
    }
    if (errorMessage != null) {
      formChildren.insert(
          0,
          Text(
            errorMessage,
            style: TextStyle(
                fontSize: 15,
                fontFamily: 'Helvetica',
                fontWeight: FontWeight.bold,
                color: Colors.red),
          ));
    }
    return Column(mainAxisSize: MainAxisSize.min, children: formChildren);
  }

  Widget buildRegisterForm() {
    List<Widget> formChildren = [
      Icon(
        IconData(0xe547, fontFamily: 'MaterialIcons'),
        size: 50,
        color: Colors.white,
      ),
      Text(
        "Pantry Pal",
        style: TextStyle(
            fontSize: 30,
            fontFamily: 'Helvetica',
            fontWeight: FontWeight.bold,
            color: Colors.white),
      ),
      InputText(
        controller: firstNameController,
        hint: 'Alex',
        label: 'First Name',
      ),
      SizedBox(
        height: 10,
      ),
      InputText(
        controller: lastNameController,
        hint: 'Smith',
        label: 'Last Name',
      ),
      SizedBox(
        height: 10,
      ),
      InputText(
        controller: emailController,
        hint: 'your@email.com',
        label: 'Email',
        onChange: (email) => validateEmail(email),
        error: emailValidationResult,
      ),
      SizedBox(
        height: 10,
      ),
      InputText(
        controller: passwordController,
        hint: 'Ic3 Cre4m L0ck',
        label: 'Password',
        password: true,
      ),
      SizedBox(
        height: 10,
      ),
      InputText(
        controller: confirmPasswordController,
        label: 'Confirm Password',
        password: true,
      )
    ];

    if (registering) {
      formChildren.add(SizedBox(
        height: 10,
      ));
      formChildren.add(CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white)));
    } else {
      formChildren.add(InputButton("Sign Up", signUp, Colors.white));
      formChildren.add(InputButton("Back", back, Colors.white));
    }
    if (errorMessage != null) {
      formChildren.insert(
          0,
          Text(
            errorMessage,
            style: TextStyle(
                fontSize: 15,
                fontFamily: 'Helvetica',
                fontWeight: FontWeight.bold,
                color: Colors.red),
          ));
    }
    return Column(children: formChildren);
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (showMenu) {
      child = buildMenu();
    } else if (showLogin) {
      child = buildLoginForm();
    } else if (showRegister) {
      child = buildRegisterForm();
    }

    return (
      Container(
        decoration: BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
                image: AssetImage('assets/spices.jpg'),
                fit: BoxFit.cover,
                colorFilter: new ColorFilter.mode(
                    Colors.transparent.withOpacity(.8), BlendMode.dstATop))),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            alignment: Alignment.center,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[Container(
                child: Padding(
                  padding: EdgeInsets.only(left:MediaQuery.of(context).size.width * .1, right:MediaQuery.of(context).size.width * .1),
                  child: child
                ),
              )
              ])
          )
        )
      )
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }
}