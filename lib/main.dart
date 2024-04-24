import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'style.dart' as style;

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
  List<String> names = ['권정호', '김세호', '김현빈', '신동훈', '이명건', '천승범', '황동근'];
  var data = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: Text('💪 헬스팸',), backgroundColor: Colors.lightBlueAccent[400], ),
      //redAccent[400]
      body: [Home(names : names), Text('기록페이지')][tab],
      bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: (i){
            setState(() {
              tab = i;
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: '기록'),
          ]
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key, this.names});
  final List<String>? names;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
    // var addData = {
    //   'id': data.length,
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SelectInput(
            names: widget.names ?? [],
            onNameSelected: _handleNameSelected,
          ),
          ImageInputScreen(
            onImageSelected: _handleImageSelected,
          ),
          ElevatedButton(
            onPressed: _handleSubmit,
            child: Text('인증완료'),
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
