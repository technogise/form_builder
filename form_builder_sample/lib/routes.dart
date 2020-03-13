import 'package:flutter/cupertino.dart';
import 'widgets/screens/register.dart';

///Map of named routes
final Map<String, Widget Function(BuildContext)> routes = {
  RegistrationScreen.id: (context) => RegistrationScreen(),
};
