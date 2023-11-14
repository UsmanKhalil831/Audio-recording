import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late AudioPlayer audioPlayer;
  String audioPath = '';

  @override
  void initState() {
    audioPlayer = AudioPlayer();
    initRecorder();
    super.initState();
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    audioPlayer.dispose();
    super.dispose();
  }

  final recorder = FlutterSoundRecorder();
  
  
  Future initRecorder() async{
    final status = await Permission.microphone.request();
    if(status != PermissionStatus.granted){
      throw 'Permission not granted';
    }
    await recorder.openRecorder();
    recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  Future startRecord() async{
    await recorder.startRecorder(toFile: 'audio');
  }

  Future stopRecord() async{
    final filePath = await recorder.stopRecorder();
    audioPath = filePath!;
    final file = File(filePath!);
    print('recorded file path = $file');
  }

  Future<void> playRecording() async{
     try{
      Source urlSource = UrlSource(audioPath);
      await audioPlayer.play(urlSource);
    }
    catch(e){
      print('error: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(onPressed: () async{
            if(recorder.isRecording){
              await stopRecord();
              setState(() {
                
              });
            }
            else{
                await startRecord();
                setState(() {
                  
                });
            }
          }, child: Icon(recorder.isRecording ? Icons.stop : Icons.mic)),
          if(!recorder.isRecording && audioPath != null)
            ElevatedButton(onPressed: (){
              playRecording();
            }, child: const Text('Play Recording'))
        ],
      ),),
    );
  }
}