import 'package:flutter/material.dart';
import 'package:vpmobil_wrapper/main.dart';
import 'package:vpmobil_wrapper/theme.dart';

void hideSnackBarIfVisible() {
  final messengerState = rootScaffoldMessengerKey.currentState;

  if (messengerState != null) {
    messengerState.hideCurrentSnackBar(); 
  }
}

void showNetworkErrorSnackBar() {
  hideSnackBarIfVisible();

  rootScaffoldMessengerKey.currentState?.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.up,
      margin: EdgeInsets.only(
        bottom: 15,
        left: 15,
        right: 15,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(Icons.wifi_off_rounded, color: Colors.red, size: 30),
          Text(
            'Es gab ein Problem beim\nVerbindungsaufbau zum Server',
            style: TextStyle(
              color: Colors.red,
              fontFamily: "Space Grotesk"
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      duration: Duration(seconds: 2),
      backgroundColor: Color.fromARGB(255, 15, 15, 15),
    ),
  );
}

void showErrorNoDataSnackbar() {
  hideSnackBarIfVisible();
  final theme = Theme.of(rootScaffoldMessengerKey.currentState!.context).extension<AppColors>()!;

  rootScaffoldMessengerKey.currentState?.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.horizontal,
      margin: EdgeInsets.only(
        bottom: 30,
        left: 30,
        right: 30,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(Icons.error_outlined , color: Colors.orange, size: 30),
          Text(
            'Es gibt noch keine Daten\nBitte aktualisiere den Plan',
            style: TextStyle(
              color: Colors.orange,
              fontSize: 14,
              fontFamily: "Geist"
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      duration: Duration(seconds: 2),
      backgroundColor: theme.component,
    ),
  );
}

void showErrorLoadingClassesSnackbar() {
  hideSnackBarIfVisible();
  
  rootScaffoldMessengerKey.currentState?.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.up,
      margin: EdgeInsets.only(
        bottom: 15,
        left: 15,
        right: 15,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(Icons.warning_rounded , color: Colors.orange, size: 30),
          Text(
            'Fehler beim Laden der Daten',
            style: TextStyle(
              color: Colors.orange,
              fontFamily: "Space Grotesk"
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      duration: Duration(seconds: 2),
      backgroundColor: Color.fromARGB(255, 15, 15, 15),
    ),
  );
}

void showGeneralErrorSnackBar() {
  hideSnackBarIfVisible();
  
  rootScaffoldMessengerKey.currentState?.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.up,
      margin: EdgeInsets.only(
        bottom: 15,
        left: 15,
        right: 15,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(Icons.warning_rounded , color: Colors.orange, size: 30),
          Text(
            'Es gab einen Fehler',
            style: TextStyle(
              color: Colors.orange,
              fontFamily: "Space Grotesk"
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      duration: Duration(seconds: 2),
      backgroundColor: Color.fromARGB(255, 15, 15, 15),
    ),
  );
}