/// setting.dart

// FlutterのMaterialパッケージをインポート / Import Flutter Material package
import 'package:flutter/material.dart';
import 'package:river_stream_unlimited_tech/generated/l10n.dart';
import 'package:river_stream_unlimited_tech/services/notifications_services.dart.dart';
import 'package:river_stream_unlimited_tech/settings_provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'language_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

class SettingScreen extends StatefulWidget {
  final List<Map<String, dynamic>> selectedRivers;
  const SettingScreen({Key? key, required this.selectedRivers}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final String url1 = "https://www.redcross.org/get-help/how-to-prepare-for-emergencies/types-of-emergencies/flood.html?srsltid=AfmBOopQGNmMBHITml4C2tKQ29DmIrHjzzAQxL8_eSlqHnE1O5zKQwnj";
  final String url2 = "https://www.weather.gov/safety/flood-during";
  bool isOn = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      print("error");
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = Provider.of<LanguageProvider>(context).currentLocale;

    return Scaffold(
      // Scaffold全体の背景を白に設定
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(S.current.settings), // ← タイトルバーのデザインは変えない
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        // 全体的に余白を持たせる
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 川選択画面へ遷移するボタン
              InkWell(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RiverSelectionScreen(),
                    ),
                  );
                  if (result != null && result is List<Map<String, dynamic>>) {
                    setState(() {
                      widget.selectedRivers.clear();
                      widget.selectedRivers.addAll(result);
                    });
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  decoration: BoxDecoration(
                    // 水色をアクセントカラーに
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    S.current.buttonSettingSelectRiver,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      // ボタンの文字色は白
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              // 言語選択Row
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      S.current.language,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: 10),
                    DropdownButton<String>(
                      value: currentLocale.languageCode,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          Provider.of<LanguageProvider>(context, listen: false)
                              .setLanguage(newValue);
                        }
                      },
                      items: const [
                        DropdownMenuItem<String>(
                          value: 'en',
                          child: Text("English"),
                        ),
                        DropdownMenuItem<String>(
                          value: 'es',
                          child: Text("Español"),
                        ),
                        DropdownMenuItem<String>(
                          value: 'ja',
                          child: Text("日本語"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 通知設定Row
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      S.current.notifications,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: 10),
                    Consumer<SettingsProvider>(
                      builder: (context, settingsProvider, child) {
                        return Switch(
                          value: settingsProvider.isBackgroundTaskEnabled,
                          onChanged: (value) {
                            settingsProvider.toggleBackgroundTask(value);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),

              // アドバイス関連コンテンツ
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      S.current.advicetext,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          // ボタンの背景を水色、文字を白
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () => _launchURL(url1),
                          child: Text(S.current.floodSafety),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () => _launchURL(url2),
                          child: Text(S.current.duringAFlood),
                        ),
                      ],
                    ),
                    ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            print("Ajustes");
                            showNotification();
                          },
                          child: Text("Test Notificacion"),
                        ),
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

// Screen for selecting rivers
class RiverSelectionScreen extends StatefulWidget {
  const RiverSelectionScreen({Key? key}) : super(key: key);

  @override
  _RiverSelectionScreenState createState() => _RiverSelectionScreenState();
}

class _RiverSelectionScreenState extends State<RiverSelectionScreen> {
  final Set<String> selectedRiverNames = {};
  List<Map<String, dynamic>> allRivers = [];
  List<Map<String, dynamic>> filteredRivers = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSelectedRivers();
    _fetchRivers();
  }

  Future<Position> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
        throw Exception("Permiso de ubicación denegado");
      }
    }
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> _fetchRivers() async {
    try {
      final userPosition = await _getCurrentLocation();

      final snapshot = await FirebaseFirestore.instance.collection('rivers').get();
      List<Map<String, dynamic>> rivers = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final latitude = data['Coordinates']?['Latitude'];
        final longitude = data['Coordinates']?['Longitude'];

        if (latitude == null || longitude == null) return null;

        final distance = Geolocator.distanceBetween(
          userPosition.latitude,
          userPosition.longitude,
          latitude,
          longitude,
        );

        return {
          ...data,
          'distance': distance,
        };
      }).whereType<Map<String, dynamic>>().toList();

      rivers.sort((a, b) => (a['distance'] as double).compareTo(b['distance'] as double));

      setState(() {
        allRivers = rivers;
        filteredRivers = allRivers;
      });
    } catch (e) {
      print("Error al obtener ríos o ubicación: $e");
    }
  }

  void _filterRivers(String query) {
    setState(() {
      filteredRivers = allRivers.where((river) {
        final name = (river['RiverName'] ?? '').toLowerCase();
        return name.contains(query.toLowerCase());
      }).toList();
    });
  }

  Future<void> _saveSelectedRivers(List<Map<String, dynamic>> selectedRivers) async {
    final prefs = await SharedPreferences.getInstance();
    final riversAsJson = selectedRivers.map((river) => jsonEncode(river)).toList();
    await prefs.setStringList('SelectedRivers', riversAsJson);
  }

  Future<void> _loadSelectedRivers() async {
    final prefs = await SharedPreferences.getInstance();
    final riversAsJson = prefs.getStringList('SelectedRivers');
    if (riversAsJson != null) {
      setState(() {
        selectedRiverNames.addAll(riversAsJson.map((riverJson) {
          final river = jsonDecode(riverJson);
          return (river['RiverName'] ?? '') as String;
        }));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Select Rivers"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: "Search Rivers",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _filterRivers,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredRivers.length,
              itemBuilder: (context, index) {
                final river = filteredRivers[index];
                final riverName = river['RiverName'] as String;
                final isSelected = selectedRiverNames.contains(riverName);
                final distance = river['distance'] as double?;
                final distanceText = distance != null
                    ? " (${(distance / 1000).toStringAsFixed(1)} km)"
                    : "";

                return ListTile(
                  title: Text("$riverName$distanceText"),
                  trailing: Checkbox(
                    value: isSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          if (selectedRiverNames.length < 5) {
                            selectedRiverNames.add(riverName);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("You can only select up to 5 rivers")),
                            );
                          }
                        } else {
                          selectedRiverNames.remove(riverName);
                        }
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddRiverScreen()),
                );
              },
              child: const Icon(Icons.add),
              tooltip: "Add river",
              backgroundColor: Colors.lightBlue,
              foregroundColor: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () async {
                final selectedRivers = allRivers
                    .where((river) => selectedRiverNames.contains(river['RiverName']))
                    .toList();
                await _saveSelectedRivers(selectedRivers);
                if (mounted) {
                  Navigator.pop(context, selectedRivers);
                }
              },
              child: const Text("Confirm Selection"),
            ),
          ),
        ],
      ),
    );
  }
}

