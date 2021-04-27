import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:points_of_sale/providers/auth.dart';
import 'package:points_of_sale/helpers/service_locator.dart';
import 'package:provider/provider.dart';

class CountryPickerCode extends StatelessWidget {
  const CountryPickerCode({Key key, this.isRTL, this.context})
      : super(key: key);
  final BuildContext context;
  final bool isRTL;
  @override
  Widget build(BuildContext context) {
    final Auth auth = Provider.of<Auth>(context);

    return CountryCodePicker(
      onChanged: _onCountryChange,
      initialSelection: auth.dialCodeFav,
      favorite: const <String>['+966', 'SA'],
      showFlagDialog: true,
      showFlag: false,
      showCountryOnly: false,
      showOnlyCountryWhenClosed: false,
      alignLeft: false,
      padding: isRTL == true
          ? const EdgeInsets.fromLTRB(0, 0, 32, 0)
          : const EdgeInsets.fromLTRB(32, 0, 0, 0),
    );
  }

  void _onCountryChange(CountryCode countryCode) {
    getIt<Auth>().saveCountryCode(countryCode.code, countryCode.dialCode);

    FocusScope.of(context).requestFocus(FocusNode());
  }
}
