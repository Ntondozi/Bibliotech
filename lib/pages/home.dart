
import 'package:flutter/material.dart';
import 'package:kshieldauth/pages/dispo.dart';
import 'package:kshieldauth/pages/emprunt.dart';
import 'package:kshieldauth/pages/retard.dart';
import 'package:kshieldauth/pages/return.dart';
import 'package:kshieldauth/pages/stock.dart';
import 'package:kshieldauth/pages/users.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    var blue = Color(0xFF125695);
    var white = Color(0xFFFFFFFF);
    var black = Colors.black;
    var back = Color(0xFFE2ECF6);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    var iStablette = width < 735 && width > 450;
    var iSdesktop2 = width > 450;
    var iSmobile = width < 550;
    var iSdesktop = width > 735;
    var size = width/2;
    

    print(width);
    print(height);

    return Scaffold(
      body: iSmobile? Container(
        height: double.infinity,
        width: double.infinity,
        color: blue,
        child: SingleChildScrollView(
          child: Column(
            children: [
          
              if(iSmobile) Stack(
                  children: [
                     Container(
                      height: 400,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage('assets/images/ss.jpg',), fit: BoxFit.cover),
                        color: Colors.red,
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(80))
                      ),
                     
                    ),
                    
                    Positioned(
                      bottom: 5,
                      left: 10,
                      child: Text('BiblioTech', style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold, color: blue
                      ),)
                      ),
                  ],
                ),
                SizedBox(height: iSmobile? 10 : 230),
          
                Text('Système de Gestion de Bibliothèque',style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: back), textAlign:  TextAlign.center,),
              SizedBox(height: iSmobile? 5 : 20,),
          
              Container(
                margin: EdgeInsets.all(5),
                width: 300,
                height: 45,
                decoration: BoxDecoration(
                  color: back,
                  borderRadius: BorderRadius.circular(7)
                ),
                child: ElevatedButton.icon(
                  icon: Icon(Icons.menu_book_sharp, size: 25,),
                  onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => BorrowBookPage(),));
                }, label: Text('Emprunter un Livre', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)),
              ),

              
              Container(
                margin: EdgeInsets.all(5),
                width: 300,
                height: 45,
                decoration: BoxDecoration(
                  color: back,
                  borderRadius: BorderRadius.circular(7)
                ),
                child: ElevatedButton.icon(
                  icon: Icon(Icons.arrow_back_ios_new, size: 25,),
                  onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ReturnBookPage(),));
                }, label: Text('Retourner un Livre', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)),
              ),
              Container(
                margin: EdgeInsets.all(5),
                width: 300,
                height: 45,
                decoration: BoxDecoration(
                  color: back,
                  borderRadius: BorderRadius.circular(7)
                ),
                child: ElevatedButton.icon(
                  icon: Icon(Icons.manage_history_outlined, size: 25,),
                  onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StockManagementPage(),));
                }, label: Text('Stock Disponible', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)),
              ),
          
              Container(
                margin: EdgeInsets.all(5),
                width: 300,
                height: 45,
                decoration: BoxDecoration(
                  color: back,
                  borderRadius: BorderRadius.circular(7)
                ),
                child: ElevatedButton.icon(
                  icon: Icon(Icons.person, size: 25,),
                  onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => UserManagementPage(),));
                }, label: Text('Gestion Des Utilisateurs', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)),
              ),
              
              Container(
                margin: EdgeInsets.all(5),
                width: 300,
                height: 45,
                decoration: BoxDecoration(
                  color: back,
                  borderRadius: BorderRadius.circular(7)
                ),
                child: ElevatedButton.icon(
                  icon: Icon(Icons.warning_sharp, size: 25,),
                  onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DelayManagementPage(),));
                }, label: Text('Gestion des Retards', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)),
              ),

              
          
            ],
          ),
        ),
      ): Container(
        height: double.infinity,
        width: double.infinity,
           
        child: SingleChildScrollView(

          child: Container(
                margin: EdgeInsets.only(left: width/4, right: width/4, bottom: height/7.5, top: height/7.5),
              width: width/2,
                  height: 550,
                  
              decoration: BoxDecoration(
                  color: blue,
                  borderRadius: BorderRadius.circular(25)
              ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
              
                    // SizedBox(height: iSmobile? 10 : 230),
              
                  Text('Système de Gestion de Bibliothèque',style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: back), textAlign:  TextAlign.center,),
                  SizedBox(height: iSmobile? 5 : 20,),
              
                  Container(
                    margin: EdgeInsets.all(5),
                    width: 300,
                    height: 45,
                    decoration: BoxDecoration(
                      color: back,
                      borderRadius: BorderRadius.circular(7)
                    ),
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.menu_book_sharp, size: 25,),
                      onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => BorrowBookPage(),));
                    }, label: Text('Emprunter un Livre', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)),
                  ),
            
                  
                  Container(
                    margin: EdgeInsets.all(5),
                    width: 300,
                    height: 45,
                    decoration: BoxDecoration(
                      color: back,
                      borderRadius: BorderRadius.circular(7)
                    ),
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.arrow_back_ios_new, size: 25,),
                      onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ReturnBookPage(),));
                    }, label: Text('Retourner un Livre', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)),
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    width: 300,
                    height: 45,
                    decoration: BoxDecoration(
                      color: back,
                      borderRadius: BorderRadius.circular(7)
                    ),
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.manage_history_outlined, size: 25,),
                      onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => StockManagementPage(),));
                    }, label: Text('Stock Disponible', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)),
                  ),
              
                  Container(
                    margin: EdgeInsets.all(5),
                    width: 300,
                    height: 45,
                    decoration: BoxDecoration(
                      color: back,
                      borderRadius: BorderRadius.circular(7)
                    ),
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.person, size: 25,),
                      onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => UserManagementPage(),));
                    }, label: Text('Gestion Des Utilisateurs', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)),
                  ),
                  
                  Container(
                    margin: EdgeInsets.all(5),
                    width: 300,
                    height: 45,
                    decoration: BoxDecoration(
                      color: back,
                      borderRadius: BorderRadius.circular(7)
                    ),
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.warning_sharp, size: 25,),
                      onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DelayManagementPage(),));
                    }, label: Text('Gestion des Retards', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)),
                  ),
              
                ],
              ),
          ),
        ),
      )
    );
  }
}