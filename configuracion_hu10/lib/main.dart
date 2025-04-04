import 'package:flutter/material.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Configuración',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: SettingsScreen(),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final List<Map<String, dynamic>> settingsOptions = [
    {'icon': Icons.lock, 'title': 'Privacidad'},
    {'icon': Icons.language, 'title': 'Idioma'},
    {'icon': Icons.notifications, 'title': 'Notificaciones'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ajustes')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Configuración',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ...settingsOptions.map((option) => ListTile(
                  leading: Icon(option['icon']),
                  title: Text(option['title']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          switch (option['title']) {
                            case 'Idioma':
                              return LanguageScreen();
                            case 'Privacidad':
                              return PrivacyScreen();
                            case 'Notificaciones':
                              return NotificationsScreen();
                            default:
                              return Scaffold();
                          }
                        },
                      ),
                    );
                  },
                )),
            ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.red),
              title: Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('¿Está seguro de cerrar sesión?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // cerrar el diálogo
                        },
                        child: Text('No'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // cerrar el diálogo
                          Future.delayed(Duration(milliseconds: 500), () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Cerrando sesión...')),
                            );
                            Future.delayed(Duration(seconds: 2), () {
                              exit(0); // cerrar la app completamente
                            });
                          });
                        },
                        child: Text('Sí'),
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
      body: Center(
        child: Text('Selecciona una opción del menú lateral'),
      ),
    );
  }
}

class LanguageScreen extends StatefulWidget {
  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  final List<String> languages = [
    'Alemán',
    'Español',
    'Francés',
    'Inglés',
    'Portugués'
  ];
  List<String> filteredLanguages = [];

  @override
  void initState() {
    super.initState();
    filteredLanguages = List.from(languages)..sort();
  }

  void filterLanguages(String query) {
    setState(() {
      filteredLanguages = languages
          .where((lang) =>
              lang.toLowerCase().contains(query.toLowerCase()))
          .toList()
        ..sort();
    });
  }

  void changeLanguage(String lang) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_getChangingText(lang))),
    );
  }

  String _getChangingText(String lang) {
    switch (lang) {
      case 'Español':
        return 'Cambiando idioma...';
      case 'Inglés':
        return 'Changing language...';
      case 'Francés':
        return 'Changement de langue...';
      case 'Portugués':
        return 'Mudando idioma...';
      case 'Alemán':
        return 'Sprache ändern...';
      default:
        return 'Cambiando idioma...';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Idioma')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              onChanged: filterLanguages,
              decoration: InputDecoration(
                hintText: 'Buscar idioma...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredLanguages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.language),
                  title: Text(filteredLanguages[index]),
                  onTap: () => changeLanguage(filteredLanguages[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Privacidad')),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.accessibility),
            title: Text('Accesibilidad'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccessibilityScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text('Política de privacidad'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Ayuda'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelpScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class AccessibilityScreen extends StatelessWidget {
  const AccessibilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Accesibilidad')),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.email),
            title: Text('Cambiar correo'),
            onTap: () {
              _showChangeDialog(context, 'correo');
            },
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Cambiar contraseña'),
            onTap: () {
              _showChangeDialog(context, 'contraseña');
            },
          ),
        ],
      ),
    );
  }

  void _showChangeDialog(BuildContext context, String tipo) {
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Verificar contraseña actual'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Contraseña actual'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text('Cambiar $tipo'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: newController,
                        obscureText: tipo == 'contraseña',
                        decoration: InputDecoration(
                          labelText: 'Nuevo $tipo',
                        ),
                      ),
                      TextField(
                        controller: confirmController,
                        obscureText: tipo == 'contraseña',
                        decoration: InputDecoration(
                          labelText: 'Confirmar $tipo',
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        if (newController.text == confirmController.text &&
                            newController.text.isNotEmpty) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('$tipo cambiado con éxito.'),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Los $tipo no coinciden.'),
                            ),
                          );
                        }
                      },
                      child: Text('Guardar'),
                    ),
                  ],
                ),
              );
            },
            child: Text('Verificar'),
          ),
        ],
      ),
    );
  }
}

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ayuda')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Image.network(
              'https://upload.wikimedia.org/wikipedia/commons/thumb/8/80/QR_code_for_mobile_English_Wikipedia.svg/1920px-QR_code_for_mobile_English_Wikipedia.svg.png',
              height: 200,
            ),
            SizedBox(height: 20),
            Text(
              'Escanea el código QR para acceder a ayuda personalizada.',
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Política de privacidad')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Text(
                'Este es un texto ficticio de política de privacidad. Aquí iría la información legal sobre el uso de los datos del usuario...',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Center(
              child: ElevatedButton.icon(
                icon: Icon(Icons.report),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Reporte enviado')),
                  );
                },
                label: Text('Reportar'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool notificationsEnabled = true;
  bool sms = false;
  bool email = true;
  bool whatsapp = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notificaciones')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Permitir notificaciones
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Permitir notificaciones',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Switch(
                value: notificationsEnabled,
                onChanged: (value) {
                  setState(() => notificationsEnabled = value);
                },
                activeColor: Colors.green,
                inactiveThumbColor: Colors.grey,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Sección Preferencias
          const Text('Preferencias',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const Divider(),
          SwitchListTile(
            title: const Text('SMS'),
            value: sms,
            activeColor: Colors.green,
            inactiveThumbColor: Colors.grey,
            onChanged: (value) {
              setState(() => sms = value);
            },
          ),
          SwitchListTile(
            title: const Text('Email'),
            value: email,
            activeColor: Colors.green,
            inactiveThumbColor: Colors.grey,
            onChanged: (value) {
              setState(() => email = value);
            },
          ),
          SwitchListTile(
            title: const Text('WhatsApp'),
            value: whatsapp,
            activeColor: Colors.green,
            inactiveThumbColor: Colors.grey,
            onChanged: (value) {
              setState(() => whatsapp = value);
            },
          ),
          const SizedBox(height: 24),

          // Sección Actualizaciones
const Text('Actualizaciones',
    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
const Divider(),
const Text('Scanner ya está actualizada'),
const SizedBox(height: 8),
Align(
  alignment: Alignment.centerLeft,
  child: TextButton.icon(
    onPressed: () {
      // Acción de reporte
    },
    icon: Icon(Icons.report, color: Colors.grey[700], size: 20),
    label: Text(
      'Reportar',
      style: TextStyle(color: Colors.grey[700]),
    ),
    style: TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      visualDensity: VisualDensity.compact,
    ),
  ),
),          
          
        ],
      ),
    );
  }
}


class LogoutScreen extends StatelessWidget {
  const LogoutScreen({super.key});

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('¿Cerrar sesión?'),
        content: Text('¿Estás seguro que deseas salir de la aplicación?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              exit(0); // cierra completamente la app pero en emulador
            },
            child: Text('Sí, salir'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cerrar sesión')),
      body: Center(
        child: ElevatedButton.icon(
          icon: Icon(Icons.logout),
          label: Text('Cerrar sesión'),
          onPressed: () => _confirmLogout(context),
        ),
      ),
    );
  }
}
