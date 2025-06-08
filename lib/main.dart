import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shareshopping/app/pages/mainPages/perfil_usuario_page.dart';
import 'app/pages/mainPages/listas_compartidas_page.dart';
import 'app/pages/mainPages/mis_listas_page.dart';
import 'data/sources/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MainPage()
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // PAGINACION
  int _indiceSeleccionado = 0;

  static final List<Widget> _pages = [
    ListasUsuarioPage(), // Indice 0
    ListasCompartidasPage(), // Indice 1
    PerfilUsuarioPage(), // Indice 2
  ];

  void _onPageChanged(int index) {
    setState(() {
      _indiceSeleccionado = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _indiceSeleccionado, // Indice de la pagina activa
        children: _pages, // Listado de paginas disponibles
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        showSelectedLabels: true,
        currentIndex: _indiceSeleccionado,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Listas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.share),
            label: 'Compartidas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        onTap: (index) {
          _onPageChanged(index);
        },
      ),
    );
  }
}