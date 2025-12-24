import 'package:flutter/material.dart';

class StockDispo extends StatelessWidget {
  const StockDispo({super.key});

  @override
  Widget build(BuildContext context) {
    var blue = Color(0xFF125695);
    return Scaffold(
      
      backgroundColor: blue,
      
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/images/ss (4).jpg'), fit: BoxFit.cover),
                  borderRadius: BorderRadius.only( bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50))
                ),
                
              ),
        
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
        
                    Text('Classe :', style: TextStyle(color: Colors.white, ),),
                    ListView.builder(
                      itemBuilder: (context, index) {
                        
                      },
                      
                      
                      )
                    ],
                ),
              )
            ],
          ),
          
        ),
      ),
    );
  }
}