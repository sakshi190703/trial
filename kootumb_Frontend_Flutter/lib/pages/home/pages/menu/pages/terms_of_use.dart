import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/widgets/progress_indicator.dart';
import 'package:Kootumb/widgets/theming/primary_color_container.dart';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';

class OBTermsOfUsePage extends StatefulWidget {
  const OBTermsOfUsePage({Key? key}) : super(key: key);

  @override
  OBTermsOfUsePageState createState() {
    return OBTermsOfUsePageState();
  }
}

class OBTermsOfUsePageState extends State {
  late String _guidelinesText;
  late bool _needsBootstrap;

  CancelableOperation? _getGuidelinesOperation;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _guidelinesText = '';
  }

  @override
  void dispose() {
    super.dispose();
    if (_getGuidelinesOperation != null) _getGuidelinesOperation!.cancel();
  }

  void _bootstrap() async {
    KongoProviderState kongoProvider = KongoProvider.of(context);
    _getGuidelinesOperation = CancelableOperation.fromFuture(
        kongoProvider.documentsService.getTermsOfUse());

    String guidelines = await _getGuidelinesOperation?.value;
    _setGuidelinesText(guidelines);
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      _bootstrap();
      _needsBootstrap = false;
    }

    return CupertinoPageScaffold(
      navigationBar: OBThemedNavigationBar(
        title: 'Terms of use',
        leading: GestureDetector(
          child: const OBIcon(OBIcons.close),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      child: OBPrimaryColorContainer(
        child: Column(
          children: <Widget>[
            Expanded(
              child: _guidelinesText.isNotEmpty
                  ? SingleChildScrollView(
                      child: Text(
                        _guidelinesText,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [OBProgressIndicator()],
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  void _setGuidelinesText(String guidelinesText) {
    setState(() {
      _guidelinesText = guidelinesText;
    });
  }
}
