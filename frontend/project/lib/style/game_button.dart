import 'package:flutter/material.dart';

final gameButton = ElevatedButton.styleFrom(
  foregroundColor: Colors.grey,
  backgroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20.0),
    side: BorderSide(color: Colors.brown, width: 2)
  ),
  elevation: 3,
  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
);

final communtyButton = ElevatedButton.styleFrom(
  backgroundColor: Colors.white,
  shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
      // side: BorderSide(color: Colors.black, width: 3)
  ),
  elevation: 3,
  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
);

final godoActive =TextStyle(
    color: Colors.black, fontFamily: 'godo', fontSize: 30
);

final godoUnactive =TextStyle(
    color: Colors.grey, fontFamily: 'godo', fontSize:30
);