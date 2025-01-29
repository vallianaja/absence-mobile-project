import 'package:absensi/ui/attend/attend_screen.dart';
import 'package:absensi/ui/attend_history/attend_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'absen/absen_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,//biar mengunci tombol back perangkat
    onPopInvoked: (bool didpop){
        if(didpop){
          return;
        }
        _onWillPop(context);
    },
        child:
    Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Center(
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: Expanded(
                        child: InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const AttendScreen()));
                          },
                          child: const Column(
                            children: [
                              Image(image: AssetImage('assets/img/ic_absen.png'),
                                width: 100,
                                height: 100,),
                              Text('Absen Kehadiran')
                            ],
                          ),
                        )
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: Expanded(
                        child: InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const AbsenScreen()));
                          },
                          child: const Column(
                            children: [
                              Image(image: AssetImage('assets/img/ic_leave.png'),
                                width: 100,
                                height: 100,),
                              Text('Izin/cuti')
                            ],
                          ),
                        )
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: Expanded(
                        child: InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const AttendHistoryScreen()));
                          },
                          child: const Column(
                            children: [
                              Image(image: AssetImage('assets/img/ic_history.png'),
                                width: 100,
                                height: 100,),
                              Text('History Absen')
                            ],
                          ),
                        )
                    ),
                  ),
                ],
              )
          )
      ),
    ));

  }
}


Future <bool> _onWillPop(BuildContext context) async {
  return (await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Info!!'),
      content: Text('Apakah anda yakin inggin keluar dari applikasi?'),
      actions: [
        TextButton(
          child: const Text('Batal'),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        TextButton(
          child: const Text('Keluar'),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    )
  )
  )??false; // jika dialog ditutup tanpa aksi mana aka akan dikembalikan false
}
