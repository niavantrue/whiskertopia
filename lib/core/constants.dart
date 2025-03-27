import 'package:flutter/material.dart';

const String catApiBaseUrl = "https://api.thecatapi.com/v1/images/search";
const String catApiKey = "live_cTbxNCqs0QMKgVDNtmkJFfTXWsWKsxCkCyfJKO8yN64cuw4zk7avkXpF6ILGfg5E";

const Color primaryColor = Colors.orange;
const Color backgroundColor = Colors.white;
const Color textColor = Colors.black87;
const Color accentColor = Colors.orangeAccent;

const String defaultProfileImage = "assets/images/default_profile.png";

const int catApiFetchLimit = 10;

typedef AppTextStyle = TextStyle;

const AppTextStyle titleTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: textColor,
);

const AppTextStyle subtitleTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: Colors.grey,
);

const AppTextStyle bodyTextStyle = TextStyle(
  fontSize: 14,
  color: textColor,
);
