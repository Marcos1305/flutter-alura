import 'package:curso_persitencia_flutter/components/container.dart';
import 'package:curso_persitencia_flutter/components/dashboard_menu_item.dart';
import 'package:curso_persitencia_flutter/components/localization.dart';
import 'package:curso_persitencia_flutter/models/name_bloc.dart';
import 'package:curso_persitencia_flutter/screens/contacts_list.dart';
import 'package:curso_persitencia_flutter/screens/transactions_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'name.dart';

class DashboardContainer extends BlocContainer {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NameCubit("Marcos"),
      child: I18NLoadingContainer(
        creator: (i18NMessages) => Dashboard(),
      ),
    );
  }
}

class Dashboard extends StatelessWidget {
  final I18NMessages i18nMessages;
  const Dashboard({
    Key? key,
    required this.i18nMessages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var i18n = DashboardViewI18N(context);
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<NameCubit, String>(
          builder: (context, state) => Text("Welcome $state"),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/images/bytebank_logo.png',
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DashboardMenuItem(
                      title: i18n.contacts(),
                      icon: Icons.monetization_on_outlined,
                      onTap: () {
                        _showContactsList(context);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DashboardMenuItem(
                      title: i18n.transactions(),
                      icon: Icons.description,
                      onTap: () {
                        _showTransactionsFeed(context);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DashboardMenuItem(
                      title: i18n.changeName(),
                      icon: Icons.person,
                      onTap: () {
                        _showNamePage(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showContactsList(BuildContext context) {
    push(context, ContactsListContainer());
  }

  void _showTransactionsFeed(BuildContext context) {
    push(context, TransactionsListContainer());
  }

  void _showNamePage(BuildContext blocContext) {
    Navigator.of(blocContext).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: BlocProvider.of<NameCubit>(blocContext),
          child: NameContainer(),
        ),
      ),
    );
  }
}
