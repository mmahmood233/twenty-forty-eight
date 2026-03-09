import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'presentation/screens/game_screen.dart';
import 'presentation/providers/game_provider.dart';
import 'domain/services/game_service.dart';
import 'data/repositories/score_repository.dart';

/// Entry point for the 2048 game application.
///
/// Initializes Flutter bindings and sets the app to portrait-only mode.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const MyApp());
}

/// Root widget of the 2048 game application.
///
/// Sets up the [GameProvider] for state management and
/// configures the app theme and navigation.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameProvider(
        gameService: GameService(),
        scoreRepository: ScoreRepository(),
      ),
      child: MaterialApp(
        title: '2048',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Arial',
          useMaterial3: true,
        ),
        home: const GameScreen(),
      ),
    );
  }
}
