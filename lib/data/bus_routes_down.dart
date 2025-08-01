import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'bus_model.dart';

final List<Bus> buses = [  Bus(
  name: 'Satélite',
  code: 'RTU-02',
  route: [
    const LatLng(-13.549000216250988, -71.88976099993755), // Primero
    const LatLng(-13.546384413107363, -71.88921056807001), // Control
    const LatLng(-13.545736239493053, -71.89124878190978), // San Juan
    const LatLng(-13.544966522993416, -71.89420088845543), // Penal
    const LatLng(-13.544151254563465, -71.89580981687698), // Miraflores
    const LatLng(-13.54275641155462, -71.897902479846), // San Martín
    const LatLng(-13.541822928958906, -71.89918527429776), // Aprovite
    const LatLng(-13.540544988719136, -71.90092927402723), // Tingo
    const LatLng(-13.538739432912486, -71.90338723947669), // Teléfono
    const LatLng(-13.537444782721892, -71.90532017925185), // Universidad Andina
    const LatLng(-13.536991457184453, -71.90608509717644), // Grifo Movil
    const LatLng(-13.536258555598614, -71.90723359243655), // Puente Tupac Amaru
    const LatLng(-13.535172102784527, -71.90883408236303), // Cachimayo
    const LatLng(-13.533506807121226, -71.91131889350936), // Enaco
    const LatLng(-13.531812204843993, -71.91397673133156), // Sol de Oro
    const LatLng(-13.53149245397578, -71.91614254807617), // San Miguel
    const LatLng(-13.532272737971331, -71.9195020699231), // Mercadillo
    const LatLng(-13.532464614866926, -71.9206269950561), // Santa Rosa
    const LatLng(-13.532748892617875, -71.92235039951642), // Camionero
    const LatLng(-13.53201406136221, -71.92555686591298), // Séptimo Paradero de San Sebastián
    const LatLng(-13.531333464103882, -71.92791929308468), // Sexto Paradero de San Sebastián
    const LatLng(-13.530818886104342, -71.92978389637388), // Quinto Paradero de San Sebastián
    const LatLng(-13.530061154031094, -71.93247467717285), // Cuarto Paradero de San Sebastián
    const LatLng(-13.529429920857492, -71.93466036189814), // Tercer Paradero de San Sebastián
    const LatLng(-13.529102229963096, -71.93582250536556), // Segundo Paradero de San Sebastián
    const LatLng(-13.528479615659334, -71.93808712742145), // Callejón
    const LatLng(-13.52799557963479, -71.93985348210757), // Primer Paradero de San Sebastián
    const LatLng(-13.527578598921272, -71.9429023600252), // Santa Úrsula
    const LatLng(-13.527237799688685, -71.94563292060965), // Marcavalle
    const LatLng(-13.526649458471313, -71.94826588620377), // Magisterio
    const LatLng(-13.525837409530945, -71.95077509062514), // Seminario
    const LatLng(-13.525192660400865, -71.95293617771354), // Prado
    const LatLng(-13.524254920664438, -71.95598015346992), // Hospital Regional
    const LatLng(-13.523309730100783, -71.95915389862263), // Puerta Unsaac
    const LatLng(-13.52208034106723, -71.96323406266816), // Amauta
    const LatLng(-13.521170932329321, -71.96648030470209), // Garcilaso
    const LatLng(-13.520279261462951, -71.97006607795605), // Clorinda Matto
    const LatLng(-13.51979484528594, -71.97295308127609), // Limacpampa
    const LatLng(-13.519405350498385, -71.97341189887112), // Limacpampa
    const LatLng(-13.518815388533374, -71.97671053505654), // Calle Maruri, 226
    const LatLng(-13.519667894025568, -71.97798519711571), // Avenida del Sol
    const LatLng(-13.520866651919452, -71.97875471243806), // Matará
    const LatLng(-13.521054250875189, -71.98038609698602), // Calle Nueva
    const LatLng(-13.519851626977344, -71.98144754907963), // Concevidayoc, 127
    const LatLng(-13.518639024235915, -71.98091859039704), // Plaza San Francisco
    const LatLng(-13.516533287907734, -71.98279092648161), // Meloq
    const LatLng(-13.516161588739967, -71.98687264327036), // Arcopata
    const LatLng(-13.515270382304172, -71.98631346681853), // Avenida Abancay, 41
    const LatLng(-13.51457485054946, -71.98521655897837), // Plazoleta Santa Ana
    const LatLng(-13.5131916502429, -71.98689779895766), // De La Raza, 1004
    const LatLng(-13.512273628217644, -71.98779009964412), // Humberto Vidal Unda, 1220
    const LatLng(-13.510484575322844, -71.98804311456382), // Calle Conquista
    const LatLng(-13.50992124993761, -71.98960416020076), // Pasaje Chanata
    const LatLng(-13.510182048880335, -71.9911061972194), // San Benito
    const LatLng(-13.509544796244132, -71.9916835097231), // Gradas
    const LatLng(-13.508405270054388, -71.99223535640033), // Gradas
    const LatLng(-13.507038879946206, -71.99302900344512), // Chinchero
    const LatLng(-13.505737437251055, -71.99321214650153), // Callanca
    const LatLng(-13.505921956566532, -71.9940635839877), // Paradero
    const LatLng(-13.506218033517342, -71.99460834203725), // Chosas
    const LatLng(-13.504823222186836, -71.99510931084399), // Los Huertos
    const LatLng(-13.504558636665312, -71.99621757757104), // Cruce
    const LatLng(-13.50537462187358, -71.99634750150034), // Arenas
    const LatLng(-13.506925134533349, -71.99664538067218), // Grifo Tica Tica
    const LatLng(-13.507282301790529, -71.99877381706656), // Huasa Huara
    const LatLng(-13.507546972357606, -72.0016360999799), // Huanca
    const LatLng(-13.507557948583718, -72.0022913377099), // Reservorio
    const LatLng(-13.50801459551774, -72.00466026802343), // Paradero
    const LatLng(-13.507638812551592, -72.00639082343238), // Arco Tica Tica
    const LatLng(-13.507124033972215, -72.00787722006538), // Paradero Sat
    const LatLng(-13.50704923013342, -72.01051693612145), // Cll S/N. - Apv. Kantu (Pto Final)
    const LatLng(-13.523301112757773, -71.96092875893923), // Los Incas
    const LatLng(-13.525309014486778, -71.96128137808539), // Seguro
  ],
),];