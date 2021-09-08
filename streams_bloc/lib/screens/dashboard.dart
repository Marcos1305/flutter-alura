import 'package:curso_persitencia_flutter/components/container.dart';
import 'package:curso_persitencia_flutter/components/dashboard_menu_item.dart';
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
      child: Dashboard(),
    );
  }
}

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final name = context.read<NameCubit>().state;
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<NameCubit, String>(
          builder: (context, state) => Text("Welcome $name"),
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
                      title: "Contatos",
                      icon: Icons.monetization_on_outlined,
                      onTap: () {
                        _showContactsList(context);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DashboardMenuItem(
                      title: "Transferência Feed",
                      icon: Icons.description,
                      onTap: () {
                        _showTransactionsFeed(context);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DashboardMenuItem(
                      title: "Mudar nome",
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
