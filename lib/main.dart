import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MostleeApp());
}

class MostleeApp extends StatelessWidget {
  const MostleeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mostlee',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8B9B7E),
          background: const Color(0xFFFAF7F2),
          surface: Colors.white,
          primary: const Color(0xFF6B7A5E),
          secondary: const Color(0xFFD98A6C),
        ),
        textTheme: GoogleFonts.nunitoTextTheme(),
      ),
      home: const MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final LatLng _moscowCenter = const LatLng(55.7558, 37.6173);

  String _selectedMode = 'Зелёный';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _modes = [
    {'name': 'Зелёный', 'icon': Icons.park_outlined, 'color': const Color(0xFF6B7A5E)},
    {'name': 'Исторический', 'icon': Icons.account_balance_outlined, 'color': const Color(0xFFD98A6C)},
    {'name': 'Тихий', 'icon': Icons.volume_off_outlined, 'color': const Color(0xFF7B8B9A)},
    {'name': 'Интересный', 'icon': Icons.storefront_outlined, 'color': const Color(0xFFE5A93C)},
    {'name': 'Долгий', 'icon': Icons.directions_walk_rounded, 'color': const Color(0xFF8E7C93)},
  ];

  void _showAiDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          top: 24,
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.auto_awesome, color: Color(0xFF6B7A5E), size: 28),
                const SizedBox(width: 10),
                Text(
                  'Mostlee AI',
                  style: GoogleFonts.nunito(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF6B7A5E),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Опишите вашу идеальную прогулку (например: «Хочу пройтись 40 минут через тихие дворики к уютной кофейне»):',
              style: TextStyle(color: Colors.black70, fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              autofocus: true,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Введите пожелания...',
                filled: true,
                fillColor: const Color(0xFFFAF7F2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B7A5E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('ИИ подбирает маршрут: "${_searchController.text}"'),
                      backgroundColor: const Color(0xFF6B7A5E),
                    ),
                  );
                },
                child: const Text(
                  'Построить маршрут',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _moscowCenter,
              initialZoom: 14.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://a.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}@2x.png',
                userAgentPackageName: 'com.mostlee.app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _moscowCenter,
                    width: 44,
                    height: 44,
                    child: GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Вы находитесь в центре Москвы')),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFD98A6C),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: const [
                            BoxShadow(color: Colors.black26, blurRadius: 10),
                          ],
                        ),
                        child: const Icon(Icons.my_location, color: Colors.white, size: 22),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: _showAiDialog,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.auto_awesome, color: Color(0xFF6B7A5E)),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Mostlee AI: куда отправимся?',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Настройки слоёв карты')),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(0xFFFAF7F2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.tune_rounded, color: Color(0xFFD98A6C), size: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 16,
            bottom: 100,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              elevation: 4,
              onPressed: () {
                _mapController.move(_moscowCenter, 14.0);
              },
              child: const Icon(Icons.center_focus_strong, color: Color(0xFF6B7A5E)),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _modes.length,
                itemBuilder: (context, index) {
                  final mode = _modes[index];
                  final isSelected = _selectedMode == mode['name'];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedMode = mode['name'];
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Выбран режим: ${_selectedMode}'),
                          duration: const Duration(milliseconds: 800),
                        ),
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? mode['color'] : Colors.white.withOpacity(0.92),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            mode['icon'],
                            color: isSelected ? Colors.white : mode['color'],
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            mode['name'],
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
