import 'package:flutter/material.dart';
import 'package:flutter_application_meal/neis_api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({
    super.key,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  dynamic mealList = const Text(
    '급식 정보를 알고 싶으시다면 \n 날짜를 선택해주세요!',
    style: TextStyle(fontSize: 30),
  );

  showCal() async {
    var dt = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2023, 3, 2),
        lastDate: DateTime(2023, 12, 30));
    String fromDate = dt.toString().split(' ')[0].replaceAll('-', '');
    String toDate = dt.toString().split(' ')[3].replaceAll('-', '');
    var neisApi = NeisApi();
    var meals = await neisApi.getMeal(fromDate: fromDate, toDate: toDate);

    setState(() {
      if (meals.isEmpty) {
        mealList = const Center(
          child: Text('결과가 텅텅'),
        );
      } else {
        mealList = ListView.separated(
            itemBuilder: (context, index) {
              return ListTile(
                  title: Text(meals[index]['MLSV_YMD']),
                  subtitle: Text(meals[index]['DDISH_NM']
                      .toString()
                      .replaceAll('<br/>', '\n')));
            },
            separatorBuilder: (context, index) => const Divider(),
            itemCount: meals.length);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Image.asset(
              'images/smile.png',
              height: 250,
            ),
            Expanded(child: mealList)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showCal,
        child: const Icon(Icons.calendar_month),
      ),
    );
  }
}
