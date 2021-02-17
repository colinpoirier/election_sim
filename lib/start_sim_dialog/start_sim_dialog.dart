import 'package:election_sim/sim_bloc/sim_bloc.dart';
import 'package:election_sim/start_sim_dialog/bloc/start_sim_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StartSimDialog extends StatelessWidget {
  const StartSimDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StartSimBloc(),
      child: AlertDialog(
        title: const Text('Enter Runs'),
        content: BlocBuilder<StartSimBloc, StartSimState>(
          builder: (context, state) {
            return TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                errorText: state.error,
              ),
              initialValue: '${state.runs}',
              onChanged: (val) {
                context.read<StartSimBloc>().add(StartSimEvent(runs: val));
              },
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly
              ],
              keyboardType: TextInputType.number,
            );
          },
        ),
        actions: [
          FlatButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          BlocBuilder<StartSimBloc, StartSimState>(
            builder: (context, state) {
              void Function() onPressed;
              if (state.canSubmit) {
                onPressed = () {
                  Navigator.pop(context);
                  context.read<SimBloc>().add(StartSim(runs: state.runs));
                };
              }
              return FlatButton(
                child: const Text('Start'),
                onPressed: onPressed,
              );
            },
          ),
        ],
      ),
    );
  }
}
