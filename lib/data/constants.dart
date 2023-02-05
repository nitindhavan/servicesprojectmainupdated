import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

const dynamicomain='https://weserveu.page.link/';
/// PayPal
const clientId =
    'AVGtiwMxZ2GNfCHs1muKK6XsuU4DYhaSYINzwbX3h0bf_DeyIsAueRsSPkz2v2c3FuSb-MOyYe1NtDqU';
const secretKeyPayPal =
    'EM4xWt3w8ADZOT3rqkTg4PEmzpr_uq7acvWFfgK0M0YEm5MuLG3ukpObl37gE4J1iIcPk1sugDtg61XZ';

///payment description
const description = "The payment transaction description.";

///payment note
const note = "Payment is secured";

const publishableKey =
    'pk_test_51LJvBLSFKHX83G8gK5ZN9EEgLcoSi0oWGYwVxQ2uh1qmi4AFqZYNxgPcfCkHStqztNoM8VSzQ9Y3nyevnQkHjMFS001Pt5YR7U';
const secreteKeyStripe =
    'sk_test_51LJvBLSFKHX83G8g0SQeVpTAE5bKk77eEuRIBbPqiNQKioIqtcCUi7zIG59YoIkwqj8BNb2iwuqOjOroDVcD1MWZ00jRnahV9S';

///Razorpay
const razorPayKey = 'rzp_test_ecTTDxMyHXwvmK';
const razorPaySecrete = 'KG6JeeveF4WHkizXVr3D8vQg';

///wallet payment rules

///wallet balance will be credited from unique account with respected currencies
String walletReference = '/wallets';

///central bank reference is [walletReference]/[currency]/[centralWalletReference]
///every currency will have 1000000000 USD

const maxDollarsInWallet = 1000000000;

String get centralWalletReference => '$walletReference/$currency/centralWallet';

String get userWalletReference => '$walletReference/$currency/users';

///whenever client order something then its wallet balance [equivalent to product price] is transferred to central Wallet
///After completion of order this amount will be transferred to provider account

FirebaseDatabase get firebaseDatabase => FirebaseDatabase.instance;

String userReference = '/users';
String paymentReference = '/payment-credential';
String productsReferenceWithCurrency = '/products';
String cartReference = '/carts';
String orderReference = '/orders';
String locationReference = '/locations';

String addressReference = '/address';
Color baseColor = Colors.black;
Color highlightColor = Colors.blue;
Color childColor = Colors.black;

String currency = 'JOD';

