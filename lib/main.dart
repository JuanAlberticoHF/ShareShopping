import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ShareShopping/app/pages/mainPages/perfil_usuario_page.dart';
import 'app/pages/mainPages/listas_compartidas_page.dart';
import 'app/pages/mainPages/mis_listas_page.dart';
import 'data/sources/firebase_options.dart';

/// Punto de entrada de la aplicacion.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ShareShoppingAPP());
}

/// ShareShoppingAPP es la aplicacion principal que contiene el widget MaterialApp.
class ShareShoppingAPP extends StatelessWidget {
  const ShareShoppingAPP({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      home: MainPage()
    );
  }
}

/// MainPage es el widget que contiene la navegacion entre las 3 principales
/// paginas de la aplicacion.
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}


class _MainPageState extends State<MainPage> {

  int _indiceSeleccionado = 0; // Indice pagina activa

  static final List<Widget> _paginas = [
    ListasUsuarioPage(), // Indice 0
    ListasCompartidasPage(), // Indice 1
    PerfilUsuarioPage(), // Indice 2
  ];

  void _cambiarPaginaA (int index) {
    setState(() {
      _indiceSeleccionado = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _indiceSeleccionado, // Indice de la pagina activa
        children: _paginas, // Listado de paginas disponibles
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        showSelectedLabels: true,
        currentIndex: _indiceSeleccionado,
        items: const [
          // Pagina: Mis Listas
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Listas',
          ),
          // Pagina: Compartidas
          BottomNavigationBarItem(
            icon: Icon(Icons.share),
            label: 'Compartidas',
          ),
          // Pagina: Perfil
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        onTap: (index) {
          _cambiarPaginaA(index);
        },
      ),
    );
  }
}