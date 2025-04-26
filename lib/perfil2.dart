import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:perfil/EditProfileScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int? _expandedIndex;
  int? _hoverIndex;
  Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    // Esta pendiente cambiarlo para que me aparezca la informacion del cliente que ingreso
    // En este momento solo sale del userId que paso
    final supabase = Supabase.instance.client;
    final userId = '1';
    try {
      final response = await supabase
          .from('perfil_information')
          .select()
          .eq('id', userId)
          .limit(1)
          .single();
      if (response != null) {
        setState(() {
          userData = {
            "Información Personal": {
              "Nombres": response['nombres'] ?? '',
              "Apellidos": response['apellidos'] ?? '',
              "Fotografía": response['fotografia'] ?? '',
              "Dirección": response['direccion'] ?? '',
              "Teléfono": response['telefono'] ?? '',
              "Correo electrónico": response['correo'] ?? '',
              "Nacionalidad": response['nacionalidad'] ?? '',
              "Fecha de nacimiento": response['fecha_nacimiento'] ?? '',
              "Estado civil": response['estado_civil'] ?? '',
            },
            "Redes y Portafolio": {
              "LinkedIn": response['linkedin'] ?? '',
              "GitHub": response['github'] ?? '',
              "Portafolio": response['portafolio'] ?? '',
            },
            "Experiencia Laboral": {
              "Perfil profesional": response['perfil_profesional'] ?? '',
              "Objetivos Profesionales": response['objetivos_profesionales'] ??
                  '',
              "Experiencia Laboral": response['experiencia_laboral'] ?? '',
              "Expectativas Laborales": response['expectativas_laborales'] ??
                  '',
              "Experiencia Internacional": response['experiencia_internacional'] ??
                  '',
            },
            "Educación y Conocimientos": {
              "Educación": response['educacion'] ?? '',
              "Habilidades": response['habilidades'] ?? '',
              "Idiomas": response['idiomas'] ?? '',
              "Certificaciones": response['certificaciones'] ?? '',
              "Participación en Proyectos": response['proyectos'] ?? '',
              "Publicaciones": response['publicaciones'] ?? '',
              "Premios": response['premios'] ?? '',
              "Voluntariados": response['voluntariados'] ?? '',
            },
            "Otros": {
              "Referencias": response['referencias'] ?? '',
              "Permisos y Documentación": response['permisos_documentacion'] ??
                  '',
              "Vehículo y Licencias": response['vehiculo_licencias'] ?? '',
              "Disponibilidad para Entrevistas": response['disponibilidad_entrevistas'] ??
                  '',
            }
          };
        });
      }
    } catch (error) {
      print("Error al obtener los datos: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    final infoPersonal = userData["Información Personal"] ?? {};
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Icon(Icons.person, color: Colors.deepPurple),
        title: Text("Información del Perfil",
            style: GoogleFonts.poppins(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 2,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepPurple,
        icon: Icon(Icons.edit),
        label: Text('Editar', style: GoogleFonts.poppins()),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  EditProfileScreen(
                    userId: '1',
                    userData: userData,
                  ),
            ),
          );

          if (result == true) {
            await fetchUserData();
          }
        },
      ),
      body: userData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // Alineación a la izquierda
            children: [
              // Usar un Row para la foto y el texto
              Row(
                children: [
                  if (infoPersonal['Fotografía'] != null &&
                      infoPersonal['Fotografía'].isNotEmpty)
                    CircleAvatar(
                      backgroundImage: NetworkImage(infoPersonal['Fotografía']),
                      radius: 50,
                    ),
                  SizedBox(width: 16), // Espacio entre la foto y el texto
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // Alineación a la izquierda
                      children: [
                        Text(
                          "${infoPersonal['Nombres'] ??
                              ''} ${infoPersonal['Apellidos'] ?? ''}",
                          style: GoogleFonts.poppins(fontSize: 18, color: Colors
                              .black87),
                        ),
                        Text(
                          "${infoPersonal['Correo electrónico'] ?? ''}",
                          style: GoogleFonts.poppins(fontSize: 14, color: Colors
                              .black54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ExpansionPanelList(
                animationDuration: Duration(milliseconds: 400),
                expansionCallback: (index, _) {
                  setState(() {
                    _expandedIndex = (_expandedIndex == index) ? null : index;
                  });
                },
                children: _buildPanels(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<ExpansionPanel> _buildPanels() {
    List<String> categories = userData.keys.toList();
    return List.generate(categories.length, (index) {
      String category = categories[index];
      var content = userData[category];

      return ExpansionPanel(
        canTapOnHeader: true,
        backgroundColor: Colors.white,
        headerBuilder: (context, isExpanded) {
          return Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(12),
            child: Text(
              category,
              style: GoogleFonts.poppins(fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
          );
        },
        body: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // ya lo tenías bien
              children: _buildContent(content),
            ),
          ),
        ),
        isExpanded: _expandedIndex == index,
      );
    });
  }

  List<Widget> _buildContent(dynamic content) {
    if (content is Map) {
      return content.entries.map((entry) {
        if (entry.key == "Fotografía") return SizedBox();
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text("${entry.key}: ${entry.value}",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87)),
        );
      }).toList();
    }
    return [
      Text("No hay información disponible", style: GoogleFonts.poppins())
    ];
  }
}