final currencies = [
  {"name": "United Arab Emirates Dirham", "code": "AED"},
  {"name": "Albanian lek", "code": "ALL"},
  {"name": "Armenian dram", "code": "AMD"},
  {"name": "Argentine peso", "code": "ARS"},
  {"name": "Australian dollar", "code": "AUD"},
  {"name": "Aruban florin", "code": "AWG"},
  {"name": "Barbadian dollar", "code": "BBD"},
  {"name": "Bangladeshi taka", "code": "BDT"},
  {"name": "Bermudian dollar", "code": "BMD"},
  {"name": "Brunei dollar", "code": "BND"},
  {"name": "Bolivian boliviano", "code": "BOB"},
  {"name": "Bahamian dollar", "code": "BSD"},
  {"name": "Botswana pula", "code": "BWP"},
  {"name": "Belize dollar", "code": "BZD"},
  {"name": "Canadian dollar", "code": "CAD"},
  {"name": "Swiss franc", "code": "CHF"},
  {"name": "Chinese yuan renminbi", "code": "CNY"},
  {"name": "Colombian peso", "code": "COP"},
  {"name": "Costa Rican colon", "code": "CRC"},
  {"name": "Cuban peso", "code": "CUP"},
  {"name": "Czech koruna", "code": "CZK"},
  {"name": "Danish krone", "code": "DKK"},
  {"name": "Dominican peso", "code": "DOP"},
  {"name": "Algerian dinar", "code": "DZD"},
  {"name": "Egyptian pound", "code": "EGP"},
  {"name": "Ethiopian birr", "code": "ETB"},
  {"name": "European euro", "code": "EUR"},
  {"name": "Fijian dollar", "code": "FJD"},
  {"name": "Pound sterling", "code": "GBP"},
  {"name": "Ghanian Cedi", "code": "GHS"},
  {"name": "Gibraltar pound", "code": "GIP"},
  {"name": "Gambian dalasi", "code": "GMD"},
  {"name": "Guatemalan quetzal", "code": "GTQ"},
  {"name": "Guyanese dollar", "code": "GYD"},
  {"name": "Hong Kong dollar", "code": "HKD"},
  {"name": "Honduran lempira", "code": "HNL"},
  {"name": "Croatian kuna", "code": "HRK"},
  {"name": "Haitian gourde", "code": "HTG"},
  {"name": "Hungarian forint", "code": "HUF"},
  {"name": "Indonesian rupiah", "code": "IDR"},
  {"name": "Israeli new shekel", "code": "ILS"},
  {"name": "Indian rupee", "code": "INR"},
  {"name": "Jamaican dollar", "code": "JMD"},
  {"name": "Kenyan shilling", "code": "KES"},
  {"name": "Kyrgyzstani som", "code": "KGS"},
  {"name": "Cambodian riel", "code": "KHR"},
  {"name": "Cayman Islands dollar", "code": "KYD"},
  {"name": "Kazakhstani tenge", "code": "KZT"},
  {"name": "Lao kip", "code": "LAK"},
  {"name": "Lebanese pound", "code": "LBP"},
  {"name": "Sri Lankan rupee", "code": "LKR"},
  {"name": "Liberian dollar", "code": "LRD"},
  {"name": "Lesotho loti", "code": "LSL"},
  {"name": "Moroccan dirham", "code": "MAD"},
  {"name": "Moldovan leu", "code": "MDL"},
  {"name": "Macedonian denar", "code": "MKD"},
  {"name": "Myanmar kyat", "code": "MMK"},
  {"name": "Mongolian tugrik", "code": "MNT"},
  {"name": "Macanese pataca", "code": "MOP"},
  {"name": "Mauritian rupee", "code": "MUR"},
  {"name": "Maldivian rufiyaa", "code": "MVR"},
  {"name": "Malawian kwacha", "code": "MWK"},
  {"name": "Mexican peso", "code": "MXN"},
  {"name": "Malaysian ringgit", "code": "MYR"},
  {"name": "Namibian dollar", "code": "NAD"},
  {"name": "Nigerian naira", "code": "NGN"},
  {"name": "Nicaraguan cordoba", "code": "NIO"},
  {"name": "Norwegian krone", "code": "NOK"},
  {"name": "Nepalese rupee", "code": "NPR"},
  {"name": "New Zealand dollar", "code": "NZD"},
  {"name": "Peruvian sol", "code": "PEN"},
  {"name": "Papua New Guinean kina", "code": "PGK"},
  {"name": "Philippine peso", "code": "PHP"},
  {"name": "Pakistani rupee", "code": "PKR"},
  {"name": "Qatari riyal", "code": "QAR"},
  {"name": "Russian ruble", "code": "RUB"},
  {"name": "Saudi Arabian riyal", "code": "SAR"},
  {"name": "Seychellois rupee", "code": "SCR"},
  {"name": "Swedish krona", "code": "SEK"},
  {"name": "Singapore dollar", "code": "SGD"},
  {"name": "Sierra Leonean leone", "code": "SLL"},
  {"name": "Somali shilling", "code": "SOS"},
  {"name": "South Sudanese pound", "code": "SSP"},
  {"name": "Salvadoran colón", "code": "SVC"},
  {"name": "Swazi lilangeni", "code": "SZL"},
  {"name": "Thai baht", "code": "THB"},
  {"name": "Trinidad and Tobago dollar", "code": "TTD"},
  {"name": "Tanzanian shilling", "code": "TZS"},
  {"name": "United States dollar", "code": "USD"},
  {"name": "Uruguayan peso", "code": "UYU"},
  {"name": "Uzbekistani so'm", "code": "UZS"},
  {"name": "Yemeni rial", "code": "YER"},
  {"name": "South African rand", "code": "ZAR"}
];
