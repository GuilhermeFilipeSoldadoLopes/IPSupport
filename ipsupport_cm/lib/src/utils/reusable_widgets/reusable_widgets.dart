import 'package:flutter/material.dart';

/// The function returns an image widget with the specified image name, fit, width, and height.
///
/// Args:
///   imageName (String): The imageName parameter is a string that represents the name or path of the
/// image file that you want to display as a logo.
///
/// Returns:
///   an Image widget.
Image logoWidget(String imageName) {
  return Image.asset(imageName,
      fit: BoxFit.fitWidth, width: 385.5, height: 180);
}

/// The function `reusableTextField` returns a TextField widget with customizable properties such as
/// text, icon, password type, and controller.
///
/// Args:
///   text (String): The text parameter is a string that represents the label text for the TextField. It
/// is displayed above the input field to provide a description or prompt to the user.
///   icon (IconData): The icon parameter is of type IconData and represents the icon to be displayed as
/// the prefix icon in the TextField.
///   isPasswordType (bool): A boolean value indicating whether the TextField should be of password type
/// or not. If true, the TextField will obscure the entered text. If false, the TextField will accept
/// regular text input.
///   controller (TextEditingController): A TextEditingController object that will be used to control
/// the text entered in the TextField.
///
/// Returns:
///   a TextField widget.
TextField reusableTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.black,
    style: TextStyle(color: Colors.black.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.black,
      ),
      labelText: text,
      labelStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.grey.withOpacity(0.3),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}

/// The function `firebaseUIButton` returns a container with an elevated button that has a specified
/// title, onTap function, and styling.
///
/// Args:
///   context (BuildContext): The `BuildContext` is a required parameter in Flutter that represents the
/// location in the widget tree where the container is being built. It is used to access the size and
/// other properties of the current widget's parent.
///   title (String): The title parameter is a string that represents the text to be displayed on the
/// button. It is used as the child of the Text widget inside the ElevatedButton widget.
///   onTap (Function): The `onTap` parameter is a function that will be called when the button is
/// pressed. It is a callback function that you can define and pass to the `firebaseUIButton` function.
///
/// Returns:
///   a Container widget with an ElevatedButton as its child.
Container firebaseUIButton(BuildContext context, String title, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      child: Text(
        title,
        style: const TextStyle(
            color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return Colors.white;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
    ),
  );
}

/// The function `validateEmail` checks if a given email address is valid and returns an error message
/// if it is not.
///
/// Args:
///   formEmail (String): The parameter `formEmail` is a nullable String that represents an email
/// address entered in a form.
///
/// Returns:
///   a String value. If the formEmail is null or empty, it returns the message "Email necessário." If
/// the formEmail does not match the specified email pattern, it returns the message "Formato de Email
/// inválido." If the formEmail is valid, it returns null.
String? validateEmail(String? formEmail) {
  if (formEmail == null || formEmail.isEmpty) return 'Email necessário.';

  String pattern = r'\w+@\w+\.\w+';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formEmail)) return 'Formato de Email inválido.';

  return null;
}

/// The function `validatePassword` checks if a given password meets certain criteria and returns an
/// error message if it doesn't.
///
/// Args:
///   formPassword (String): The formPassword parameter is a nullable String that represents the
/// password entered by the user in a form.
///
/// Returns:
///   a String value. If the formPassword is null or empty, it returns the message "Password
/// necessária." If the formPassword does not meet the specified pattern requirements, it returns the
/// message "A Password deverá ter 8 caracteres, um número, uma letra maiúscula e uma minúscula." If the
/// formPassword is valid, it returns null.
String? validatePassword(String? formPassword) {
  if (formPassword == null || formPassword.isEmpty) {
    return 'Password necessária.';
  }

  String pattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formPassword)) {
    return 'A Password deverá ter 8 caracteres, um número, uma letra maiúscula e uma minúscula.';
  }

  return null;
}
