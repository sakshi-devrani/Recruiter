import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobfinder/language/languageController[1].dart';

class LanguageDialog extends StatelessWidget {
  final LanguageController translationController =
      Get.put(LanguageController());
  @override
  LanguageDialog({super.key});

  @override
  Widget build(BuildContext context) {
    String selectedLanguage = translationController.selectedLanguage.value;

    return AlertDialog(
      backgroundColor: Color.fromARGB(255, 213, 233, 237),
      title: Text("language".tr), // Use 'title' from translations
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return SizedBox(
            height: 120,
            child: Column(
              children: [
                ListTile(
                  title: Text('English'.tr),
                  leading: Radio(
                    activeColor: Color.fromARGB(255, 85, 143, 151),
                    autofocus: true,
                    value: 'en_US',
                    groupValue: selectedLanguage,
                    onChanged: (value) {
                      setState(() {
                        selectedLanguage = value.toString();
                      });
                    },
                  ),
                ),
                ListTile(
                  title: Text('हिन्दी'.tr), // Access translation
                  leading: Radio(
                    activeColor: Color.fromARGB(255, 85, 143, 151),
                    autofocus: true,
                    value: 'hi_IN',
                    groupValue: selectedLanguage,
                    onChanged: (value) {
                      setState(() {
                        selectedLanguage = value.toString();
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'close'.tr,
            style: TextStyle(
              color: Color.fromARGB(255, 85, 143, 151),
            ),
          ), // Use 'close' from translations
        ),
        TextButton(
          onPressed: () {
            // Change language when OK is clicked
            translationController.changeLanguage(selectedLanguage);
            Navigator.of(context).pop();
          },
          child: Text(
            'ok'.tr,
            style: TextStyle(
              color: Color.fromARGB(255, 85, 143, 151),
            ),
          ), // Use 'ok' from translations
        ),
      ],
    );
  }
}
