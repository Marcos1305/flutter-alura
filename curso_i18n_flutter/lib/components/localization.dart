import 'package:curso_persitencia_flutter/components/progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'container.dart';

class LocalizationContainer extends BlocContainer {
  final Widget child;

  LocalizationContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: CurrentLocaleCubit(),
      child: child,
    );
  }
}

class CurrentLocaleCubit extends Cubit<String> {
  CurrentLocaleCubit() : super("pt-br");
}

class DashboardViewI18N extends ViewI18N {
  DashboardViewI18N(BuildContext context) : super(context);

  contacts() {
    return _localize({"pt-br": "Transferir", "en": "Transfer"});
  }

  transactions() {
    return _localize({"pt-br": "Transações", "en": "Transactions"});
  }

  changeName() {
    return _localize({"pt-br": "Mudar nome", "en": "Change nome"});
  }
}

abstract class ViewI18N {
  late String _language;

  ViewI18N(BuildContext context) {
    this._language = BlocProvider.of<CurrentLocaleCubit>(context).state;
  }

  _localize(Map<String, String> map) {
    assert(map.containsKey(_language));
    return map[_language];
  }
}

abstract class I18NMessagesState {
  const I18NMessagesState();
}

class LoadingI18NMessagesState extends I18NMessagesState {}

class InitI18NMessagesState extends I18NMessagesState {}

class LoadedI18NMessagesState extends I18NMessagesState {
  final I18NMessages messages;

  LoadedI18NMessagesState(this.messages);
}

class FatalErrorI18NMessagesState extends I18NMessagesState {}

class I18NLoadingView extends StatelessWidget {
  final Function(I18NMessages i18NMessages) creator;

  I18NLoadingView({required this.creator});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<I18NMessagesCubit, I18NMessagesState>(
      builder: (context, state) {
        if (state is InitI18NMessagesState ||
            state is LoadingI18NMessagesState) {
          return Progress();
        }

        if (state is LoadedI18NMessagesState) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (=)))
        }

        return Center(
          child: Text("Erro ao carregar dados"),
        );
      },
    );
  }
}

class I18NLoadingContainer extends BlocContainer {
  final Function(I18NMessages i18NMessages) creator;

  I18NLoadingContainer({required this.creator});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<I18NMessagesCubit>(
      create: (context) {
        final cubit = I18NMessagesCubit();
        cubit.reload();
        return cubit;
      },
      child: I18NLoadingView(),
    );
  }
}

class I18NMessagesCubit extends Cubit<I18NMessagesState> {
  I18NMessagesCubit() : super(InitI18NMessagesState());

  void reload() {
    emit(LoadingI18NMessagesState());
    // TODO:: CARREGAR
    emit(
      LoadedI18NMessagesState(
        I18NMessages(
          {"home": "Home"},
        ),
      ),
    );
  }
}

class I18NMessages {
  final Map<String, String> _messages;

  I18NMessages(this._messages);

  String get(String key) {
    assert(_messages.containsKey(key));
    assert(_messages[key] != null);

    return _messages[key]!;
  }
}
