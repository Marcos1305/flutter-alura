import 'package:curso_persitencia_flutter/components/container.dart';
import 'package:curso_persitencia_flutter/components/progress.dart';
import 'package:curso_persitencia_flutter/database/dao/contact_dao.dart';
import 'package:curso_persitencia_flutter/models/contact_model.dart';
import 'package:curso_persitencia_flutter/screens/contact_form.dart';
import 'package:curso_persitencia_flutter/screens/transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
abstract class ContactsListState {
  const ContactsListState();
}

@immutable
class InitContactsListState extends ContactsListState {
  const InitContactsListState();
}

@immutable
class LoadingContactsListState extends ContactsListState {
  const LoadingContactsListState();
}

@immutable
class LoadedContactsListState extends ContactsListState {
  final List<Contact> contacts;
  const LoadedContactsListState(this.contacts);
}

@immutable
class FatalErrorContactsListState extends ContactsListState {
  const FatalErrorContactsListState();
}

class ContactsListCubit extends Cubit<ContactsListState> {
  ContactsListCubit() : super(InitContactsListState());

  void reload() async {
    emit(LoadingContactsListState());
    final List<Contact> contacts = await ContactDAO().findAll();
    emit(LoadedContactsListState(contacts));
  }
}

class ContactsListContainer extends BlocContainer {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContactsListCubit>(
      create: (context) {
        final cubit = ContactsListCubit();
        cubit.reload();
        return cubit;
      },
      child: ContactsList(),
    );
  }
}

class ContactsList extends StatefulWidget {
  ContactsList({Key? key}) : super(key: key);

  @override
  _ContactsListState createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
      ),
      body: BlocBuilder<ContactsListCubit, ContactsListState>(
        builder: (context, state) {
          if (state is InitContactsListState ||
              state is LoadingContactsListState) {
            return Progress();
          }
          if (state is LoadedContactsListState) {
            return ListView.builder(
              itemCount: state.contacts.length,
              itemBuilder: (context, index) {
                final contact = state.contacts[index];
                return _ContactItem(
                  contact: contact,
                  onTap: () {
                    push(context, TransactionFormContainer(contact));
                  },
                );
              },
            );
          }

          return Container();
        },
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  FloatingActionButton _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return ContactForm();
          },
        )).then((_) => context.read<ContactsListCubit>().reload());
      },
      child: Icon(Icons.add),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final Contact contact;
  final VoidCallback? onTap;
  const _ContactItem({Key? key, required this.contact, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text(
          contact.name,
          style: TextStyle(fontSize: 24),
        ),
        subtitle: Text(
          contact.accountNumber.toString(),
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
