import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_tribe_ug/Radio.dart';
import 'package:the_tribe_ug/Screens/signup_screen.dart';
import 'package:the_tribe_ug/Tv.dart';
import 'Events.dart';
import 'Feed/Feed.dart';
import 'article.dart';
import 'database_helper.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized

  //1
WidgetsFlutterBinding.ensureInitialized();
//2
await Firebase.initializeApp();


  Hive // Initialize Hive for Flutter
    .registerAdapter(ArticleAdapter());

  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  // Open the Hive box for 'articles'
  await Hive.openBox<Article>('articles');

  runApp(const MyApp()); // Your app's widget tree
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Define your custom primary color
    MaterialColor customPrimaryColor =
    const MaterialColor(0xFF000000, <int, Color>{
      50: Color(0xFF000000),
      100: Color(0xFF000000),
      200: Color(0xFF000000),
      300: Color(0xFF000000),
      400: Color(0xFF000000),
      500: Color(0xFF000000),
      600: Color(0xFF000000),
      700: Color(0xFF000000),
      800: Color(0xFF000000),
      900: Color(0xFF000000),
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: customPrimaryColor,
      ),
      //home: SplashScreen(),
      // home: MainScreen(),
      // home: const LoginScreen(),
      home: const SignupScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 1;


  final List<Widget> _pages = [
    const tribeTv(),
    const feed(),
    const tribeRadio(),
    const Events()
    // Add more screens here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const Drawer(
        surfaceTintColor: Colors.black,
        child: MyDrawer(),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        elevation: 0,
        toolbarHeight: 80,
        centerTitle: false, // Don't center-align the content
        title: const Image(
          image: AssetImage("assets/images/logo.png"),
          width: 130,
          height: 130, // Adjust the logo height as needed
        ),

        actions: [
          GestureDetector(
            onTap: (){
              _scaffoldKey.currentState?.openDrawer();
            },
            child: const Image(image: AssetImage("assets/images/menu.png"),
              width: 26,
              height: 26,),
          ),
          const SizedBox(
            width: 15,
          ),
          ProfilePictureWidget(imageUrl: '', onImageChanged: (String value) {  },),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        animationDuration: const Duration(milliseconds: 400),
        backgroundColor: Colors.transparent, // Customize the background color
        color: Colors.black, // Customize the active item color
        buttonBackgroundColor: Colors.black, // Customize the inactive item color
        height: 50, // Adjust the height as needed
        index: 1,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          Icon(Icons.live_tv_outlined, size: 26, color: Colors.red,),
          Icon(Icons.featured_play_list_outlined, size: 26, color: Colors.red,),
          Icon(Icons.podcasts, size: 26, color: Colors.red,),
          Icon(Icons.insert_invitation, size: 26, color: Colors.red,),
          // Add more items as needed
        ],
      ),
    );
  }
}

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String? firstName, lastLogin, lastName;

  @override
  initState() {
    super.initState();
    getUserInfo();
  }

  getUserInfo() async {
    // await _profileRepo.getUserInfo(UserAccountData.FirstName).then((value) {
    //   setState(() {
    //     firstName = value;
    //   });
    // });
    // await _profileRepo
    //     .getUserInfo(UserAccountData.LastLoginDateTime)
    //     .then((value) {
    //   setState(() {
    //     lastLogin = value;
    //   });
    // });
    // await _profileRepo.getUserInfo(UserAccountData.LastName).then((value) {
    //   setState(() {
    //     lastName = value;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) => Container(
    color: Colors.black,
    child: ListView(
      children: <Widget>[
        Padding(padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                        color: Colors.cyan,
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: const Image(
                      image: AssetImage("assets/images/dp.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text("Tendo Abraham",
                    // "$firstName $lastName",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: "Myriad Pro"
                    ),)
                ],
              ),
            ),
          ),),
        const SizedBox(
          height: 60,
        ),
        ListTile(
          title: const Text('Profile',
            style: TextStyle(
                fontFamily: "Myriad Pro",
                fontSize: 17,
                color: Colors.white
            ),),
          leading: const Image(image: AssetImage("assets/images/profile1.png"),
            width: 35,
            height: 35,),
          onTap: () {
            // CommonUtils.navigateToRoute(
            //     context: context, widget: const ProfileScreen());
          },
        ),
        ListTile(
          title: const Text('Web',
            style: TextStyle(
                fontFamily: "Myriad Pro",
                fontSize: 17,
                color: Colors.white

            ),),
          leading: const Image(image: AssetImage("assets/images/web4.png"),
            width: 35,
            height: 35,),
          onTap: () {
            // _moduleRepository.getModuleById("PIN").then((module) {
            //   CommonUtils.navigateToRoute(
            //       context: context,
            //       widget: DynamicWidget(
            //         moduleItem: module,
            //       ));
            // });
          },
        ),
        ListTile(
          title: const Text('Support the hustle',
            style: TextStyle(
                fontFamily: "Myriad Pro",
                fontSize: 17,
                color: Colors.white
            ),),
          leading: const Image(image: AssetImage("assets/images/send1.png"),
            width: 40,
            height: 40,),
          onTap: () {
            // Handle item 1 tap
          },
        ),
        const SizedBox(
          height: 60,
        ),
        ListTile(
          title: const Text('Logout',
            style: TextStyle(
                fontFamily: "Myriad Pro",
                fontSize: 17,
                color: Colors.white
            ),),
          leading: const Image(image: AssetImage("assets/images/logout3.png"),
            width: 40,
            height: 40,),
          onTap: () {
            // AlertUtil.showAlertDialog(context, "Are you sure you want to Logout?",
            //     confirmButtonText: "Yes",
            //     isConfirm: true)
            //     .then((value) {
            //   if (value) {
            //     // Navigate to the login screen
            //     CommonUtils.navigateToRoute(
            //         context: context, widget: const Dashboard());
            //   }
            // }) ??
            //     false;
          },
        ),
      ],
    ),
  );
}

