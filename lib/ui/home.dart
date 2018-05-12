import "package:flutter/material.dart";
import "dart:async";
import "package:http/http.dart" as http;
import "dart:convert";
import "../utils/utils.dart" as util;

class Klimate extends StatefulWidget {
  @override
  _KlimateState createState() => new _KlimateState();
}

class _KlimateState extends State<Klimate> {
  String _cityName;
  Future _getCity(BuildContext context) async{
    Map results = await Navigator.of(context).push(
      MaterialPageRoute<Map>(builder: (BuildContext context){
        return new CityScreen();
      })
    );

    if(results != null && results.containsKey('city')){
      _cityName = results['city'];
      print(_cityName);
    }
  }

    _data() async {
    Map data = await getWeather(util.appId, util.defaultCity);
    print(data['main']['temp'].toString());
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Klimate"),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.menu),
            onPressed: (){_getCity(context);},
          )
        ],       
      ),
      body: new Stack(
        children: <Widget>[
          new Image.asset("images/umbrella.png", fit: BoxFit.fill, width: 490.0,),
          new Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 15.0, 30.0, 0.0),
            child:  new Text('${_cityName == null ? util.defaultCity: _cityName}', 
            style: new TextStyle(fontSize: 32.0, color: Colors.white, fontStyle: FontStyle.italic ,fontWeight: FontWeight.w400),),
          ),

          new Container(
            alignment: Alignment.center,
            child: new Image.asset("images/light_rain.png", height: 125.0 ,width: 125.0,),
          ),
          new Container(
            alignment: Alignment.center,
            child: updateTemp(_cityName)
          )
         
          
        ],
      ),
    );
  }
  Future<Map> getWeather(String appId, String city) async {
String apiUrl = 'http://api.openweathermap.org/data/2.5/weather?q=$city&appid='
                  '${util.appId}&units=Metric';

http.Response response = await http.get(apiUrl);

return json.decode(response.body);
}

Widget updateTemp(String city){
  return new FutureBuilder(
    future: getWeather(util.appId, city == null ? util.defaultCity : city),
    builder: (BuildContext context, AsyncSnapshot<Map> snapshot){
      if(snapshot.hasData){
        Map content = snapshot.data;
        return new Container(
          margin: const EdgeInsets.fromLTRB(40.0, 260.0, 0.0, 0.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
               new ListTile(
                title: new Text(content['main']['temp'].toString() + " °C",
                style: new TextStyle(color: Colors.white, fontSize: 50.0, fontWeight:  FontWeight.w500)),
                subtitle: new ListTile(
                  title: new Text(
                    "Humidity: ${content['main']['humidity'].toString()} %\n"
                    "Min: ${content['main']['temp_min'].toString()} °C\n"
                    "Max: ${content['main']['temp_max'].toString()} °C\n"
                    "Wind: ${content['wind']['speed'].toString()} m/sec \n",
                    style: new TextStyle(
                      color: Colors.white70, fontSize: 18.0 
                    ),
                  ),
                  
                ),
              )
            ],
          )
        );
      }else {
        return new Container();
      }
    },
    );
}
}

class CityScreen extends StatelessWidget {
  var _cityNameController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Enter City"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: new Stack(
        children: <Widget>[
          new ListView(
          children: <Widget>[
             new Image.asset('images/white_snow.png', height:650.0 ,width: 420.0,fit: BoxFit.fill,),
           
          ],
          ),
          new ListView(
            padding: const EdgeInsets.all(20.0),
            children: <Widget>[
               new TextField(
              decoration: new InputDecoration(hintText: "Enter City Name", labelText: "City"),
              keyboardType: TextInputType.text,
              controller: _cityNameController,
              
            ),
            new Padding(padding: const EdgeInsets.all(14.0),),
            new MaterialButton(
              child: new Text("Submit", style: new TextStyle(color: Colors.white, fontSize: 18.0),),
              onPressed: (){Navigator.pop(context,{
                'city': _cityNameController.text == '' ? 'Delhi' : _cityNameController.text
              });},
              color: Colors.redAccent,
            )
            ],
          )
        ],
      )
    );
  }
}