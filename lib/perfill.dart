import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int? _expandedIndex;
  int? _hoverIndex;
  Map<String, dynamic> userData = {}; // Inicializamos vacío

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Cargar datos desde Supabase
  }

  // Función para obtener datos de Supabase
  Future<void> fetchUserData() async {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;

    try {
      final response = await supabase.from('perfil_information').select().limit(1).single();

      if (response != null) {
        setState(() {
          userData = {
            "Información Personal": {
              "Nombres": response['nombres'] ?? '',
              "Apellidos": response['apellidos'] ?? '',
              "Fotografía": response['fotografia'] ?? '',
              "Correo electrónico": response['correo'] ?? '',
              "Nacionalidad": response['nacionalidad'] ?? '',
              "Fecha de nacimiento": response['fecha_nacimiento'] ?? '',
            },
            "Experiencia Laboral": response['experiencia_laboral'] ?? 'No hay info',
            "Educación": response['educacion'] ?? [],
            "Habilidades": response['habilidades'] ?? [],
          };
        });
      }
    } catch (error) {
      print("Error al obtener los datos: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Icon(Icons.person,color: Color(0xFF25AD4C),),leadingWidth: 60,
        title: Text("Información del Perfil"),
        titleSpacing: 0,
        backgroundColor: Colors.white54,
        shadowColor: Colors.black12,
        bottomOpacity: 1,
        surfaceTintColor: Colors.black26,
      ),
      body: userData.isEmpty
          ? Center(child: CircularProgressIndicator()) // Muestra un indicador de carga
          : SingleChildScrollView(
        child: ExpansionPanelList(
          dividerColor: Colors.transparent,
          animationDuration: Duration(milliseconds: 400),
          elevation: 0,
          expansionCallback: (index, _) {
            setState(() {
              _expandedIndex = (_expandedIndex == index) ? null : index;
            });
          },
          children: _buildPanels(),
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
        backgroundColor: Colors.white54,
        headerBuilder: (context, isExpanded) {
          return MouseRegion(
            onEnter: (_) => setState(() => _hoverIndex = index),
            onExit: (_) => setState(() => _hoverIndex = null),
            child: InkWell(
              onTap: () {
                setState(() {
                  _expandedIndex = (_expandedIndex == index) ? null : index;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(),
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10) ,
                  color: _hoverIndex == index ? Color(0xFF7d19e6).withOpacity(0.6) : Color(0xFF64319b),
                ),
                child: Row(
                  children: [
                    Icon(
                      // 0xFF25AD4C -> magneto green
                      isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                      color: Colors.black45,
                    ),
                   // SizedBox(width: 10),
                    Text(
                      category,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },

        body: Container(
          decoration: BoxDecoration(

              color: Colors.white54, borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.all(0),
          child: _buildContent(content),
        ),
        isExpanded: _expandedIndex == index,
      );
    });
  }

  Widget _buildContent(dynamic content) {
    if (content is List) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: content.map((item) {
          if (item is Map) {
            return Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: item.entries.map((entry) => Text("${entry.key}: ${entry.value}")).toList(),
              ),
            );
          } else {
            return Text(item.toString());
          }
        }).toList(),
      );
    } else if (content is Map) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: content.entries.map((entry) {
          if (entry.key == "Fotografía" && entry.value.isNotEmpty) {
            return Image.network(entry.value, height: 100, width: 100);
          }
          return Text("${entry.key}: ${entry.value}");
        }).toList(),
      );
    } else {
      return Text("No hay información disponible");
    }
  }
}
