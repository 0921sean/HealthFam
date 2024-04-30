import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'style.dart' as style;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  runApp(
      MaterialApp(
        theme: style.theme,
        home: MyApp()
      )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int tab = 0; // Initialize tab index
  var data = [];
  List<String> names = ['권정호', '김세호', '김현빈', '신동훈', '이명건', '천승범', '황동근'];
  List<String> weekdayList = ['월', '화', '수', '목', '금', '토', '일'];

  String currentDate() {
    initializeDateFormatting('ko_KR', null);
    DateTime now = DateTime.now();
    DateFormat dateFormat = DateFormat('MM/dd (E)', 'ko_KR');
    String formattedDate = dateFormat.format(now);

    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(currentDate(),),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
      ),
      // appBar: AppBar( title: Text('💪 헬스팸',), backgroundColor: Colors.redAccent[400], ), //lightBlueAccent[400]
      body: [Home(names : names, data : data, weekdayList : weekdayList), Check(names : names, data : data), Text('기록페이지')][tab],
      // 홈화면 : 이번주 전체 진행상태, 체크화면 : 인증, 달력화면 : 총 기록
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: tab, // Add this line
          selectedItemColor: Colors.green, // The color of the icon and text when the item is selected
          onTap: (i){
            setState(() {
              tab = i;
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
            BottomNavigationBarItem(icon: Icon(Icons.check), label: '인증'),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: '기록'),
          ]
      ),
    );
  }
}

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({super.key});

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('4월 27일')
    );
  }
}


class Home extends StatefulWidget {
  const Home({super.key, this.names, this.data, this.weekdayList});
  final names, data, weekdayList;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  getWeekNum(String name) {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1)); // Get the start of the current week
    DateTime endOfWeek = now.add(Duration(days: DateTime.daysPerWeek - now.weekday)); // Get the end of the current week

    int count = widget.data.where((entry) =>
        entry['name'] == name &&
        DateTime.parse(entry['date']).isAfter(startOfWeek) &&
        DateTime.parse(entry['date']).isBefore(endOfWeek)
    ).length;

    // print('${name}: ${count}');
    return count;
  }

  // 이번주 횟수 계산
  weightNum(String name) {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1)); // Get the start of the current week
    DateTime endOfWeek = now.add(Duration(days: DateTime.daysPerWeek - now.weekday)); // Get the end of the current week

    int count = widget.data.where((entry) =>
        entry['name'] == name &&
        DateTime.parse(entry['date']).isAfter(startOfWeek) &&
        DateTime.parse(entry['date']).isBefore(endOfWeek)
    ).length;

    return count;
  }

  // 벌금 계산
  getPenalty(int count) {
    int penalty;
    final formatter = NumberFormat('#,##0', 'en_US');

    if (count > 3) {
      penalty = 0;
    } else {
      penalty = (3 - count) * 5000;
    }
    return formatter.format(penalty);
  }

  checkWeight(String name, int day) {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1)); // Get the start of the current week
    DateTime endOfWeek = now.add(Duration(days: DateTime.daysPerWeek - now.weekday)); // Get the end of the current week

    bool didWeight = widget.data.any((entry) =>
        entry['name'] == name &&
        DateTime.parse(entry['date']).weekday == day &&
        DateTime.parse(entry['date']).isAfter(startOfWeek) &&
        DateTime.parse(entry['date']).isBefore(endOfWeek)
    );

    return didWeight;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      return ListView.builder (
        itemCount: widget.names.length,
        itemBuilder: (c, i) {
          return Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  radius: 20,
                  backgroundColor: Color.fromRGBO(0, 0, 0, 0.05),
                  child: Text(
                    ['☹️', '🙁', '😏', '😁'][weightNum(widget.names[i])],
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                title: Text(
                  widget.names[i],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('${weightNum(widget.names[i])}/3'),
                trailing: Text('${getPenalty(weightNum(widget.names[i]))} 원'),
              ),
              // This adds a bottom border after each ListTile, including the last one
              Container(
                height: 1,
                color: Colors.grey[300],
              ),
            ],
          );
        }
      );
        // Column(
        // children: [
        //   Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //     children: [
        //       SizedBox(
        //         width: 60,
        //         child: Text('이름', style: TextStyle(fontWeight: FontWeight.w700),
        //           textAlign: TextAlign.center,
        //         ),
        //       ),
        //       SizedBox(
        //         width: 80,
        //         child: Text('이번주', style: TextStyle(fontWeight: FontWeight.w700),
        //           textAlign: TextAlign.center,
        //         ),
        //       ),
        //       SizedBox(
        //         width: 60,
        //         child: Text('벌금', style: TextStyle(fontWeight: FontWeight.w700),
        //           textAlign: TextAlign.center,
        //         ),
        //       ),
        //     ]
        //   ),
        //   Container(
        //     height : 500,
        //     child: ListView.builder(
        //       itemCount: widget.names.length,
        //       itemBuilder: (c, i){
        //         return Column(
        //           children: [
        //             Row(
        //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //               children: [
        //                 SizedBox(
        //                   width: 60,
        //                   child: Text('${widget.names[i]}',
        //                     textAlign: TextAlign.center,
        //                   ),
        //                 ),
        //                 SizedBox(
        //                   width: 80,
        //                   child: Text('${getWeekNum(widget.names[i]).toString()}/3',
        //                     textAlign: TextAlign.center,
        //                   ),
        //                 ),
        //                 SizedBox(
        //                   width: 60,
        //                   child: Text('${getPenalty(widget.names[i]).toString()}',
        //                     textAlign: TextAlign.right,
        //                   ),
        //                 )
        //               ]
        //             ),
        //             Row(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: [
        //                 for (var day in widget.weekdayList)
        //                 Container(
        //                   width: 50,
        //                   height: 50,
        //                   alignment: Alignment.center,
        //                   decoration: BoxDecoration(
        //                     color: checkWeight(widget.names[i], widget.weekdayList.indexOf(day)) == true
        //                       ? Colors.red[300] // Example background color
        //                       : Colors.grey[300], // Example background color
        //                     border: Border.all(color: Colors.black), // Example border
        //                   ),
        //                   child: Text(day),
        //                 )
        //               ]
        //             ),
        //           ],
        //         );
      //         },
      //       ),
      //     ),
      //   ],
      // );
  }
}