class ProfilePictureWidget extends StatefulWidget {
  final String imageUrl;
  final ValueChanged<String> onImageChanged;


  const ProfilePictureWidget({super.key, required this.imageUrl, required this.onImageChanged});

  @override
  _ProfilePictureWidgetState createState() => _ProfilePictureWidgetState();
}

class _ProfilePictureWidgetState extends State<ProfilePictureWidget> {
  final ImagePicker _imagePicker = ImagePicker();
  // final _sharedPref = CommonSharedPref();
  File? customerDPFile;
  String? dpImgString;
  bool isDpSet = false;
  Uint8List? dp;
  late Map<String, dynamic> imageData;

  Future<void> _showImageSourceDialog() async {
    // _sharedPref.setIsListeningToFocusState(false);
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Choose Image Source"),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                _getFromCamera();
              },
              child: const Text("Take Photo"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                _getFromGallery();
              },
              child: const Text("Choose from Gallery"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // _sharedPref.setIsListeningToFocusState(true);
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    _cropImage(pickedFile?.path);
  }

  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    _cropImage(pickedFile?.path);
  }

  /// Crop Image
  _cropImage(filePath) async {
    File croppedImage = (await ImageCropper().cropImage(
        sourcePath: filePath,
        maxWidth: 1080,
        maxHeight: 1080,
        aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0)
    )) as File;

    customerDPFile = croppedImage;
    final Uint8List imageBytes = await croppedImage.readAsBytes();
    final String base64Image = base64Encode(imageBytes);
    dpImgString = base64Image;
    // print("Base64 Encoded Image String: $customerPhoto");
    // if  (isDpSet){
    //   updateProfilePicture(dpImgString!);
    // }else{
    //   saveProfilePicture(dpImgString!);
    // }
    setState(() {
      isDpSet = true;
      dp = imageBytes;
    });

    // _sharedPref.setIsListeningToFocusState(true);
  }

  void saveProfilePicture(String image){
    // DatabaseHelper.instance.insertProfileImage(image);
    // final _api_service = APIService();
    // _api_service.setDp(image).then((value){
    //   if (value.status == StatusCode.success.statusCode){
    //     String results =  value.dynamicList.toString();
    //     print(results);
    //
    //   }
    // }
    // );
  }

  void updateProfilePicture(String image){
    DatabaseHelper.instance.updateImage(image);
    // final _api_service = APIService();
    // _api_service.updateDp(image).then((value){
    //   if (value.status == StatusCode.success.statusCode){
    //     String results =  value.dynamicList.toString();
    //     print(results);
    //   }
    // }
    // );
  }

  getProfilePicture() async {
    final localImageString = await DatabaseHelper.instance.getProfileImage();
    if (localImageString != null) {
      setState(() {
        dpImgString = localImageString;
        isDpSet = true;
        dp = base64Decode(localImageString);
      });
    }else{
      String? image;
      // final _api_service = APIService();
      // _api_service.getDp().then((value){
      //   if (value.status == StatusCode.success.statusCode){
      //     imageData =  value.dynamicList?.elementAt(0);
      //     print(imageData);
      //     imageData.forEach((key, value) {
      //       image = value;
      //
      //       setState(() {
      //         dp = Uint8List.fromList(base64.decode(image!));
      //         isDpSet = true;
      //       });
      //     });
      //   }
      // }
      // );
    }
  }

  @override
  void initState() {
    super.initState();
    getProfilePicture();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showImageSourceDialog,
      child: isDpSet?
      Image.memory(
        dp!,
        fit: BoxFit.scaleDown,
        width: 30,
        height: 30,
      )
          :
      Container(
        width: 30,
        height: 30,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.zero,
          image: DecorationImage(
            image: AssetImage("assets/images/dp.png"),
          ),
        ),
      ),
    );
  }
}