import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'presentation/screens/game_screen.dart';
import 'presentation/providers/game_provider.dart';
import 'domain/services/game_service.dart';
import 'data/repositories/score_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const MyApp());
}

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