class Check extends StatefulWidget {
  const Check({super.key, this.names, this.data});
  final names;
  final data;

  @override
  State<Check> createState() => _CheckState();
}

class _CheckState extends State<Check> {
  String? _selectedName;
  String? _selectedImagePath;

  void _handleNameSelected(String? name) {
    setState(() {
      _selectedName = name;
    });
  }

  void _handleImageSelected(String? imagePath) {
    setState(() {
      _selectedImagePath = imagePath;
    });
  }

  void _handleSubmit() {
    // Handle submission logic here
    print('Name: $_selectedName');
    print('Image path: $_selectedImagePath');
    // Add logic to store the data
    if (_selectedName != null) {
      var newData = {
        'id': widget.data.length,
        'name': _selectedName,
        'image': _selectedImagePath,
        'date': DateTime.now().toString(),
        // 'date': '2024-04-21 06:35:30.869945',
      };
      setState(() {
        widget.data.add(newData);
      });
      print('Data: ${widget.data}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SelectInput(
            names: widget.names,
            onNameSelected: _handleNameSelected,
          ),
          ImageInputScreen(
            onImageSelected: _handleImageSelected,
          ),
          ElevatedButton(
            onPressed: _handleSubmit,
            child: Text('인증'),
          ),
        ],
      ),
    );
  }
}

class SelectInput extends StatefulWidget {
  final List<String> names;
  final ValueChanged<String?> onNameSelected; // Callback function to pass selected name to parent

  const SelectInput({
    Key? key,
    required this.names,
    required this.onNameSelected,
  }) : super(key: key);

  @override
  _SelectInputState createState() => _SelectInputState();
}

class _SelectInputState extends State<SelectInput> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedValue,
      hint: Text('이름'), // Hint text when no option is selected
      onChanged: (String? value) {
        setState(() {
          selectedValue = value;
          widget.onNameSelected(value); // Pass selected name back to parent widget
        });
      },
      items: widget.names.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class ImageInputScreen extends StatefulWidget {
  final ValueChanged<String?>? onImageSelected; // Define onImageSelected parameter

  const ImageInputScreen({
    Key? key,
    this.onImageSelected,
  }) : super(key: key);

  @override
  State<ImageInputScreen> createState() => _ImageInputScreenState();
}

class _ImageInputScreenState extends State<ImageInputScreen> {
  XFile? _image; //이미지를 담을 변수 선언
  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화

  //이미지를 가져오는 함수
  Future<void> getImage(ImageSource imageSource) async {
    //pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
    final XFile? pickedFile = await picker.pickImage(source: imageSource);

    if (pickedFile != null) {
      setState(() {
        // _image = XFile(pickedFile.path); //가져온 이미지를 _image에 저장
        _image = pickedFile;
        if (widget.onImageSelected != null) {
          widget.onImageSelected!(_image!.path); // Pass selected image path to parent widget
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 30, width: double.infinity),
        _buildPhotoArea(),
        SizedBox(height: 20),
        _buildButton(),
      ],
    );
  }

  Widget _buildPhotoArea() {
    return _image != null
        ? Container(
            width: 300,
            height: 300,
            child: Image.file(File(_image!.path)), //가져온 이미지를 화면에 띄워주는 코드
          )
        : Container(
            width: 300,
            height: 300,
            color: Colors.grey,
          );
  }

  Widget _buildButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            getImage(ImageSource.camera); //getImage 함수를 호출해서 카메라로 찍은 사진 가져오기
          },
          child: Text("카메라"),
        ),
        SizedBox(width: 30),
        ElevatedButton(
          onPressed: () {
            getImage(ImageSource.gallery); //getImage 함수를 호출해서 갤러리에서 사진 가져오기
          },
          child: Text("갤러리"),
        ),
      ],
    );
  }
}
