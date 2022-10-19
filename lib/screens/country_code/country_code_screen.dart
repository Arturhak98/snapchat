import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:snapchat/components/models/country_code.dart';
import 'package:snapchat/components/models/country_notifier.dart';
import 'package:snapchat/components/style/style.dart';
import 'package:snapchat/components/widgets/back_button.dart';
import 'package:snapchat/components/widgets/change_focus.dart';
import 'package:snapchat/middle_wares/repositories/sql_database_repository.dart';
import 'bloc/country_code_bloc.dart';

class CountryCode extends StatefulWidget {
  const CountryCode({
    required this.countries,
    super.key,
  });
  final List<Country> countries;

  @override
  State<CountryCode> createState() => _CountryCodeState();
}

class _CountryCodeState extends State<CountryCode> {
  final CountryCodeBloc _bloc = CountryCodeBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocConsumer<CountryCodeBloc, CountryCodeState>(
        listener: _countryBlocListner,
        builder: (context, state) {
          return ChangeFocus(
            child: Scaffold(
              body: Stack(
                children: [
                  _renderBackButton(),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 140),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _renderTextField(),
                        _renderListView(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _renderBackButton() {
    return const Padding(
      padding: EdgeInsets.only(top: 45),
      child: BackButtonWidget(),
    );
  }

  Widget _renderTextField() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: TextField(
        onChanged: (value) => _bloc.add(SearchFieldEvent(query: value)),
        decoration: SearchFieldBorderStyle,
      ),
    );
  }

  Widget _renderListView() {
    return Expanded(
      child: SizedBox(
        child: ListView.builder(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemCount: widget.countries.length,
          itemBuilder: (BuildContext context, int index) {
            return _renderListViewElement(index);
          },
        ),
      ),
    );
  }

  Widget _renderListViewElement(int index) {
    final value = Provider.of<CountryNotifier>(context, listen: false);
    return GestureDetector(
      onTap: () => {
        value.changeCountry(widget.countries[index]),
        Navigator.pop(context),
        
      },
      child: Column(
        children: [
          Row(
            children: [
              _renderFlagToString(index),
              Text(
                widget.countries[index].CountryCode,
                style: const TextStyle(fontSize: 20),
              )
            ],
          ),
          const Divider(
            height: 25,
          ),
        ],
      ),
    );
  }

  Widget _renderFlagToString(int index) {
    return Expanded(
      child: Text(
        widget.countries[index].CountryCodeString.replaceAllMapped(
              RegExp(r'[A-Z]'),
              (match) =>
                  String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397),
            ) +
            ' ' +
            widget.countries[index].CountryName,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
  @override
  void dispose() {
    widget.countries.clear();
    SqlDatabaseRepository().getCountries('').then((value) =>widget.countries.addAll(value));
    super.dispose();
  }
}

extension _CountryBlocListner on _CountryCodeState {
  void _countryBlocListner(BuildContext context, CountryCodeState state) {
    if (state is SearchCountriesState) {
      widget.countries.clear();
      widget.countries.addAll(state.filtredCountries);
    }
  }
}
