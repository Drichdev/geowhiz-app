import 'package:flutter/material.dart';

Text smallTextBlack(String text) {
  return Text(
    text,
    style: const TextStyle(
        fontSize: 12,
        fontFamily: 'SpaceMono',
        color: Colors.black,
        fontWeight: FontWeight.bold),
  );
}

Text smallTextBlackCompl(
    String text, Color col, double mysize, FontWeight myfontweight) {
  return Text(
    text,
    style: TextStyle(
        fontSize: mysize,
        fontFamily: 'SpaceMono',
        color: col,
        fontWeight: myfontweight),
  );
}

Text mediumTextBlack(String text) {
  return Text(
    text,
    style: const TextStyle(
        fontSize: 20,
        fontFamily: 'SpaceMono',
        color: Colors.black,
        fontWeight: FontWeight.bold),
  );
}

Text bigTextBlack(String text) {
  return Text(
    text,
    style: const TextStyle(
        fontSize: 40,
        fontFamily: 'SpaceMono',
        color: Colors.black,
        fontWeight: FontWeight.bold),
  );
}
