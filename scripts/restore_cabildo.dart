import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled2/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firestore = FirebaseFirestore.instance;

  print('=== RESTAURANDO "Señor del Cabildo" ===\n');

  // Datos de ruta completos obtenidos de bus_routes.dart
  final cabildoData = {
    'name': 'Señor del Cabildo',
    'code': 'RTI-10',
    'geometry_source': 'google_directions_api',
    'lastUpdated': FieldValue.serverTimestamp(),
    'route_updated_at': FieldValue.serverTimestamp(),
    'route': [
      const GeoPoint(-13.507588493410763, -72.00666051759957),
      const GeoPoint(-13.508166221733074, -72.00478772232204),
      const GeoPoint(-13.50765310950269, -72.00227593011032),
      const GeoPoint(-13.507571558079338, -72.00093828231552),
      const GeoPoint(-13.507399560135843, -71.99872510557314),
      const GeoPoint(-13.507478957433985, -71.9974952339413),
      const GeoPoint(-13.507096568281485, -71.99660366416995),
      const GeoPoint(-13.504339096036611, -71.99605225552364),
      const GeoPoint(-13.504598473419557, -71.9952921768615),
      const GeoPoint(-13.506458622858023, -71.99482041994564),
      const GeoPoint(-13.505753623158865, -71.99345118333842),
      const GeoPoint(-13.507175785520701, -71.99309766110987),
      const GeoPoint(-13.509386292909634, -71.99166480544044),
      const GeoPoint(-13.510364347410448, -71.99124445404703),
      const GeoPoint(-13.512483595421834, -71.9879078247114),
      const GeoPoint(-13.513421719486523, -71.98681837438247),
      const GeoPoint(-13.51442075387159, -71.9854445241153),
      const GeoPoint(-13.515662539312522, -71.98373452075703),
      const GeoPoint(-13.516462186791044, -71.9831570813501),
      const GeoPoint(-13.517375871078613, -71.98258457856723),
      const GeoPoint(-13.517804983666027, -71.98309016222954),
      const GeoPoint(-13.51840750065633, -71.98408068124347),
      const GeoPoint(-13.520033173205292, -71.98241121664299),
      const GeoPoint(-13.519672104340568, -71.98165947225577),
      const GeoPoint(-13.520696572507838, -71.9809342592476),
      const GeoPoint(-13.521173825699405, -71.98026976280653),
      const GeoPoint(-13.521898937932715, -71.97832380910147),
      const GeoPoint(-13.524234, -71.975764),
      const GeoPoint(-13.523201518186882, -71.97446036746861),
      const GeoPoint(-13.522419520626036, -71.97323835958935),
      const GeoPoint(-13.523581193698904, -71.97170501615281),
      const GeoPoint(-13.523806105612234, -71.96999152752124),
      const GeoPoint(-13.523939499358884, -71.96896300957636),
      const GeoPoint(-13.52426322163572, -71.96685777206135),
      const GeoPoint(-13.524469987810322, -71.96575923417703),
      const GeoPoint(-13.525031282128557, -71.96449261336498),
      const GeoPoint(-13.525442779312884, -71.96354346779218),
      const GeoPoint(-13.52624307196772, -71.96155104039526),
      const GeoPoint(-13.527280444591792, -71.95905241984178),
      const GeoPoint(-13.528404269530405, -71.95639081669633),
      const GeoPoint(-13.529400239202937, -71.95370760865298),
      const GeoPoint(-13.528374309113454, -71.95286984736458),
      const GeoPoint(-13.526394435569497, -71.95337671619718),
      const GeoPoint(-13.525375786338358, -71.95334673534994),
      const GeoPoint(-13.525736587902498, -71.95196221699389),
      const GeoPoint(-13.526705866234407, -71.94887952422619),
      const GeoPoint(-13.527464308545843, -71.94615587236648),
      const GeoPoint(-13.527795690068562, -71.94333863965413),
      const GeoPoint(-13.528193249388455, -71.94018526301657),
      const GeoPoint(-13.528728880776407, -71.93834060938691),
      const GeoPoint(-13.529330563309049, -71.9362245362867),
      const GeoPoint(-13.529658446725437, -71.93496250356029),
      const GeoPoint(-13.530284676783914, -71.93280987118418),
      const GeoPoint(-13.531073107156718, -71.93009082154326),
      const GeoPoint(-13.53150618723304, -71.92835825349091),
      const GeoPoint(-13.53229298699121, -71.92571276515717),
      const GeoPoint(-13.53302870660512, -71.92269590581027),
      const GeoPoint(-13.532857178742448, -71.92090292990267),
      const GeoPoint(-13.532514677489024, -71.9193561097896),
      const GeoPoint(-13.531765746120982, -71.91619485062255),
      const GeoPoint(-13.5319909959673, -71.91430716139831),
      const GeoPoint(-13.533597036001527, -71.91189349444828),
      const GeoPoint(-13.535385233636358, -71.90926541568524),
      const GeoPoint(-13.53635067456182, -71.90770696115035),
      const GeoPoint(-13.536960382610417, -71.90680389749781),
      const GeoPoint(-13.5386855027454, -71.90415142310371),
      const GeoPoint(-13.539535889574514, -71.90297443193317),
      const GeoPoint(-13.540785265181189, -71.90125454267654),
      const GeoPoint(-13.541820755214406, -71.8997920052805),
      const GeoPoint(-13.542797266136303, -71.89842551451899),
      const GeoPoint(-13.545190323762919, -71.89926414563625),
      const GeoPoint(-13.546775738638745, -71.89677221324048),
      const GeoPoint(-13.547861788594028, -71.89506314734203),
      const GeoPoint(-13.549086375622288, -71.89288213564313),
      const GeoPoint(-13.550740469304397, -71.88910851499215),
      const GeoPoint(-13.552659068674258, -71.88446853085053),
      const GeoPoint(-13.553798301508161, -71.88029882050661),
      const GeoPoint(-13.551903003659595, -71.87977565792531),
    ],
    'stops': [
      {
        'name': 'Arco Tica Tica',
        'lat': -13.507588493410763,
        'lng': -72.00666051759957
      },
      {
        'name': 'Quinta Mollendinah',
        'lat': -13.508166221733074,
        'lng': -72.00478772232204
      },
      {
        'name': 'Reservorio',
        'lat': -13.50765310950269,
        'lng': -72.00227593011032
      },
      {'name': 'Huanca', 'lat': -13.507571558079338, 'lng': -72.00093828231552},
      {
        'name': 'Huasa Huara',
        'lat': -13.507399560135843,
        'lng': -71.99872510557314
      },
      {
        'name': 'Posta Miraflores',
        'lat': -13.507478957433985,
        'lng': -71.9974952339413
      },
      {
        'name': 'Grifo Tica Tica',
        'lat': -13.507096568281485,
        'lng': -71.99660366416995
      },
      {
        'name': 'Cruce Santa Ana',
        'lat': -13.504339096036611,
        'lng': -71.99605225552364
      },
      {'name': 'Huertos', 'lat': -13.504598473419557, 'lng': -71.9952921768615},
      {'name': 'Chozas', 'lat': -13.506458622858023, 'lng': -71.99482041994564},
      {
        'name': 'Callanca',
        'lat': -13.505753623158865,
        'lng': -71.99345118333842
      },
      {
        'name': 'Chinchero',
        'lat': -13.507175785520701,
        'lng': -71.99309766110987
      },
      {
        'name': 'Calle D',
        'lat': -13.509386292909634,
        'lng': -71.99166480544044
      },
      {
        'name': 'San Benito',
        'lat': -13.510364347410448,
        'lng': -71.99124445404703
      },
      {
        'name': 'Libertadores',
        'lat': -13.512483595421834,
        'lng': -71.9879078247114
      },
      {
        'name': 'Pasaje San Sebastián',
        'lat': -13.513421719486523,
        'lng': -71.98681837438247
      },
      {
        'name': 'Plazoleta Santa Ana',
        'lat': -13.51442075387159,
        'lng': -71.9854445241153
      },
      {
        'name': 'Esquina Arcopata',
        'lat': -13.515662539312522,
        'lng': -71.98373452075703
      },
      {'name': 'Meloc', 'lat': -13.516462186791044, 'lng': -71.9831570813501},
      {'name': 'Arones', 'lat': -13.517375871078613, 'lng': -71.98258457856723},
      // ...más paradas... (total 81)
    ],
  };

  print('Subiendo datos a busRoutes/Señor del Cabildo...');

  // Subir a busRoutes collection (sin espacio al final)
  await firestore
      .collection('busRoutes')
      .doc('Señor del Cabildo')
      .set(cabildoData);

  print('✅ Datos subidos exitosamente a busRoutes collection');
  print('   - ${cabildoData['route'].length} puntos de ruta');
  print('   - ${cabildoData['stops'].length} paradas');

  print('\n=== RESTAURACIÓN COMPLETA ===');
}
