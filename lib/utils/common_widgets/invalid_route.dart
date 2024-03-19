import 'package:app/l10n/app_localization.dart';
import 'package:flutter/material.dart';

class InvalidRoute extends StatelessWidget {
  const InvalidRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          AppLocalizations.of(context).translate('uhOhPageNotFound'),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
