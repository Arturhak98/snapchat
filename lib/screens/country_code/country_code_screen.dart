import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapchat/components/models/country_code.dart';
import 'package:snapchat/components/style/style.dart';
import 'package:snapchat/components/widgets/back_button.dart';
import 'package:snapchat/components/widgets/change_focus.dart';
import 'bloc/country_code_bloc.dart';

class CountryCode extends StatefulWidget {
  const CountryCode({
    required this.OnCountryChanged,
    required this.countries,
    super.key,
  });
  final Function(Country country) OnCountryChanged;
  final countries;

  @override
  State<CountryCode> createState() => _CountryCodeState();
}

class _CountryCodeState extends State<CountryCode> {
  var _filtredCountres = <Country>[];
  final CountryCodeBloc _bloc = CountryCodeBloc();

  @override
  void initState() {
    _filtredCountres = widget.countries;
    super.initState();
  }

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
        onChanged: (value) => _bloc
            .add(SearchFieldEvent(query: value, countries: widget.countries)),
        decoration: SearchFieldBorderStyle,
      ),
    );
  }

  Widget _renderListView() {
    return Expanded(
      child: SizedBox(
        child: ListView.builder(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemCount: _filtredCountres.length,
          itemBuilder: (BuildContext context, int index) {
            return _renderListViewElement(index);
          },
        ),
      ),
    );
  }

  Widget _renderListViewElement(int index) {
    return GestureDetector(
      onTap: () => {
        widget.OnCountryChanged(_filtredCountres[index]),
        Navigator.pop(context),
      },
      child: Column(
        children: [
          Row(
            children: [
              _renderFlagToString(index),
              Text(
                _filtredCountres[index].CountryCode,
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
        _filtredCountres[index].CountryCodeString.replaceAllMapped(
                  RegExp(r'[A-Z]'),
                  (match) => String.fromCharCode(
                      match.group(0)!.codeUnitAt(0) + 127397),
                ) +
            ' ' +
            _filtredCountres[index].CountryName,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}

extension _CountryBlocListner on _CountryCodeState {
  void _countryBlocListner(BuildContext context, CountryCodeState state) {
    if (state is SelectCountryState) {
      widget.OnCountryChanged(state.selectedCountry);
      FocusManager.instance.primaryFocus?.unfocus();
      Navigator.pop(context);
    }
    if (state is SearchCountriesState) {
      _filtredCountres = state.filtredCountries;
    }
  }
}
