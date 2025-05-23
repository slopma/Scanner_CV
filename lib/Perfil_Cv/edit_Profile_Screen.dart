import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:scanner_personal/WidgetBarra.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfileScreen extends StatefulWidget {
  final String userId;
  final Map<String, dynamic> userData;

  const EditProfileScreen({required this.userId, required this.userData});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  late final AnimationController _hoverController;
  late final Animation<double> _scaleAnimation;
// Mapero para la informacion que se muestra
  final Map<String, String> fieldMapping = {
    "Nombres": "nombres",
    "Apellidos": "apellidos",
    "Dirección": "direccion",
    "Teléfono": "telefono",
    "Correo electrónico": "correo",
    "Nacionalidad": "nacionalidad",
    "Fecha de nacimiento": "fecha_nacimiento",
    "Estado civil": "estado_civil",
    "LinkedIn": "linkedin",
    "GitHub": "github",
    "Portafolio": "portafolio",
    "Perfil profesional": "perfil_profesional",
    "Objetivos Profesionales": "objetivos_profesionales",
    "Experiencia Laboral": "experiencia_laboral",
    "Expectativas Laborales": "expectativas_laborales",
    "Experiencia Internacional": "experiencia_internacional",
    "Educación": "educacion",
    "Habilidades": "habilidades",
    "Idiomas": "idiomas",
    "Certificaciones": "certificaciones",
    "Participación en Proyectos": "proyectos",
    "Publicaciones": "publicaciones",
    "Premios": "premios",
    "Voluntariados": "voluntariados",
    "Referencias": "referencias",
    "Permisos y Documentación": "permisos_documentacion",
    "Vehículo y Licencias": "vehiculo_licencias",
    "Disponibilidad para Entrevistas": "disponibilidad_entrevistas",
  };

  @override
  void initState() {
    super.initState();
    // Inicializa los controllers
    fieldMapping.forEach((label, key) {
      _controllers[label] =
          TextEditingController(text: _getValueByKey(label));
    });

    // Para el efecto hover/scale si quisieras usarlo en campos especiales
    _hoverController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05)
        .animate(CurvedAnimation(parent: _hoverController, curve: Curves.easeOut));
  }

  String _getValueByKey(String label) {
    for (var section in widget.userData.values) {
      if (section is Map && section.containsKey(label)) {
        return section[label] ?? '';
      }
    }
    return '';
  }

  Future<void> _saveChanges() async {
    final updates = <String, dynamic>{};
    fieldMapping.forEach((label, key) {
      updates[key] = _controllers[label]?.text ?? '';
    });
    try {
      final supabase = Supabase.instance.client;
      await supabase
          .from('perfil_information')
          .update(updates)
          .eq('id', widget.userId);
      Navigator.pop(context, true);
    } catch (error) {
      print('Error al guardar cambios: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar los cambios.')),
      );
    }
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _controllers.values.forEach((c) => c.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: const CustomAppBar(title: 'Editar Información'),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color(0xff9ee4b8),
        icon: Icon(Icons.save, color: Color(0xFF090467)),
        label: Text(
          'Guardar',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF090467),
          ),
        ),
        onPressed: _saveChanges,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: fieldMapping.keys.map((label) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: _controllers[label],
                  style: GoogleFonts.poppins(fontSize: 14),          // Poppins para el texto
                  decoration: InputDecoration(
                    labelText: label,
                    labelStyle: GoogleFonts.poppins(
                      fontSize: 16, color: Color(0xFF090467),        // Poppins y azul para labels
                    ),
                    filled: true,
                    fillColor: Color(0xffeff8ff),                     // mismo gris de fondo de pantalla
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),        // esquinas suaves
                      borderSide: BorderSide(color: Color(0xFF090467)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xFF090467), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xff9ee4b8), width: 2),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
