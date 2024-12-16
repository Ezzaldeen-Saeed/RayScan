import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color primaryColor = Color(0xFF2C82A7);
const Color secondaryColor = Colors.grey;
const Color textColorLightMode = Colors.black;
const Color textColorDarkMode = Colors.white;
const Color darkModeBG1 = Color(0xFF1e1f22);
const Color darkModeBG2 = Color(0xff303137);
const Color lightModeBG1 = Color(0xffffffff);
const Color lightModeBG2 = Color(0xff787575);
const Color successSnackBarBG = Colors.green;
const Color errorSnackBarBG = Colors.red;
const Color warningSnackBarBG = Colors.orange;
const Color infoSnackBarBG = Colors.blue;
const Color cardDisease1 = Color.fromRGBO(233, 215, 255, 1);
const Color cardDisease2 = Color.fromRGBO(255, 215, 215, 1);
const Color cardDisease3 = Color.fromRGBO(215, 255, 215, 1);
const Color cardDisease4 = Color.fromRGBO(215, 215, 255, 1);
const Color cardDisease5 = Color.fromRGBO(255, 255, 215, 1);

const Color textFieldBGColor = Color(0xFFDCEAFA);
const Color unselectedButton = Color(0xFFBDD7E5);

//--------------------------------------------------- Fonts / Font Sizes ---------------------------------------------------

const double fontSizeTitle = 24;
const double fontSizeSubTitle = 20;
const double fontSizeText = 16;
const double fontSizeDetails = 12;

const FontWeight fontWeightLight = FontWeight.w300;
const FontWeight fontWeightMedium = FontWeight.w500;
const FontWeight fontWeightSimiBold = FontWeight.w600;

String fontFamily = 'League Spartassn';

CustomText(String text, double Type, {Color? color}) {
  // Type 1 = Title,
  // Type 2 = SubTitle,
  // Type 3 = Text
  switch (Type) {
    case 1:
      return Text(
        text
            .split(' ')
            .map((word) => word[0].toUpperCase() + word.substring(1))
            .join(' '),
        style: GoogleFonts.leagueSpartan(
          textStyle: TextStyle(
            fontSize: fontSizeTitle,
            fontWeight: fontWeightSimiBold,
            fontFamily: fontFamily,
            color: color ?? primaryColor,
          ),
        ),
      );
    case 1.1:
      return Text(
        text
            .split(' ')
            .map((word) => word[0].toUpperCase() + word.substring(1))
            .join(' '),
        style: GoogleFonts.leagueSpartan(
          textStyle: TextStyle(
            fontSize: fontSizeTitle,
            fontWeight: fontWeightSimiBold,
            fontFamily: fontFamily,
            color: color ?? primaryColor,
          ),
        ),
      );
    case 1.2:
      return Text(
        text
            .split(' ')
            .map((word) => word[0].toUpperCase() + word.substring(1))
            .join(' '),
        style: GoogleFonts.leagueSpartan(
          textStyle: TextStyle(
            fontSize: fontSizeTitle,
            fontWeight: fontWeightMedium,
            fontFamily: fontFamily,
            color: color ?? primaryColor,
          ),
        ),
      );
    case 2:
      return Text(text,
          style: TextStyle(
            fontSize: fontSizeSubTitle,
            fontWeight: fontWeightMedium,
            fontFamily: fontFamily,
            color: color ?? primaryColor,
          ));
    case 2.1:
      return Text(text,
          style: TextStyle(
            fontSize: fontSizeSubTitle,
            fontWeight: fontWeightMedium,
            fontFamily: fontFamily,
            color: color ?? primaryColor,
          ));
    case 3:
      return Text(text,
          style: TextStyle(
            fontSize: fontSizeText,
            fontWeight: fontWeightLight,
            fontFamily: fontFamily,
            color: color ?? primaryColor,
          ));
  }
}

IconText(String text, {required int size}) {
  return Text(
    text
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' '),
    style: GoogleFonts.luckiestGuy(
      textStyle: TextStyle(
        fontSize: size.toDouble(),
        fontWeight: fontWeightSimiBold,
        fontFamily: fontFamily,
        color: primaryColor,
      ),
    ),
  );
}
