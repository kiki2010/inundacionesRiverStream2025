// home_page.dart

// FlutterのMaterialパッケージをインポート / Import Flutter Material package
import 'package:flutter/material.dart';
import 'package:river_stream_unlimited_tech/generated/l10n.dart';

// 5つの画面をインポート / Import five different screens
import 'post.dart';       // 投稿画面 / Post screen
import 'map.dart';        // 地図画面 / Map screen
import 'risk.dart';       // リスク画面 / Risk screen
import 'simulate.dart';   // シミュレーション画面 / Simulation screen
import 'setting.dart';    // 設定画面 / Setting screen

List<Map<String, dynamic>> selectedRivers = [];

// HomePageウィジェットの定義 / Define HomePage widget
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  // 状態を生成 / Create state
  @override
  HomePageState createState() => HomePageState();
}

// HomePageStateクラス / State class for HomePage
class HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    // Mostrar el disclaimer solo al inicio
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDisclaimerDialog(context);
    });
  }

  // 画面のインデックス: 0:post, 1:map, 2:risk, 3:simulate, 4:setting / Screen index
  int _currentIndex = 0;

  // 表示する画面のリスト / List of screens to display
  final List<Widget> _screens = [
    const PostScreen(),
    const MapScreen(),
    RiskScreen(selectedRivers: selectedRivers),
    const SimulateScreen(),
    SettingScreen(selectedRivers: selectedRivers),
  ];

  // タップ時の処理 / Handle bottom navigation tap
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // BottomNavigationBarの項目定義 / Define BottomNavigationBar items
  final List<BottomNavigationBarItem> _items = [
    BottomNavigationBarItem(
      icon: Icon(Icons.post_add),
      label: S.current.post,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.map),
      label: S.current.map
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.warning),
      label: S.current.risk,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.waves),
      label: S.current.simulate,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: S.current.setting,
    ),
  ];

  // ウィジェットをビルド / Build widget
  @override
  Widget build(BuildContext context) {
    // 現在表示する画面を取得 / Get currently displayed screen
    final currentScreen = _screens[_currentIndex];

    return Scaffold(
      body: currentScreen, // 画面本体 / Main content

      // 画面下部のナビゲーションバー / Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        items: _items,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,

        // 5個以上なら固定推奨 / Use 'fixed' for 5 or more items
        type: BottomNavigationBarType.fixed,

        // 選択中のアイテム色 / Color for selected item
        selectedItemColor: Colors.blue,
        // 未選択のアイテム色 / Color for unselected items
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}


//Disclaimer
void showDisclaimerDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      title: Text("Disclaimer"),
      content: SingleChildScrollView(
        child: Text(
          "This app is designed to predict the likelihood of floods using user-submitted data and external weather sources.\n\n"
          "The simulation screen included in this app is primarily intended to raise awareness about disasters and should be used as a reference only.\n\n"
          "For actual evacuation and safety measures, always follow the instructions of local authorities.\n\n"
          "The developers assume no responsibility for any damage or loss resulting from the use of this app.",
          style: TextStyle(fontSize: 14),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("I Understand"),
        ),
      ],
    ),
  );
}