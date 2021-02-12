import 'package:election_sim/cubit/load_json_cubit.dart';
import 'package:election_sim/sim_bloc/sim_bloc.dart';
import 'package:election_sim/start_sim_dialog/start_sim_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LoadJsonCubit()),
        BlocProvider(
          create: (context) => SimBloc(context.read<LoadJsonCubit>()),
          lazy: false, // required to work as intended
        )
      ],
      child: MaterialApp(
        title: 'Election Sim',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocBuilder<LoadJsonCubit, LoadJsonState>(
          builder: (context, state) {
            if (state is! JsonLoaded) {
              Widget child;
              if (state is LoadJsonLoading) {
                child = CircularProgressIndicator();
              } else if (state is LoadJsonError) {
                child = Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.error),
                    ElevatedButton(
                      child: const Text('Retry'),
                      onPressed: () {
                        context.read<LoadJsonCubit>().retry();
                      },
                    ),
                  ],
                );
              } else {
                child = const Text('Ooops');
              }
              return Scaffold(
                body: Center(
                  child: child,
                ),
              );
            }
            return const MyHomePage();
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Election Sim'),
      ),
      body: Center(
        child: BlocBuilder<SimBloc, SimState>(
          builder: (context, state) {
            if (state is SimLoading) {
              return const CircularProgressIndicator();
            }
            final button = ElevatedButton(
              child: const Text('Start'),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => const StartSimDialog(),
                );
              },
            );
            if (state is ReadyForSim) {
              return button;
            } else if (state is SimError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Error'),
                  button,
                ],
              );
            } else if (state is SimResults) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  button,
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      itemCount: state.results.length,
                      itemBuilder: (_, index) => Text(state.results[index]),
                    ),
                  )
                ],
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Error'),
                  button,
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
