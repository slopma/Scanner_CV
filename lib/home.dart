import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//Cambie esto
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Text('Menú', style: GoogleFonts.poppins(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Perfil', style: GoogleFonts.poppins()),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Modificar datos personales', style: GoogleFonts.poppins()),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.lock),
              title: Text('Cambiar contraseña', style: GoogleFonts.poppins()),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Cerrar sesión', style: GoogleFonts.poppins()),
              onTap: () {},
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Bienvenido', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 2,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.indigo.shade900],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selecciona una opción',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  children: [
                    CustomCard(text: 'Escanear Documento', icon: Icons.camera_alt),
                    CustomCard(text: 'Grabar Audio', icon: Icons.mic),
                    CustomCard(text: 'Llenar Formulario', icon: Icons.edit),
                    CustomCard(text: 'Subir Documento', icon: Icons.upload),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomCard extends StatefulWidget {
  final String text;
  final IconData icon;

  CustomCard({required this.text, required this.icon});

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: _isHovering ? Colors.greenAccent : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.icon, size: 50, color: Colors.deepPurple),
                SizedBox(height: 10),
                Text(
                  widget.text,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
