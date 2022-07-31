import 'package:currenccy_tracker_app/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  const PriceScreen({Key? key}) : super(key: key);

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

//   // int i = 0; i < currenciesList.length; i++
//   //  String currency = currenciesList[i];
class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'NGN';

  // List<DropdownMenuItem> getDropdownItems() {

  // }

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem> dropdownItems = [];

    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        value: currency,
        child: Text(currency),
      );

      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(
          () {
            selectedCurrency = value!;
            getData();
          },
        );
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];

    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }
    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getData();
        });
      },
      children: pickerItems,
    );
  }

  Map<String, String> coinValues = {};

  bool isWaiting = false;

  void getData() async {
    isWaiting = true;
    try {
      var data = await CoinData().getCOinData(selectedCurrency);

      isWaiting = false;
      setState(() {
        coinValues = data;
      });
    } catch (e) {
      print(e);
    }
  }

  // Widget getPicker() {
  //   if(Platform.isIOS) {
  //     return iOSPicker();
  //   }
  //   else if (Platform.isAndroid) {
  //     return getDropdownButton();
  //   }
  // }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // cryptoCard(
                //     value: isWaiting ? '?' : coinValues['NGN'],
                //     selectedCurrency: selectedCurrency,
                //     cryptoCurrency: 'NGN'),
                // cryptoCard(
                //     value: isWaiting ? '?' : coinValues['ETH'],
                //     selectedCurrency: selectedCurrency,
                //     cryptoCurrency: 'ETH'),
                // cryptoCard(
                //     value: isWaiting ? '?' : coinValues['LTC'],
                //     selectedCurrency: selectedCurrency,
                //     cryptoCurrency: 'LTC'),
              ],
            ),
            Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlue,
              child: Platform.isIOS ? iOSPicker() : androidDropdown(),
            ),
          ]),
    );
  }
}

cryptoCard(
        {required String value,
        required String selectedCurrency,
        required String cryptoCurrency}) =>
    Padding(
      padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