// Screen for adding rivers
class AddRiverScreen extends StatefulWidget {
  @override
  _AddRiverScreenState createState() => _AddRiverScreenState();
}

class _AddRiverScreenState extends State<AddRiverScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();

  bool isLoading = false; 

  @override
  Widget build(BuildContext context) {
    final CollectionReference rivers = FirebaseFirestore.instance.collection('rivers');

    return Scaffold(
      backgroundColor: Colors.white, // 背景色を白
      appBar: AppBar(
        title: Text(S.current.addNew), // タイトルバーのデザインは変えない
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // 余白を多めに
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // 川の名前
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: S.current.nameRiver,
                  // テキストフィールドのデザイン(軽め)
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return S.current.plsAddRiverName;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // 州/都道府県
              TextFormField(
                controller: stateController,
                decoration: InputDecoration(
                  labelText: S.current.stateoProvince,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return S.current.plsAddStateProvince;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // 国
              TextFormField(
                controller: countryController,
                decoration: InputDecoration(
                  labelText: S.current.countryform,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return S.current.plsAddcountry;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // 緯度
              TextFormField(
                controller: latitudeController,
                decoration: InputDecoration(
                  labelText: S.current.plsAddLatitude,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      double.tryParse(value) == null) {
                    return S.current.plsAddLatitude;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // 経度
              TextFormField(
                controller: longitudeController,
                decoration: InputDecoration(
                  labelText: S.current.length,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      double.tryParse(value) == null) {
                    return S.current.plsAddLenght;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // 保存ボタン or ローディングインジケータ
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue, // 水色
                  foregroundColor: Colors.white,      // 文字色
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      isLoading = true;
                    });

                    try {
                    
                      String riverName = nameController.text.trim();
                      String country = countryController.text.trim();
                      String docId = "${riverName}_${country}"
                          .replaceAll(" ", "_")
                          .toLowerCase();

                      final newRiver = {
                        'RiverName': riverName,
                        'State': stateController.text,
                        'Country': country,
                        'Coordinates': {
                          'Latitude':
                          double.parse(latitudeController.text),
                          'Longitude':
                          double.parse(longitudeController.text),
                        },
                      };

                      await rivers.doc(docId).set(newRiver);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(S.current.riverAdded)),
                      );
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(S.current.errorAddingRiver(e)),
                        ),
                      );
                    } finally {
                      setState(() {
                        isLoading = false;
                      });
                    }
                  }
                },
                child: Text(S.current.save),
              ),
            ],
          ),
        ),
      ),
    );
  }
}