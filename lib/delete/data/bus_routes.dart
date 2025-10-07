
import 'routes/routes_routes.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'bus_model.dart';

final List<Bus> buses = [


  Bus(
      name: 'Saylla huasao',
      code: 'RTI-01',
      route: [
    const LatLng(-13.544466, -71.986992), // 1. Luis Vallejo Santoni
    const LatLng(-13.5435505763437, -71.98561188775224), // 2. Losa 1
    const LatLng(-13.542744987648884, -71.98445787311506), // 3. Estrella
    const LatLng(-13.541839, -71.983519), // 4. Apurímac
    const LatLng(-13.540637, -71.982743), // 5. Domingo Guevara
    const LatLng(-13.539404, -71.984237), // 6. Gradas
    const LatLng(-13.538033, -71.983123), // 7. Teléfono
    const LatLng(-13.534326, -71.981915), // 8. Ramiro Prialé
      const LatLng(-13.533369173504774, -71.9826266661064), // 9. Parque
    const LatLng(-13.532696, -71.980444), // 10. Miguel Grau
    const LatLng(-13.529854677780266, -71.9794700751635), // 11. Zarzuela
    const LatLng(-13.527107826929596, -71.97870396234217), // 12. Ccoripata
    const LatLng(-13.525773861455884, -71.97826275110336), // 13. Belempampa
    const LatLng(-13.524996341221122, -71.97999073223895), // 14. 21 de Mayo
    const LatLng(-13.523635, -71.979962), // 15. Puente Belén
    const LatLng(-13.524269, -71.97817), // 16. Puente Grau
    const LatLng(-13.52293, -71.977355), // 17. Colegio Rosario
    const LatLng(-13.524234, -71.975764), // 18. Humberto Luna
    const LatLng(-13.523201518186882, -71.97446036746861), // 19. Correo
    const LatLng(-13.522419520626036, -71.97323835958935), // 20. La Salle
    const LatLng(-13.522428198917847, -71.97233149918758), // Mercado Wanchaq
    const LatLng(-13.52261238771284, -71.97102501605578), //Manco Inca
    const LatLng(-13.520645728441572, -71.96878445490523), //Clorinda Matto
...culturaRoutes,
    const LatLng(-13.53302870660512, -71.92269590581027), // Camionero
    const LatLng(-13.532857178742448, -71.92090292990267), // Santa Rosa
    const LatLng(-13.532514677489024, -71.9193561097896), // Mercadillo
    const LatLng(-13.531765746120982, -71.91619485062255), // San Miguel
    const LatLng(-13.5319909959673, -71.91430716139831), // Sol de Oro
    const LatLng(-13.533597036001527, -71.91189349444828), // Enaco
    const LatLng(-13.535385233636358, -71.90926541568524), // Cachimayo
    const LatLng(-13.53635067456182, -71.90770696115035), // Puente
    const LatLng(-13.536960382610417, -71.90680389749781), // Grifo
    const LatLng(-13.5386855027454, -71.90415142310371), // Universidad Andina
    const LatLng(-13.539535889574514, -71.90297443193317), // Teléfono
    const LatLng(-13.540785265181189, -71.90125454267654), // Tingo
    const LatLng(-13.541820755214406, -71.8997920052805), // Aprovite
    const LatLng(-13.542954619876825, -71.89817198804033), // San Martín
    const LatLng(-13.54461627363419, -71.89580443596408), // Miraflores
    const LatLng(-13.545133850139878, -71.89473223926336), // Penal
    const LatLng(-13.54589620690304, -71.89211010406221), // San Juan
         const LatLng(-13.546458319463957, -71.88966081845638), // Control-corporation roca
    const LatLng(-13.547155675651899, -71.88660276071795), // Farmacia
    const LatLng(-13.547585495425889, -71.88506649302744), // Paradero Medio
    const LatLng(-13.548247770254532, -71.8826804687899), // Tercer Paradero
    const LatLng(-13.548673897120981, -71.88098718387026), // Romeritos
    const LatLng(-13.54891542279444, -71.88006365817147), // Posta
    const LatLng(-13.549606087243411, -71.87764209936809), // Tapia
    const LatLng(-13.550072337773916, -71.87605823526194), // Forestal
    const LatLng(-13.550656830178644, -71.87404348243453), // Kayra
    const LatLng(-13.551596450945556, -71.8704017701724), // Puente Huacoto
    const LatLng(-13.552375895071172, -71.86725888450583), // Collana
    const LatLng(-13.552876952211236, -71.86518039149347), // U Andina
    const LatLng(-13.553102071822366, -71.86390522302383), // Kinta
    const LatLng(-13.55345026468987, -71.86151412400505), // Entrada
    const LatLng(-13.555573252042572, -71.85623548464778), // Peaje
    const LatLng(-13.558653516505617, -71.85134634349772), // Llamagas
    const LatLng(-13.560948634123559, -71.8461374634611), // Angostura
    const LatLng(-13.563303942021593, -71.84099314100294), // Saywas
    const LatLng(-13.56565658453261, -71.83592800427805), // Bosque
    const LatLng(-13.56693779228231, -71.83310973906204), // Cristal
    const LatLng(-13.567661718831275, -71.8315446137458), // Cruce
    const LatLng(-13.569699533378394, -71.8288705089004), // Primero
    const LatLng(-13.571038481673751, -71.82736968618754), // Segundo
    const LatLng(-13.57194446121075, -71.82636163493953), // Tercero
    const LatLng(-13.572409268201104, -71.82577912934576), // Estadio
    const LatLng(-13.575239290793519, -71.82004887667595), // Chingo
    const LatLng(-13.577380997083976, -71.81684358374957), // Rico Pollo
    const LatLng(-13.576185632570436, -71.81562324489256), // Tienda
    const LatLng(-13.573899300989002, -71.81456335963308), // Huasao
    const LatLng(-13.57093338878016, -71.81320831912628), // Salón
    const LatLng(-13.570086549810258, -71.8126966183517), // Plaza
    const LatLng(-13.570632259844789, -71.81026697610342), // Colegio
    const LatLng(-13.571088874381298, -71.80807729827782), // Mariscal Gamarra
  ],
  ),
  Bus(
name: 'Saylla Tipon Oropesa',
    code:'RTI-02',
    route: [
  const LatLng(-13.52227854032753, -71.98771566389823), // Puente Sipaspucyo
  const LatLng(-13.522631587368947, -71.98647100883586), // Puente de la Almudena
  const LatLng(-13.523509282555587, -71.98301777015067), // Puente Santiago
  const LatLng(-13.52395905710444, -71.98126427008053), // Pera
  const LatLng(-13.524214999289166, -71.98027473126007), // Puente Belén
  const LatLng(-13.525290815482531, -71.97645355386156), // Puente Grau ejercito
  const LatLng(-13.526197204270124, -71.97344240291812), // Gradas
  const LatLng(-13.525644166046678, -71.97202826152366), // Estación
  const LatLng(-13.522659405963207, -71.97295469835984), // La Salle(subidaLa Salle)
  const LatLng(-13.522428198917847, -71.97233149918758), // Mercado Wanchaq
  const LatLng(-13.52261238771284, -71.97102501605578), // Manco Inca
  const LatLng(-13.522825358523258, -71.96988870113522), // Huayna Capac
  const LatLng(-13.522982316111595, -71.96872504968312), // Tacna
  const LatLng(-13.523404455987647, -71.96672182769576), // Plaza Túpac Amaru
  const LatLng(-13.524502695718983, -71.9641497241298), // Segundo
  const LatLng(-13.524829277780542, -71.96327773033293), // Región
  const LatLng(-13.525628380991197, -71.96133284869471), // Seguro
  const LatLng(-13.526581895981675, -71.95899685778383), // Espinar
  const LatLng(-13.525621685872098, -71.95744015011809), // Coliseo
  const LatLng(-13.524473967615657, -71.95626285928323), // Hospital Regional
  const LatLng(-13.525736587902498, -71.95196221699389), // Manuel Prado
  const LatLng(-13.526705866234407, -71.94887952422619), // Magisterio
  const LatLng(-13.527464308545843, -71.94615587236648), // Marcavalle
  const LatLng(-13.527795690068562, -71.94333863965413), // Santa Ursula
  const LatLng(-13.528193249388455, -71.94018526301657), // Primer paradero de San Sebastián
  const LatLng(-13.528728880776407, -71.93834060938691), // Callejón
  const LatLng(-13.529330563309049, -71.9362245362867), // Segundo paradero de San Sebastián
  const LatLng(-13.529658446725437, -71.93496250356029), // Tercero paradero de San Sebastián
  const LatLng(-13.530284676783914, -71.93280987118418), // Cuarto paradero de San Sebastián
  const LatLng(-13.531073107156718, -71.93009082154326), // Quinto paradero de San Sebastián
  const LatLng(-13.53150618723304, -71.92835825349091), // Sexto paradero de San Sebastián
  const LatLng(-13.53229298699121, -71.92571276515717), // Séptimo paradero de San Sebastián
  const LatLng(-13.53302870660512, -71.92269590581027), // Camionero
  const LatLng(-13.532857178742448, -71.92090292990267), // Santa Rosa
  const LatLng(-13.532514677489024, -71.9193561097896), // Mercadillo
  const LatLng(-13.531765746120982, -71.91619485062255), // San Miguel
  const LatLng(-13.5319909959673, -71.91430716139831), // Sol de Oro
  const LatLng(-13.533597036001527, -71.91189349444828), // Enaco
  const LatLng(-13.535385233636358, -71.90926541568524), // Cachimayo
  const LatLng(-13.53635067456182, -71.90770696115035), // Puente
  const LatLng(-13.536960382610417, -71.90680389749781), // Grifo
  const LatLng(-13.5386855027454, -71.90415142310371), // Universidad Andina
  const LatLng(-13.539535889574514, -71.90297443193317), // Teléfono
  const LatLng(-13.540785265181189, -71.90125454267654), // Tingo
  const LatLng(-13.541820755214406, -71.8997920052805), // Aprovite
  const LatLng(-13.542954619876825, -71.89817198804033), // San Martín
  const LatLng(-13.54461627363419, -71.89580443596408), // Miraflores
  const LatLng(-13.545133850139878, -71.89473223926336), // Penal
  const LatLng(-13.54589620690304, -71.89211010406221), // San Juan
      const LatLng(-13.546458319463957, -71.88966081845638), // Control-corporation roca
  const LatLng(-13.547155675651899, -71.88660276071795), // Farmacia
  const LatLng(-13.547585495425889, -71.88506649302744), // Paradero Medio
  const LatLng(-13.548247770254532, -71.8826804687899), // Tercer Paradero
  const LatLng(-13.548673897120981, -71.88098718387026), // Romeritos
  const LatLng(-13.54891542279444, -71.88006365817147), // Posta
  const LatLng(-13.549606087243411, -71.87764209936809), // Tapia
  const LatLng(-13.550072337773916, -71.87605823526194), // Forestal
  const LatLng(-13.550656830178644, -71.87404348243453), // Kayra
  const LatLng(-13.551596450945556, -71.8704017701724), // Puente Huacoto
  const LatLng(-13.552375895071172, -71.86725888450583), // Collana
  const LatLng(-13.552876952211236, -71.86518039149347), // U Andina
  const LatLng(-13.553102071822366, -71.86390522302383), // Kinta
  const LatLng(-13.55345026468987, -71.86151412400505), // Entrada
  const LatLng(-13.555573252042572, -71.85623548464778), // Peaje
  const LatLng(-13.558653516505617, -71.85134634349772), // Llamagas
  const LatLng(-13.560948634123559, -71.8461374634611), // Angostura
  const LatLng(-13.563303942021593, -71.84099314100294), // Saywas
  const LatLng(-13.56565658453261, -71.83592800427805), // Bosque
  const LatLng(-13.56693779228231, -71.83310973906204), // Cristal
  const LatLng(-13.567661718831275, -71.8315446137458), // Cruce
  const LatLng(-13.569699533378394, -71.8288705089004), // Primero
  const LatLng(-13.571038481673751, -71.82736968618754), // Segundo
  const LatLng(-13.57194446121075, -71.82636163493953), // Tercero
  const LatLng(-13.572409268201104, -71.82577912934576), // Estadio
  const LatLng(-13.575239290793519, -71.82004887667595), // Chingo
  const LatLng(-13.577380997083976, -71.81684358374957), // Rico Pollo
  const LatLng(-13.584319495574379, -71.80743976052902), // Nuevo Huasao
  const LatLng(-13.58602590669231, -71.80511320422531), // Alicorp
  const LatLng(-13.58729052632119, -71.80339620380937), // Real Naciente Huasao
  const LatLng(-13.590783961126983, -71.78947134427312), // Tipón
  const LatLng(-13.592332866718703, -71.78602430281788), // Chancadora
  const LatLng(-13.597955692230563, -71.7735509140861), // Campamento
  const LatLng(-13.597844960031912, -71.7739171469302), // Campamento (corrección)
  const LatLng(-13.599147160318669, -71.76966913048092), // Grifo Pecsa
  const LatLng(-13.600333841727533, -71.76584057864913), // Comisaría de Oropesa
  const LatLng(-13.597202136739666, -71.76435226017416), // Patacalle
  const LatLng(-13.595699791578458, -71.7636886883224), // Perú
  const LatLng(-13.594278277252558, -71.76304835159966), // Plaza de Oropesa
],
  ),
  Bus(
    name: 'Pachacute',
      code: 'RTI-04',
      route: [
        const LatLng(-13.490767251675637, -72.0515174862028), // Límite Provincial Cusco - Anta
        const LatLng(-13.492857406368035, -72.04807755099979), // Quinta Campestre
        const LatLng(-13.493568610597553, -72.04641376006407), // Chicharonerías
        const LatLng(-13.494428420310427, -72.04450340283391), // Entrada a Estadio de Poroy
        const LatLng(-13.495449238276324, -72.0424374890504), // Poroy
        const LatLng(-13.4958198325494, -72.04085630340333), // Entrada Ferrocarril
        const LatLng(-13.497443204120483, -72.03614238504936), // Grifo
        const LatLng(-13.498581661234267, -72.03385173553778), // Entrada Cementerio
        const LatLng(-13.503976111915126, -72.03038807238939), // Action Valley
        const LatLng(-13.50437260737993, -72.02370793089722), // Grifo Primax
        const LatLng(-13.504937312275013, -72.02073169727805), // Huampar
        const LatLng(-13.503108236034178, -72.01777545041159), // Asociación Kantu
        const LatLng(-13.505698232059496, -72.01321507812906), // Paradero Pepsi
        const LatLng(-13.50718156046804, -72.01027155223728), // Paradero Sat
        const LatLng(-13.507588493410763, -72.00666051759957), // Arco Tica Tica
        const LatLng(-13.508166221733074, -72.00478772232204), // Quinta Mollendinah
        const LatLng(-13.50765310950269, -72.00227593011032), // Reservorio
        const LatLng(-13.507571558079338, -72.00093828231552), // Huanca
        const LatLng(-13.507399560135843, -71.99872510557314), // Huasa Huara
        const LatLng(-13.507478957433985, -71.9974952339413), // Posta Miraflores
        const LatLng(-13.507516352815172, -71.99608767119416), // Mercado Tica Tica
        const LatLng(-13.507047586601516, -71.99445002498774), // Arco de Tica Tica
        const LatLng(-13.508197738031186, -71.99346252237792), // Jayanca
        const LatLng(-13.50954523185035, -71.99297959650985), // San Benito
        const LatLng(-13.513283479045338, -71.99145033302806), // Villa María
        const LatLng(-13.515495280478577, -71.99155876235874), // Mirador
        const LatLng(-13.51622532220477, -71.9931641507962), // Desvío
        const LatLng(-13.517408243095126, -71.99546533049526), // La Ñusta
        const LatLng(-13.518275445682592, -71.99520979494055), // Paradero Zorro
        const LatLng(-13.520470811624866, -71.99397320956977), // Gradas
        const LatLng(-13.52007754074533, -71.99415076389495), // Loza
        const LatLng(-13.521451527880902, -71.99436178979239), // San Isidro
        const LatLng(-13.523032308304472, -71.99710377483026), // Paradero Nihuas
        const LatLng(-13.524809486156055, -71.9922959265571), // Entrada
        const LatLng(-13.525301963059212, -71.99193305369809), // Puente
        const LatLng(-13.526349292300651, -71.99101226096165), // Chicago
        const LatLng(-13.528081980821097, -71.98951066995055), // Curva
        const LatLng(-13.526745683959179, -71.98932394512786), // Grifo Terminal
        const LatLng(-13.525474493238212, -71.98903574650758), // Terminal de Quillabamba
        const LatLng(-13.525977176789878, -71.9874342437958), // Almudena
        const LatLng(-13.52602803532868, -71.98469851005572), // Los Ángeles
        const LatLng(-13.525479946153322, -71.98378211796806), //  Esquina Plaza Santiago
        const LatLng(-13.525101239958365, -71.98322687706188), // Parque Plaza Santiago
        const LatLng(-13.522805310477628, -71.98247067811731), // Puente Santiago
        const LatLng(-13.522679463888107, -71.98154029735002), // Tres Cruces de Oro, 240a
        const LatLng(-13.523533258289838, -71.97951966325776), // Belén
        const LatLng(-13.524283155956805, -71.97816702250941), // Puente Grau paradero
        const LatLng(-13.522990338561778, -71.97729318071401), // Colegio Rosario
        const LatLng(-13.523865668173276, -71.97623287512116), // Humberto Luna
        const LatLng(-13.523170246801234, -71.97443997799354), // Correo
        const LatLng(-13.522440041921502, -71.97324173978173), // La Salle
        const LatLng(-13.522428198917847, -71.97233149918758), // Mercado Wanchaq
        const LatLng(-13.52261238771284, -71.97102501605578), // Manco Inca
        const LatLng(-13.522825358523258, -71.96988870113522), // Huayna Capac
        const LatLng(-13.521317532907313, -71.96651320899271), // Garcilaso
        const LatLng(-13.520892695076501, -71.96085915573181), // Puerta 6
        const LatLng(-13.519688254582398, -71.96067812481294), // Collasuyo
        const LatLng(-13.52009252256531, -71.95801373129119), // Andenes
        const LatLng(-13.520581495959867, -71.95546254764842), // Paradero Kiosko
        const LatLng(-13.520706914864077, -71.95464644810811), // Paradero Aldea
        const LatLng(-13.52108602409088, -71.95300701877257), // Manzanares
        const LatLng(-13.521736144725987, -71.9500031915857), // Plaza Vea
        const LatLng(-13.522635434247318, -71.94615345569918), // Restaurante
        const LatLng(-13.523155567486477, -71.94470393497726), // Imperio
        const LatLng(-13.524177567417999, -71.94369061051817), // Universidad Global
        const LatLng(-13.5249081908304, -71.94297054056183), // Paradero
        const LatLng(-13.525339515245397, -71.94253051984897), // Trilce
        const LatLng(-13.525709644683547, -71.94107301843682), // Esquina
        const LatLng(-13.525916221478433, -71.93963699526554), // Iquique
        const LatLng(-13.524906727683936, -71.93946447223723), // Calle Bolívar
        const LatLng(-13.525396848557518, -71.93836268640094), // Velasco Alvarado
        const LatLng(-13.526081943982572, -71.93667112568419), // Albergue
        const LatLng(-13.527541816706869, -71.93567317140175), // Rompemuelle
        const LatLng(-13.529054012729409, -71.93599579521914), //  Esquina Segundo Paradero de San Sebastián
        const LatLng(-13.529658446725437, -71.93496250356029), // 3er Paradero SS
        const LatLng(-13.530284676783914, -71.93280987118418), // 4to Paradero SS
        const LatLng(-13.531073107156718, -71.93009082154326), // 5to Paradero SS
        const LatLng(-13.53150618723304, -71.92835825349091), // 6to Paradero SSz
        const LatLng(-13.53229298699121, -71.92571276515717), // 7mo Paradero SS
        const LatLng(-13.53302870660512, -71.92269590581027), // Camionero
        const LatLng(-13.532857178742448, -71.92090292990267), // Santa Rosa
        const LatLng(-13.532514677489024, -71.9193561097896), // Mercadillo
        const LatLng(-13.531765746120982, -71.91619485062255), // San Miguel
        const LatLng(-13.5319909959673, -71.91430716139831), // Sol de Oro
        const LatLng(-13.533597036001527, -71.91189349444828), // Enaco
        const LatLng(-13.535385233636358, -71.90926541568524), // Cachimayo
        const LatLng(-13.53635067456182, -71.90770696115035), // Puente Túpac Amaru
        const LatLng(-13.536960382610417, -71.90680389749781), // Grifo Móvil
        const LatLng(-13.5386855027454, -71.90415142310371), // Universidad Andina
        const LatLng(-13.539535889574514, -71.90297443193317), // Teléfono
        const LatLng(-13.540785265181189, -71.90125454267654), // Tingo
        const LatLng(-13.541820755214406, -71.8997920052805), // Aprovite
        const LatLng(-13.542797266136303, -71.89842551451899), // Grifo San Martín
        const LatLng(-13.545190323762919, -71.89926414563625), // Entrada Sucucalle
        const LatLng(-13.546775738638745, -71.89677221324048), // Puente Huatanay
        const LatLng(-13.547861788594028, -71.89506314734203), // Santa Elena
        const LatLng(-13.548701121720018, -71.89534538179933), // Medio
        const LatLng(-13.549874112639525, -71.8960024845203),  // Alameda 4 de Octubres
      ],
  ),

  Bus(
  name: 'Leon de San Jeronimo',
  code: 'RTI-05',
    route: [
      const LatLng(-13.531300321917207, -71.99500169646142), // Puquín - Hermanos Ayar
      const LatLng(-13.529779923068453, -71.99393360166458), // Hermanos Ayar
      const LatLng(-13.529863458778841, -71.9932214742067),  // Tienda
      const LatLng(-13.531321117824614, -71.9931993077235),  // 1 de Mayo
      const LatLng(-13.529199577356009, -71.99216960197946), // 1 de Diciembre
      const LatLng(-13.528364162885381, -71.99209701020281), // Sol Moqueguano
      const LatLng(-13.52699426226316, -71.99232833217438),  // Curva
      const LatLng(-13.528003511082185, -71.99149977890829), // Escaleras
      const LatLng(-13.527376031476681, -71.99118214472274), // Esquina
      const LatLng(-13.526384745800447, -71.99100898184264), // Chicago
      const LatLng(-13.528081980821097, -71.98951066995055), // Curva
      const LatLng(-13.526745683959179, -71.98932394512786), // Grifo Terminal
      const LatLng(-13.525474493238212, -71.98903574650758), // Terminal de Quillabamba
      const LatLng(-13.525977176789878, -71.9874342437958), // Almudena
      const LatLng(-13.524624734107995, -71.9860438340637), // 7 Mascarrones
      const LatLng(-13.524825125516703, -71.98545613459665), // Villa del Sol
      const LatLng(-13.525479946153322, -71.98378211796806), //  Esquina Plaza Santiago
      const LatLng(-13.526165040068918, -71.98198980252445), // Colegio Fe y Alegría
      const LatLng(-13.526584631060507, -71.98074086655129), // Plaza Belén
      const LatLng(-13.52373993273681, -71.97997802482969),  // Puente Belén
      const LatLng(-13.51948365181845, -71.97761927589094),  // Ayacucho
      const LatLng(-13.519527881754883, -71.97648569498786), // El Sol
      const LatLng(-13.519816620671133, -71.97628435637807), // Pampa del Castillo
      const LatLng(-13.51985299601859, -71.97340776265365), // Limacpampa
      const LatLng(-13.520187295257758, -71.9714780010104), // Huáscar
      const LatLng(-13.52062921878832, -71.9687721829894), // Tacna -Corinda Matto
...culturaRoutes,
      const LatLng(-13.53302870660512, -71.92269590581027), // Camionero
      const LatLng(-13.532857178742448, -71.92090292990267), // Santa Rosa
      const LatLng(-13.532514677489024, -71.9193561097896), // Mercadillo
      const LatLng(-13.531765746120982, -71.91619485062255), // San Miguel
      const LatLng(-13.5319909959673, -71.91430716139831), // Sol de Oro
      const LatLng(-13.533597036001527, -71.91189349444828), // Enaco
      const LatLng(-13.535385233636358, -71.90926541568524), // Cachimayo
      const LatLng(-13.53635067456182, -71.90770696115035), // Puente Túpac Amaru
      const LatLng(-13.536960382610417, -71.90680389749781), // Grifo Móvil
      const LatLng(-13.5386855027454, -71.90415142310371), // Universidad Andina
      const LatLng(-13.539535889574514, -71.90297443193317), // Teléfono
      const LatLng(-13.540785265181189, -71.90125454267654), // Tingo
      const LatLng(-13.541820755214406, -71.8997920052805), // Aprovite
      const LatLng(-13.542954619876825, -71.89817198804033), // San Martín
      const LatLng(-13.54461627363419, -71.89580443596408), // Miraflores
      const LatLng(-13.545133850139878, -71.89473223926336), // Penal
      const LatLng(-13.54589620690304, -71.89211010406221), // San Juan
      const LatLng(-13.546039012482021, -71.8899699749744), // Control
      const LatLng(-13.544062872748604, -71.8887845212686), // Esquina Mercado
      const LatLng(-13.544341779606633, -71.88776365990275), // Puerta 7-Mercado Vinocanchón
      const LatLng(-13.546572637605793, -71.88793929080937), //La Cultura
      const LatLng(-13.547155675651899, -71.88660276071795), // Farmacia
      const LatLng(-13.547585495425889, -71.88506649302744), // Paradero Medio
      const LatLng(-13.548247770254532, -71.8826804687899), // Tercer Paradero
      const LatLng(-13.548673897120981, -71.88098718387026), // Romeritos
      const LatLng(-13.54891542279444, -71.88006365817147), // Posta
      const LatLng(-13.549606087243411, -71.87764209936809), // Tapia
      const LatLng(-13.550072337773916, -71.87605823526194), // Forestal
      const LatLng(-13.550656830178644, -71.87404348243453), // Kayra
      const LatLng(-13.551596450945556, -71.8704017701724), // Puente Huacoto
      const LatLng(-13.552375895071172, -71.86725888450583), // Collana
      const LatLng(-13.550081024973966, -71.86694309848943), // Prolongación Perú
      const LatLng(-13.548380080481179, -71.86700422554162), // Bosquecillo
      const LatLng(-13.547176718730777, -71.8667615541266),  // Estadio de Collana
    ],
),
  Bus(
    name: 'Señor del Huerto',
    code: 'RTI-06',
    route: [
      const LatLng(-13.468676474688694, -71.94013762151458), // Final Ccorimarca
      const LatLng(-13.46572525969196, -71.93412207787472), // Entrada a Sequeracay
      const LatLng(-13.46195780320411, -71.92664738038849), // Sequer
      const LatLng(-13.465590653693754, -71.9216980245103), // Chitapampa
      const LatLng(-13.467549790659804, -71.92051797212044), // APV Incaqsamanan
      const LatLng(-13.471502432600325, -71.92084296404434), // Esquina
      const LatLng(-13.472569376729068, -71.92161959988243), // Cruce
      const LatLng(-13.474149410085545, -71.92246654970597), // Mercado de Productores de Corao
      const LatLng(-13.476221458935614, -71.92369097124309), // Corao
      const LatLng(-13.478482002956456, -71.92502506470645), // Tienda de Abarrotes
      const LatLng(-13.481317272328736, -71.92307336732911), // 1 de Marzo
      const LatLng(-13.48602413404123, -71.94647348182897), // Entrada a Yuncaypata
      const LatLng(-13.481076862265125, -71.96427057477004), // Tambomachay
      const LatLng(-13.483734999133677, -71.96294283398164), // Puka Pucara
      const LatLng(-13.488864537067213, -71.96436371783426), // Huayllarccocha
      const LatLng(-13.496744970708352, -71.97292881019114), // Zona X
      const LatLng(-13.50814161251225, -71.9706744245526), // Q'enqo
      const LatLng(-13.508449247438206, -71.97299955745181), // Desvío
      const LatLng(-13.507911950913861, -71.97522813365427), // Entrada a Sacsayhuamán
      const LatLng(-13.51035094934579, -71.97627468356997), // Cristo Blanco
      const LatLng(-13.510664081369852, -71.97476165600935), // Señal
      const LatLng(-13.511785190016566, -71.97340034455713), // Chozas
      const LatLng(-13.51208159258403, -71.97232098213398), // Mesa
      const LatLng(-13.51205375280376, -71.97134941368724), // Entrada
      const LatLng(-13.511355770705139, -71.97028337702012), // Camino Qhapaq Ñan
      const LatLng(-13.513328750606108, -71.96736675057626), // Mosocllacta
      const LatLng(-13.514025489171894, -71.96682684751514), // Balconcillo
      const LatLng(-13.514644456971837, -71.96546173283649), // Cruz de Tete Qaqa
      const LatLng(-13.514033200706, -71.96334940152671), // Palacio del Inka
      const LatLng(-13.516202969365496, -71.96192606247659), // Lucrepata
      const LatLng(-13.516393604178788, -71.96067071286122), // Media Luna
      const LatLng(-13.516493361803846, -71.95900857967659), // Mirador Kanka
      const LatLng(-13.516713651675687, -71.95713304767037), // Lorohuachana
      const LatLng(-13.517055573695204, -71.95944739722432), // Hotel Mirador
      const LatLng(-13.517574907748967, -71.96036788357054), // Andes Perú
      const LatLng(-13.518454357548245, -71.96143112260559), // Occhullo
      const LatLng(-13.518770187733601, -71.96274102216898), // Mariscal Gamarra
      const LatLng(-13.517674138134064, -71.96658011413476), // Mercado de Rosaspata
      const LatLng(-13.519081905309317, -71.96742456764517), // Puputi(bajda)
      const LatLng(-13.521317532907313, -71.96651320899271), //Garcilaso
      const LatLng(-13.522359303212086, -71.9631560083819), //Amauta
      const LatLng(-13.523301112757773, -71.96092875893923), // Los Incas
      const LatLng(-13.525309014486778, -71.96128137808539), // Seguro
      const LatLng(-13.528747302211366, -71.96053046148208), // Calca
      const LatLng(-13.531710358207544, -71.96045546859268), // Mercado de Ttito (bajada)
      const LatLng(-13.532277815711215, -71.96046798131891), // 28 de Julio(bajada)
      const LatLng(-13.533806988490868, -71.96070332259895), // Tercer Paradero de Ttito(SUBIDA)
      const LatLng(-13.533634166909561, -71.9624832748661), // Segundo Puente(SUBIDA)
      const LatLng(-13.53352163950123, -71.96354747220428), // Segundo Paradero de Ttito(SUBIDA)
      const LatLng(-13.53332871063205, -71.96536051207376), // Primer Paradero de Ttito(SUBIDA)
      const LatLng(-13.533196085149452, -71.96664137148437), // Terminal Terrestre
      const LatLng(-13.531762038013934, -71.96709827757974), // Avenida 28 de Julio
      const LatLng(-13.531530225065435, -71.9680499166691), // Óvalo Pachacuteq (subida)
      const LatLng(-13.534104337364811, -71.96722893582243), // Terminal Terrestre Wanchaq
      const LatLng(-13.535936763269115, -71.9638992101467), // Picador
      const LatLng(-13.536589744575853, -71.96218529635719), // Molino
      const LatLng(-13.537017279325362, -71.9610054083792), // Manco Cápac
      const LatLng(-13.53761465856539, -71.95930900141755), // Viva El Perú
      const LatLng(-13.538974331824138, -71.95877598587126), // Esquina
      const LatLng(-13.539306121910062, -71.95901996064376), // Picaflor
      const LatLng(-13.539988838866535, -71.96014943441261), // Colegio Viva El Perú
      const LatLng(-13.541367504325315, -71.960649301538),   // Medio
      const LatLng(-13.542140609934886, -71.96033593939642), // Esquina
      const LatLng(-13.54295335118753, -71.960658349274),    // Estacionamiento Señor del Huerto S.A.
    ],
  ),
Bus(
    name: 'Nuevo Mirador',
    code: 'RTI-07',
    route:[

      const LatLng(-13.551785474885271, -71.98718976391413), // Final Cachona
      const LatLng(-13.550251964908615, -71.98674854439071), // Octavo
      const LatLng(-13.551349856095488, -71.98853855376979), // Séptimo
      const LatLng(-13.551672600051377, -71.9908849134707), // Sexto
      const LatLng(-13.550975746688659, -71.98964037896708), // Quinto
      const LatLng(-13.549922888183296, -71.98836679700942), // Cuarto
      const LatLng(-13.54890015708374, -71.9873316422914), // Reservorio
      const LatLng(-13.547945951332924, -71.98567240416149), // Segundo
      const LatLng(-13.546257671498859, -71.98436910586364), // Primero
      const LatLng(-13.545067529760678, -71.98328388792487), // Subida - Juan Espinoza Medrano
      const LatLng(-13.545190345485686, -71.98209270132311), // Esquina - Carretera Comunidad Chocco
      const LatLng(-13.544375492269161, -71.9820611818743), // Entrada
      const LatLng(-13.542871501708774, -71.98193243971029), // Grifo
      const LatLng(-13.542067876637358, -71.98222782018743), // Puente
      const LatLng(-13.54109034726613, -71.98154655647235), // Salcatay
      const LatLng(-13.540142338789058, -71.9812739508574), // Esquina
      const LatLng(-13.53901931397426, -71.9808734600432), // Gradas
      const LatLng(-13.537511676703668, -71.98011929579592), // Puerto
      const LatLng(-13.536445162171388, -71.98007796323591), // Mercado De Huancaro
      const LatLng(-13.535192860916103, -71.98055410631179), // Colegio San Jose Obreo
      const LatLng(-13.532433597269412, -71.98009661252236), // Perú
      const LatLng(-13.529812417151286, -71.97942082732858), // Zarzuela
      const LatLng(-13.527171116080098, -71.97872044336115), // Ccoripata
      const LatLng(-13.525807151983182, -71.97825307743246), // Belempampa
      const LatLng(-13.52293, -71.977355), // 17. Colegio Rosario
      const LatLng(-13.524234, -71.975764), // 18. Humberto Luna
      const LatLng(-13.523624998650662, -71.97509481269873), // Pardo Paseo de los Héroes
      const LatLng(-13.525453670428083, -71.97248150922731), // Estación Hotel
      const LatLng(-13.525752265081335, -71.97216209719083), // Estación Avenida Pardo
      const LatLng(-13.52817326771042, -71.9707900124316), // Confraternidad
      const LatLng(-13.529277345250904, -71.97017187189006), // Cruce Andina
      const LatLng(-13.530603098638641, -71.9694211495448), // Parque Urpicha
      const LatLng(-13.53128336687838, -71.96891870142359), // Óvalo Pachacuteq(bajada)
      const LatLng(-13.532288425140855, -71.96740873704128), // Entrada a Terminal
      const LatLng(-13.533842579670118, -71.9667243117885), // Hospedaje
      const LatLng(-13.533680929405438, -71.9663944489733), // Terminal Terrestre
      const LatLng(-13.53374004181742, -71.96539452308014), // Primer Paradero de Ttito
      const LatLng(-13.534491707400813, -71.96362329298081), // Segundo Paradero de Ttito
      const LatLng(-13.534582520316174, -71.96256691749932), // Segundo Puente
      const LatLng(-13.535042801538024, -71.96088044846118), // Tercer Paradero de Ttito
      const LatLng(-13.532639517845867, -71.96011752846148), // Tercer Paradero (DE VIA EXPRESA)
      const LatLng(-13.532943099535022, -71.95841818889508), // Cuarto Puente
      const LatLng(-13.533172298832634, -71.95582927932803), // Quinto Puente
      const LatLng(-13.533070156736088, -71.95460082320251), // Vía Expresa
      const LatLng(-13.53341982825712, -71.95177198123478), // República de Brasil
      const LatLng(-13.531476427867085, -71.95135475324076), // Túpac Amaru
      const LatLng(-13.5317882549519, -71.94926647122612), // Colombia
      const LatLng(-13.532605390357851, -71.94738993168414), // Chile
      const LatLng(-13.532852787185696, -71.94544835494564), // Américas
      const LatLng(-13.532461306692843, -71.94240574554846), // República de Argentina
      const LatLng(-13.531729653019063, -71.94013261849506), // República del Perú
      const LatLng(-13.529734016352602, -71.94058036901271), // Túpac Amaru (repetido)
      const LatLng(-13.528338593227064, -71.94127370155779), //  Cusco
      const LatLng(-13.528488641214706, -71.94070563020334), //  Primer Paradero de San Sebastián (Avenida Cusco-parte de abajo)
      const LatLng(-13.529159892060305, -71.93929127636737), //  Callejón (parte de abajo)
      const LatLng(-13.530447872644222, -71.93726058637303), //  Plaza de San Sebastián (parte de abajo)
      const LatLng(-13.530610184367442, -71.93633847170362), //  Segundo Paradero de San Sebastián (Avenida Cusco-parte de abajo)
      const LatLng(-13.530972753759752, -71.93462966167772), //  Tercer Paradero de San Sebastián (Avenida Cusco- parte de abajo)
      const LatLng(-13.531391653560284, -71.93300468771574), //  Cuarto Paradero de San Sebastián (Avenida Cusco-parte de abajo)
      const LatLng(-13.532280329019795, -71.92829739531699), //  Sexto Paradero de San Sebastián (Avenida Cusco-parte de abajo)
      const LatLng(-13.53229298699121, -71.92571276515717), // 7mo Paradero SS
      const LatLng(-13.53302870660512, -71.92269590581027), // Camionero
      const LatLng(-13.532857178742448, -71.92090292990267), // Santa Rosa
      const LatLng(-13.532514677489024, -71.9193561097896), // Mercadillo
      const LatLng(-13.531765746120982, -71.91619485062255), // San Miguel
      const LatLng(-13.5319909959673, -71.91430716139831), // Sol de Oro
      const LatLng(-13.533597036001527, -71.91189349444828), // Enaco
      const LatLng(-13.535385233636358, -71.90926541568524), // Cachimayo
      const LatLng(-13.53635067456182, -71.90770696115035), // Puente Túpac Amaru
      const LatLng(-13.536960382610417, -71.90680389749781), // Grifo Móvil
      const LatLng(-13.5386855027454, -71.90415142310371), // Universidad Andina
      const LatLng(-13.539535889574514, -71.90297443193317), // Teléfono
      const LatLng(-13.540785265181189, -71.90125454267654), // Tingo
      const LatLng(-13.541820755214406, -71.8997920052805), // Aprovite
      const LatLng(-13.542797266136303, -71.89842551451899), // Grifo San Martín
      const LatLng(-13.545045216005759, -71.89763563076451), // Kantu Versalles
      const LatLng(-13.54616008644702, -71.89631997712793), // Ciro Alegría
      const LatLng(-13.54696106511015, -71.89507718539151), // Petroperú
      const LatLng(-13.545279034256293, -71.89448336458004), // Penal Esquina
      const LatLng(-13.54589620690304, -71.89211010406221), // San Juan
      const LatLng(-13.546039012482021, -71.8899699749744), // Control
      const LatLng(-13.544062872748604, -71.8887845212686), // Esquina Mercado
      const LatLng(-13.544341779606633, -71.88776365990275), // Puerta 7-Mercado Vinocanchón
      const LatLng(-13.544970468868327, -71.88611849342348), // Agustín Gamarra
      const LatLng(-13.545204827439903, -71.88546358147197), // Velasco Astete
      const LatLng(-13.545583772371655, -71.88438042244918), // Santa Rosa
      const LatLng(-13.545953823335143, -71.8833175976252), // Sorama
      const LatLng(-13.546796199401241, -71.88318704129202), // Almagro
      const LatLng(-13.547212815378048, -71.88100210837139), // Romeritos
      const LatLng(-13.547575959621582, -71.88012359430661), // Licorería
      const LatLng(-13.54800708071954, -71.87733318906574), // Grifo
      const LatLng(-13.548558312225943, -71.87395877853434), // Estadio
      const LatLng(-13.550656830178644, -71.87404348243453), // Kayra
      const LatLng(-13.551596450945556, -71.8704017701724), // Puente Huacoto
      const LatLng(-13.552375895071172, -71.86725888450583), // Collana
      const LatLng(-13.552876952211236, -71.86518039149347), // U Andina
      const LatLng(-13.553102071822366, -71.86390522302383), // Kinta
      const LatLng(-13.55345026468987, -71.86151412400505), // Entrada
      const LatLng(-13.555573252042572, -71.85623548464778), // Peaje
      const LatLng(-13.558653516505617, -71.85134634349772), // Llamagas
      const LatLng(-13.560948634123559, -71.8461374634611), // Angostura
      const LatLng(-13.563303942021593, -71.84099314100294), // Saywas
      const LatLng(-13.56565658453261, -71.83592800427805), // Bosque
      const LatLng(-13.56693779228231, -71.83310973906204), // Cristal
      const LatLng(-13.567661718831275, -71.8315446137458), // Cruce
      const LatLng(-13.569699533378394, -71.8288705089004), // Primero
      const LatLng(-13.571038481673751, -71.82736968618754), // Segundo
      const LatLng(-13.57194446121075, -71.82636163493953), // Tercero
      const LatLng(-13.572409268201104, -71.82577912934576), // Estadio
      const LatLng(-13.571598843236334, -71.82324746013566), // Estadio de Saylla (Final del Mirador)
    ],
),
  Bus(
    name: 'Cristo Blanco',
    code: 'RTI-08',
    route: [
      const LatLng(-13.544466, -71.986992), // 1. Luis Vallejo Santoni
      const LatLng(-13.543481, -71.985597), // 2. Losa 1
      const LatLng(-13.542744987648884, -71.98445787311506), // 3. Estrella
      const LatLng(-13.541839, -71.983519), // 4. Apurímac
      const LatLng(-13.540637, -71.982743), // 5. Domingo Guevara
      const LatLng(-13.539404, -71.984237), // 6. Gradas
      const LatLng(-13.538033, -71.983123), // 7. Teléfono
      const LatLng(-13.534326, -71.981915), // 8. Ramiro Prialé
      const LatLng(-13.533369173504774, -71.9826266661064), // 9. Parque
      const LatLng(-13.532696, -71.980444), // 10. Miguel Grau
      const LatLng(-13.529854677780266, -71.9794700751635), // 11. Zarzuela
      const LatLng(-13.527107826929596, -71.97870396234217), // 12. Ccoripata
      const LatLng(-13.526315960278817, -71.9811835862189), // Plaza Belén
      const LatLng(-13.52618841901422, -71.9818037072165), // Colegio Fe y Alegría
      const LatLng(-13.525101239958365, -71.98322687706188), // Plaza Santiago
      const LatLng(-13.522805310477628, -71.98247067811731), // Puente Santiago
      const LatLng(-13.522679463888107, -71.98154029735002), // Tres Cruces de Oro, 240a
      const LatLng(-13.523533258289838, -71.97951966325776), // Belén
      const LatLng(-13.524283155956805, -71.97816702250941), // Puente Grau paradero
      const LatLng(-13.52293, -71.977355), // 17. Colegio Rosario
      const LatLng(-13.524234, -71.975764), // 18. Humberto Luna
      const LatLng(-13.523201518186882, -71.97446036746861), // 19. Correo
      const LatLng(-13.522419520626036, -71.97323835958935), // 20. La Salle
      const LatLng(-13.522428198917847, -71.97233149918758), // Mercado Wanchaq
      const LatLng(-13.52261238771284, -71.97102501605578), //Manco Inca
      const LatLng(-13.522978899525233, -71.9689325896925), // Tacna
      const LatLng(-13.521980567943329, -71.96846333931995), // Institución Educativa
      const LatLng(-13.520753160755225, -71.96853990286903), // Grifo
      const LatLng(-13.519903189594572, -71.96860739241963), // Plaza Zarumilla(Zarumilla)
      const LatLng(-13.517956787117527, -71.96843072048752), // Retiro
      const LatLng(-13.517488200536622, -71.9678071611385), // Recolecta
      const LatLng(-13.518001331967485, -71.96582841508118), // Mercado de Rosaspata
      const LatLng(-13.518521468447279, -71.96381199843266), // Mariscal Gamarra
      const LatLng(-13.518596725034149, -71.96139051083324), // Occhullo
      const LatLng(-13.517618345430112, -71.96032370311407), // Andes Perú
      const LatLng(-13.517214181771518, -71.95933799006903), // Hotel Mirador
      const LatLng(-13.516830810882585, -71.95715476731603), // Lorohuachana
      const LatLng(-13.51642947683582, -71.9589793269939), // Mirador Kanka
      const LatLng(-13.516334593039232, -71.96072774748176), // Media Luna
      const LatLng(-13.516228979975757, -71.96180811350301), // Lucrepata
      const LatLng(-13.51389752184942, -71.96338687394095), // Palacio del Inka
      const LatLng(-13.514589060902418, -71.96546410416776), // Cruz de Tete Qaqa
      const LatLng(-13.51398535188399, -71.96678345939449), // Balconcillo
      const LatLng(-13.513372778768042, -71.96728725610456), // Mosocllacta
      const LatLng(-13.511317476593048, -71.97019858098331), // Camino Qhapaq Ñan
      const LatLng(-13.511995218328764, -71.97139025143193), // Entrada
      const LatLng(-13.512014682018654, -71.9722586355611), // Mesa
      const LatLng(-13.51176379038947, -71.97332210802779), // Chozas
      const LatLng(-13.510603799729546, -71.9747690913289), // Señal
      const LatLng(-13.510329229196422, -71.97619151560795), // Cristo Blanco
      const LatLng(-13.50800725388863, -71.97524375316853), // Entrada a Sacsayhuamán
      const LatLng(-13.508459386967814, -71.97313292229168), // Desvío
      const LatLng(-13.508175766885442, -71.97063034988764), // Q´enqo
      const LatLng(-13.507294370603589, -71.96994558667907), // Estacionamiento Cristo Blanco S.A.
    ],
  ),

Bus(
    name: 'Saylla Tipon',
    code: 'RTI-09',
    route: [
      const LatLng(-13.511254541701298, -71.98472852483759), // Don Bosco
      const LatLng(-13.513015734530926, -71.98309924246405), // Conquista
      const LatLng(-13.514300355945942, -71.9818098698085), // Amargura
      const LatLng(-13.515202372916118, -71.98102461008017), // Saphi
      const LatLng(-13.51716515459148, -71.98177063948464), // Granada
      const LatLng(-13.518787882429022, -71.9815715516448), // Plaza San Francisco
      const LatLng(-13.520287966035264, -71.9799410512226), // Mesón de la Estrella
      const LatLng(-13.521004051386107, -71.97928396204631), // Matará
      const LatLng(-13.52050866888769, -71.97850476126645), // Ayacucho
      const LatLng(-13.51948365181845, -71.97761927589094), // El Sol
      const LatLng(-13.519816620671133, -71.97628435637807), // Pampa del Castillo
      const LatLng(-13.51985299601859, -71.97340776265365), // Limacpampa
      const LatLng(-13.520187295257758, -71.9714780010104), // Huáscar
      const LatLng(-13.52062921878832, -71.9687721829894), // Clorinda Matto- Tacna
...culturaRoutes,

      const LatLng(-13.53302870660512, -71.92269590581027), // Camionero
      const LatLng(-13.532857178742448, -71.92090292990267), // Santa Rosa
      const LatLng(-13.532514677489024, -71.9193561097896), // Mercadillo
      const LatLng(-13.531765746120982, -71.91619485062255), // San Miguel
      const LatLng(-13.5319909959673, -71.91430716139831), // Sol de Oro
      const LatLng(-13.533597036001527, -71.91189349444828), // Enaco
      const LatLng(-13.535385233636358, -71.90926541568524), // Cachimayo
      const LatLng(-13.53635067456182, -71.90770696115035), // Puente Túpac Amaru
      const LatLng(-13.536960382610417, -71.90680389749781), // Grifo Móvil
      const LatLng(-13.5386855027454, -71.90415142310371), // Universidad Andina
      const LatLng(-13.539535889574514, -71.90297443193317), // Teléfono
      const LatLng(-13.540785265181189, -71.90125454267654), // Tingo
      const LatLng(-13.541820755214406, -71.8997920052805), // Aprovite
      const LatLng(-13.542954619876825, -71.89817198804033), // San Martín
      const LatLng(-13.54461627363419, -71.89580443596408), // Miraflores
      const LatLng(-13.545133850139878, -71.89473223926336), // Penal
      const LatLng(-13.54589620690304, -71.89211010406221), // San Juan
      const LatLng(-13.546039012482021, -71.8899699749744), // Control
      const LatLng(-13.544986752218735, -71.88859403897948), // Agricultura
      const LatLng(-13.546572637605793, -71.88793929080937), //La Cultura
      const LatLng(-13.547155675651899, -71.88660276071795), // Farmacia
      const LatLng(-13.547585495425889, -71.88506649302744), // Paradero Medio
      const LatLng(-13.548247770254532, -71.8826804687899), // Tercer Paradero
      const LatLng(-13.548673897120981, -71.88098718387026), // Romeritos
      const LatLng(-13.54891542279444, -71.88006365817147), // Posta
      const LatLng(-13.549606087243411, -71.87764209936809), // Tapia
      const LatLng(-13.550072337773916, -71.87605823526194), // Forestal
      const LatLng(-13.550656830178644, -71.87404348243453), // Kayra
      const LatLng(-13.551596450945556, -71.8704017701724), // Puente Huacoto
      const LatLng(-13.552375895071172, -71.86725888450583), // Collana
      const LatLng(-13.552876952211236, -71.86518039149347), // U Andina Collana
      const LatLng(-13.553102071822366, -71.86390522302383), // Kinta
      const LatLng(-13.55345026468987, -71.86151412400505), // Entrada
      const LatLng(-13.555573252042572, -71.85623548464778), // Peaje
      const LatLng(-13.558653516505617, -71.85134634349772), // Llamagas
      const LatLng(-13.560948634123559, -71.8461374634611), // Angostura
      const LatLng(-13.563303942021593, -71.84099314100294), // Saywas
      const LatLng(-13.56565658453261, -71.83592800427805), // Bosque
      const LatLng(-13.56693779228231, -71.83310973906204), // Cristal
      const LatLng(-13.567661718831275, -71.8315446137458), // Cruce
      const LatLng(-13.569699533378394, -71.8288705089004), // Primero
      const LatLng(-13.571038481673751, -71.82736968618754), // Segundo
      const LatLng(-13.57194446121075, -71.82636163493953), // Tercero
      const LatLng(-13.572409268201104, -71.82577912934576), // Estadio
      const LatLng(-13.575239290793519, -71.82004887667595), // Chingo
      const LatLng(-13.577380997083976, -71.81684358374957), // Rico Pollo
      const LatLng(-13.584319495574379, -71.80743976052902), // Nuevo Huasao
      const LatLng(-13.58602590669231, -71.80511320422531), // Alicorp
      const LatLng(-13.58729052632119, -71.80339620380937), // Real Naciente Huasao
      const LatLng(-13.590783961126983, -71.78947134427312), // Tipón
      const LatLng(-13.586374945304922, -71.7875643304449), // Colegio
      const LatLng(-13.585226256636448, -71.78685752412586), // Choquepata
      const LatLng(-13.586158092459486, -71.78579061931981), // Pasaje
      const LatLng(-13.582607266528923, -71.78317594922159), // Plaza de Tipón / Choquepata
    ],

),
Bus(name:'Señor del Cabildo ',
  code: 'RTI-10',
  route: [
    const LatLng(-13.507588493410763, -72.00666051759957), // Arco Tica Tica
    const LatLng(-13.508166221733074, -72.00478772232204), // Quinta Mollendinah
    const LatLng(-13.50765310950269, -72.00227593011032), // Reservorio
    const LatLng(-13.507571558079338, -72.00093828231552), // Huanca
    const LatLng(-13.507399560135843, -71.99872510557314), // Huasa Huara
    const LatLng(-13.507478957433985, -71.9974952339413), // Posta Miraflores
    const LatLng(-13.507096568281485, -71.99660366416995), // Grifo Tica Tica
    const LatLng(-13.504339096036611, -71.99605225552364), // Cruce Santa Ana
    const LatLng(-13.504598473419557, -71.9952921768615), // Huertos
    const LatLng(-13.506458622858023, -71.99482041994564), // Chozas
    const LatLng(-13.505753623158865, -71.99345118333842), // Callanca
    const LatLng(-13.507175785520701, -71.99309766110987), // Chinchero
    const LatLng(-13.509386292909634, -71.99166480544044), // Calle D
    const LatLng(-13.510364347410448, -71.99124445404703), // San Benito
    const LatLng(-13.512483595421834, -71.9879078247114), // Libertadores
    const LatLng(-13.513421719486523, -71.98681837438247), // Pasaje San Sebastián
    const LatLng(-13.51442075387159, -71.9854445241153), // Plazoleta Santa Ana
    const LatLng(-13.515662539312522, -71.98373452075703), // Esquina Arcopata
    const LatLng(-13.516462186791044, -71.9831570813501), // Meloc
    const LatLng(-13.517375871078613, -71.98258457856723), // Arones
    const LatLng(-13.517804983666027, -71.98309016222954), // Colegio San Francisco
    const LatLng(-13.51840750065633, -71.98408068124347), // Unión
    const LatLng(-13.520033173205292, -71.98241121664299), // Mercado San Pedro
    const LatLng(-13.519672104340568, -71.98165947225577), // Condevidayoc
    const LatLng(-13.520696572507838, -71.9809342592476), // Calle Cruz Verde
    const LatLng(-13.521173825699405, -71.98026976280653), // Calle Nueva
    const LatLng(-13.521898937932715, -71.97832380910147), // Lechugal
    const LatLng(-13.524234, -71.975764), // 18. Humberto Luna
    const LatLng(-13.523201518186882, -71.97446036746861), // 19. Correo
    const LatLng(-13.522419520626036, -71.97323835958935), // 20. La Salle
    const LatLng(-13.523581193698904, -71.97170501615281), // Manco Inca(una cuadra abajo)
    const LatLng(-13.523806105612234, -71.96999152752124), // Wayna Capac(una cuadra abajo)
    const LatLng(-13.523939499358884, -71.96896300957636), // Tacna(una cuadra abajo)
    const LatLng(-13.52426322163572, -71.96685777206135), // Estadio Garcilazo(una cuadra abajo)
    const LatLng(-13.524469987810322, -71.96575923417703), // Terminal Urubamba - Sicuani(una cuadra abajo)
    const LatLng(-13.525031282128557, -71.96449261336498), // Cine(una cuadra abajo)
    const LatLng(-13.525442779312884, -71.96354346779218), // Región(una cuadra abajo)
    const LatLng(-13.52624307196772, -71.96155104039526), // Seguro
    const LatLng(-13.527280444591792, -71.95905241984178), // Seguro Huayruropata
    const LatLng(-13.528404269530405, -71.95639081669633), // Grifo
    const LatLng(-13.529400239202937, -71.95370760865298), // Calvario
    const LatLng(-13.528374309113454, -71.95286984736458), // Miguel Grau
    const LatLng(-13.526394435569497, -71.95337671619718), // Incas
    const LatLng(-13.525375786338358, -71.95334673534994), // Prado
    const LatLng(-13.525736587902498, -71.95196221699389), // Manuel Prado
    const LatLng(-13.526705866234407, -71.94887952422619), // Magisterio
    const LatLng(-13.527464308545843, -71.94615587236648), // Marcavalle
    const LatLng(-13.527795690068562, -71.94333863965413), // Santa Ursula
    const LatLng(-13.528193249388455, -71.94018526301657), // 1er Paradero SS
    const LatLng(-13.528728880776407, -71.93834060938691), // Callejón
    const LatLng(-13.529330563309049, -71.9362245362867), // 2do Paradero SS
    const LatLng(-13.529658446725437, -71.93496250356029), // 3er Paradero SS
    const LatLng(-13.530284676783914, -71.93280987118418), // 4to Paradero SS
    const LatLng(-13.531073107156718, -71.93009082154326), // 5to Paradero SS
    const LatLng(-13.53150618723304, -71.92835825349091), // 6to Paradero SS
    const LatLng(-13.53229298699121, -71.92571276515717), // 7mo Paradero SS
    const LatLng(-13.53302870660512, -71.92269590581027), // Camionero
    const LatLng(-13.532857178742448, -71.92090292990267), // Santa Rosa
    const LatLng(-13.532514677489024, -71.9193561097896), // Mercadillo
    const LatLng(-13.531765746120982, -71.91619485062255), // San Miguel
    const LatLng(-13.5319909959673, -71.91430716139831), // Sol de Oro
    const LatLng(-13.533597036001527, -71.91189349444828), // Enaco
    const LatLng(-13.535385233636358, -71.90926541568524), // Cachimayo
    const LatLng(-13.53635067456182, -71.90770696115035), // Puente Túpac Amaru
    const LatLng(-13.536960382610417, -71.90680389749781), // Grifo Móvil
    const LatLng(-13.5386855027454, -71.90415142310371), // Universidad Andina
    const LatLng(-13.539535889574514, -71.90297443193317), // Teléfono
    const LatLng(-13.540785265181189, -71.90125454267654), // Tingo
    const LatLng(-13.541820755214406, -71.8997920052805), // Aprovite
    const LatLng(-13.542797266136303, -71.89842551451899), // Grifo San Martín
    const LatLng(-13.545190323762919, -71.89926414563625), // Entrada Sucucalle
    const LatLng(-13.546775738638745, -71.89677221324048), // Puente Huatanay
    const LatLng(-13.547861788594028, -71.89506314734203), // Santa Elena
    const LatLng(-13.549086375622288, -71.89288213564313), // Mercado de Frutas
    const LatLng(-13.550740469304397, -71.88910851499215), // Villa El Sol
    const LatLng(-13.552659068674258, -71.88446853085053), // Plaza Chimpahuaylla
    const LatLng(-13.553798301508161, -71.88029882050661), // Puente
    const LatLng(-13.551903003659595, -71.87977565792531), // Final Chimpahuaylla
  ],
),
  Bus(
    name: 'Patron de San Jerónimo',
    code:'RTU-01',
    route: [
      const LatLng(-13.551785474885271, -71.98718976391413), // Final Cachona
      const LatLng(-13.550251964908615, -71.98674854439071), // Octavo
      const LatLng(-13.551349856095488, -71.98853855376979), // Séptimo
      const LatLng(-13.551672600051377, -71.9908849134707), // Sexto
      const LatLng(-13.550975746688659, -71.98964037896708), // Quinto
      const LatLng(-13.549922888183296, -71.98836679700942), // Cuarto
      const LatLng(-13.54890015708374, -71.9873316422914), // Reservorio
      const LatLng(-13.547945951332924, -71.98567240416149), // Segundo
      const LatLng(-13.546257671498859, -71.98436910586364), // Primero
      const LatLng(-13.545067529760678, -71.98328388792487), // Subida - Juan Espinoza Medrano
      const LatLng(-13.545190345485686, -71.98209270132311), // Esquina - Carretera Comunidad Chocco
      const LatLng(-13.544375492269161, -71.9820611818743), // Entrada -Puente Capulichayoc
      const LatLng(-13.542871501708774, -71.98193243971029), // Grifo
      const LatLng(-13.542067876637358, -71.98222782018743), // Puente
      const LatLng(-13.54109034726613, -71.98154655647235), // Salcatay
      const LatLng(-13.540142338789058, -71.9812739508574), // Esquina
      const LatLng(-13.53901931397426, -71.9808734600432), // Gradas
      const LatLng(-13.537511676703668, -71.98011929579592), // Puerto
      const LatLng(-13.536445162171388, -71.98007796323591), // Mercado De Huancaro
      const LatLng(-13.535192860916103, -71.98055410631179), // Colegio San Jose Obreo
      const LatLng(-13.53226158157488, -71.98005136549965), // Desvío-peru
      const LatLng(-13.53022029832839, -71.9799651737937), // Grau
      const LatLng(-13.530875636339978, -71.98268589255527), // Tupac Amaru, 48-pegaso
      const LatLng(-13.529884566676696, -71.98306418398235), // Esquina- primero de mayo
      const LatLng(-13.528603998409503, -71.98349061130419), // Puente Zarzuela
      const LatLng(-13.527892620298642, -71.98240764997637), // Esquina
      const LatLng(-13.527034319631374, -71.98368947311148), // 3s, 1193
      const LatLng(-13.525797101403565, -71.98322566889098), // Santísimo, 1081
      const LatLng(-13.525101239958365, -71.98322687706188), // Plaza Santiago
      const LatLng(-13.522805310477628, -71.98247067811731), // Puente Santiago
      const LatLng(-13.522679463888107, -71.98154029735002), // Tres Cruces de Oro, 240a
      const LatLng(-13.523533258289838, -71.97951966325776), // Belén
      const LatLng(-13.524283155956805, -71.97816702250941), // Puente Grau paradero
      const LatLng(-13.525290815482531, -71.97645355386156), // Puente Grau ejercito
      const LatLng(-13.526197204270124, -71.97344240291812), // Gradas
      const LatLng(-13.525644166046678, -71.97202826152366), // Estación
      const LatLng(-13.522659405963207, -71.97295469835984), // La Salle (Subida)
      const LatLng(-13.522428198917847, -71.97233149918758), // Mercado Wanchaq
      const LatLng(-13.52261238771284, -71.97102501605578), // Manco Inca
      const LatLng(-13.522825358523258, -71.96988870113522), // Huayna Capac
      ...culturaRoutes,
      const LatLng(-13.53302870660512, -71.92269590581027), // Camionero
      const LatLng(-13.532857178742448, -71.92090292990267), // Santa Rosa
      const LatLng(-13.532514677489024, -71.9193561097896), // Mercadillo
      const LatLng(-13.531765746120982, -71.91619485062255), // San Miguel
      const LatLng(-13.5319909959673, -71.91430716139831), // Sol de Oro
      const LatLng(-13.533597036001527, -71.91189349444828), // Enaco
      const LatLng(-13.535385233636358, -71.90926541568524), // Cachimayo
      const LatLng(-13.53635067456182, -71.90770696115035), // Puente Túpac Amaru
      const LatLng(-13.536960382610417, -71.90680389749781), // Grifo Móvil
      const LatLng(-13.5386855027454, -71.90415142310371), // Universidad Andina
      const LatLng(-13.539535889574514, -71.90297443193317), // Teléfono
      const LatLng(-13.540785265181189, -71.90125454267654), // Tingo
      const LatLng(-13.541820755214406, -71.8997920052805), // Aprovite
      const LatLng(-13.542954619876825, -71.89817198804033), // San Martín
      const LatLng(-13.54461627363419, -71.89580443596408), // Miraflores
      const LatLng(-13.545133850139878, -71.89473223926336), // Penal
      const LatLng(-13.54589620690304, -71.89211010406221), // San Juan
      const LatLng(-13.546039012482021, -71.8899699749744), // Control
      const LatLng(-13.544062872748604, -71.8887845212686), // Esquina Mercado
      const LatLng(-13.544341779606633, -71.88776365990275), // Puerta 7-Mercado Vinocanchón
      const LatLng(-13.546572637605793, -71.88793929080937), //La Cultura
      const LatLng(-13.547155675651899, -71.88660276071795), // Farmacia
      const LatLng(-13.547585495425889, -71.88506649302744), // Paradero Medio
      const LatLng(-13.548247770254532, -71.8826804687899), // Tercer Paradero
      const LatLng(-13.548673897120981, -71.88098718387026), // Romeritos
      const LatLng(-13.54891542279444, -71.88006365817147), // Posta
      const LatLng(-13.549606087243411, -71.87764209936809), // Tapia
      const LatLng(-13.550072337773916, -71.87605823526194), // Forestal
      const LatLng(-13.550656830178644, -71.87404348243453), // Kayra
      const LatLng(-13.551596450945556, -71.8704017701724), // Puente Huacoto
      const LatLng(-13.552375895071172, -71.86725888450583), // Collana
      const LatLng(-13.552876952211236, -71.86518039149347), // U Andina Collana
      const LatLng(-13.553102071822366, -71.86390522302383), // Kinta
      const LatLng(-13.55345026468987, -71.86151412400505), // Entrada
      const LatLng(-13.555573252042572, -71.85623548464778), // Peaje
    ],
  ),
Bus(
name: 'Satélite',
code: 'RTU-02',
route: [
  const LatLng(-13.503108236034178, -72.01777545041159), // Asociación Kantu
  const LatLng(-13.505698232059496, -72.01321507812906), // Paradero Pepsi
  const LatLng(-13.50718156046804, -72.01027155223728), // Paradero Sat
  const LatLng(-13.507588493410763, -72.00666051759957), // Arco Tica Tica
  const LatLng(-13.508166221733074, -72.00478772232204), // Quinta Mollendinah
  const LatLng(-13.50765310950269, -72.00227593011032), // Reservorio
  const LatLng(-13.507571558079338, -72.00093828231552), // Huanca
  const LatLng(-13.507399560135843, -71.99872510557314), // Huasa Huara
  const LatLng(-13.507478957433985, -71.9974952339413), // Posta Miraflores
  const LatLng(-13.507096568281485, -71.99660366416995), // Grifo Tica Tica
  const LatLng(-13.504339096036611, -71.99605225552364), // Cruce Santa Ana
  const LatLng(-13.504598473419557, -71.9952921768615), // Huertos
  const LatLng(-13.506458622858023, -71.99482041994564), // Chozas
  const LatLng(-13.505753623158865, -71.99345118333842), // Callanca
  const LatLng(-13.507175785520701, -71.99309766110987), // Chinchero
  const LatLng(-13.509386292909634, -71.99166480544044), // Calle D
  const LatLng(-13.510364347410448, -71.99124445404703), // San Benito
  const LatLng(-13.512483595421834, -71.9879078247114), // Libertadores
  const LatLng(-13.513421719486523, -71.98681837438247), // Pasaje San Sebastián
  const LatLng(-13.51442075387159, -71.9854445241153), // Plazoleta Santa Ana
  const LatLng(-13.515295976532267, -71.98632072237494), // Fierro
  const LatLng(-13.516157578914196, -71.98763602761557), //Arcopata
  const LatLng(-13.516260517063014, -71.98693671398539), //Avenida Apurimac,595- acropata
  const LatLng(-13.515859333030015, -71.98380075531524), //Esquina Arcopata
  const LatLng(-13.516462186791044, -71.9831570813501), // Meloc
  const LatLng(-13.51740969980007, -71.98254613528833), //Arones
  const LatLng(-13.518787882429022, -71.9815715516448), //Plaza San Francisco
  const LatLng(-13.520287966035264, -71.9799410512226), //Mesón de la Estrella
  const LatLng(-13.521004051386107, -71.97928396204631), //Matara
  const LatLng(-13.52050866888769, -71.97850476126645), //Ayacucho
  const LatLng(-13.51948365181845, -71.97761927589094), //Av Sol - EL Sol
  const LatLng(-13.520410531363503, -71.97670841673501), // Qoricancha
  const LatLng(-13.522869891491233, -71.9746424978066), // Correo
  const LatLng(-13.525752265081335, -71.97216209719083), // Estación Avenida Pardo
  const LatLng(-13.52817326771042, -71.9707900124316), // Confraternidad
  const LatLng(-13.529277345250904, -71.97017187189006), // Cruce Andina
  const LatLng(-13.530603098638641, -71.9694211495448), // Parque Urpicha
  const LatLng(-13.53128336687838, -71.96891870142359), // Óvalo Pachacuteq(bajada)
  const LatLng(-13.532072357675244, -71.96719097020294),//Monumento Inca Pachacutec
  const LatLng(-13.532072602597596, -71.96519303769574), // Primer Puente
  const LatLng(-13.532420609294295, -71.9623055578912), // Segundo Puente
  const LatLng(-13.531483373605774, -71.96031392959142), // Mercado de Ttito
  const LatLng(-13.529347613670177, -71.95962222776777), // Espinar
  const LatLng(-13.52744761576117, -71.95892112330948), // Segundo Huayruropata-subida
  const LatLng(-13.52617540107866, -71.96141067713101), // Seguro-subida
  const LatLng(-13.523521094472276, -71.9609448624561), // Los Incas- subida
  const LatLng(-13.52347720169373, -71.95948577846217), // Universidad San Antonnio de Abad
  const LatLng(-13.524473967615657, -71.95626285928323), // Hospital Regional
  const LatLng(-13.525736587902498, -71.95196221699389), // Manuel Prado
  const LatLng(-13.526705866234407, -71.94887952422619), // Magisterio
  const LatLng(-13.527464308545843, -71.94615587236648), // Marcavalle
  const LatLng(-13.527795690068562, -71.94333863965413), // Santa Ursula
  const LatLng(-13.528193249388455, -71.94018526301657), // 1er Paradero SS
  const LatLng(-13.528728880776407, -71.93834060938691), // Callejón
  const LatLng(-13.529330563309049, -71.9362245362867), // 2do Paradero SS
  const LatLng(-13.529658446725437, -71.93496250356029), // 3er Paradero SS
  const LatLng(-13.530284676783914, -71.93280987118418), // 4to Paradero SS
  const LatLng(-13.531073107156718, -71.93009082154326), // 5to Paradero SS
  const LatLng(-13.53150618723304, -71.92835825349091), // 6to Paradero SS
  const LatLng(-13.53229298699121, -71.92571276515717), // 7mo Paradero SS
  const LatLng(-13.53302870660512, -71.92269590581027), // Camionero
  const LatLng(-13.532857178742448, -71.92090292990267), // Santa Rosa
  const LatLng(-13.532514677489024, -71.9193561097896), // Mercadillo
  const LatLng(-13.531765746120982, -71.91619485062255), // San Miguel
  const LatLng(-13.5319909959673, -71.91430716139831), // Sol de Oro
  const LatLng(-13.533597036001527, -71.91189349444828), // Enaco
  const LatLng(-13.535385233636358, -71.90926541568524), // Cachimayo
  const LatLng(-13.53635067456182, -71.90770696115035), // Puente
  const LatLng(-13.536960382610417, -71.90680389749781), // Grifo
  const LatLng(-13.5386855027454, -71.90415142310371), // Universidad Andina
  const LatLng(-13.539535889574514, -71.90297443193317), // Teléfono
  const LatLng(-13.540785265181189, -71.90125454267654), // Tingo
  const LatLng(-13.541820755214406, -71.8997920052805), // Aprovite
  const LatLng(-13.542954619876825, -71.89817198804033), // San Martín
  const LatLng(-13.54461627363419, -71.89580443596408), // Miraflores
  const LatLng(-13.545133850139878, -71.89473223926336), // Penal
  const LatLng(-13.54589620690304, -71.89211010406221), // San Juan
  const LatLng(-13.546458319463957, -71.88966081845638), // Control-corporation roca
  const LatLng(-13.549113944431502, -71.88981949378771), // Montessoriano
  ]

),
  Bus(
    name:'EL Dorado',
    code: 'RTU-04',
    route: [

      const LatLng(-13.531300321917207, -71.99500169646142), // Puquín - Hermanos Ayar
      const LatLng(-13.529779923068453, -71.99393360166458), // Hermanos Ayar
      const LatLng(-13.529863458778841, -71.9932214742067),  // Tienda
      const LatLng(-13.531321117824614, -71.9931993077235),  // 1 de Mayo
      const LatLng(-13.529199577356009, -71.99216960197946), // 1 de Diciembre
      const LatLng(-13.528364162885381, -71.99209701020281), // Sol Moqueguano
      const LatLng(-13.52699426226316, -71.99232833217438),  // Curva
      const LatLng(-13.528003511082185, -71.99149977890829), // Escaleras
      const LatLng(-13.527376031476681, -71.99118214472274), // Esquina
      const LatLng(-13.526384745800447, -71.99100898184264), // Chicago
      const LatLng(-13.528081980821097, -71.98951066995055), // Curva
      const LatLng(-13.526745683959179, -71.98932394512786), // Grifo Terminal
      const LatLng(-13.525474493238212, -71.98903574650758), // Terminal de Quillabamba
      const LatLng(-13.525977176789878, -71.9874342437958), // Almudena
      const LatLng(-13.526972183078637, -71.98456750497274), // Pacatalle
      const LatLng(-13.527703193566753, -71.98244935667118), // Entrada Zarzuela
      const LatLng(-13.526584631060507, -71.98074086655129), // Plaza Belén
      const LatLng(-13.52373993273681, -71.97997802482969),  // Puente Belén
      const LatLng(-13.51948365181845, -71.97761927589094),  // Ayacucho
      const LatLng(-13.519527881754883, -71.97648569498786), // El Sol
      const LatLng(-13.519816620671133, -71.97628435637807), // Pampa del Castillo
      const LatLng(-13.51985299601859, -71.97340776265365), // Limacpampa
      const LatLng(-13.520187295257758, -71.9714780010104), // Huáscar
      const LatLng(-13.52062921878832, -71.9687721829894), // Tacna -Corinda Matto
      const LatLng(-13.521317532907313, -71.96651320899271), // Garcilaso
      const LatLng(-13.522359303212086, -71.9631560083819), // Amauta
      const LatLng(-13.523301112757773, -71.96092875893923), // Los Incas
      const LatLng(-13.525309014486778, -71.96128137808539), // Seguro
      const LatLng(-13.527030938957571, -71.96358401224593), // San Francisco
      const LatLng(-13.529518533410258, -71.96381372091165), // Urcos
      const LatLng(-13.528983010142523, -71.96211052601947), // Paruro
      const LatLng(-13.529063525126832, -71.9606944216465), // Calca
      const LatLng(-13.531710358207544, -71.96045546859268), // Mercado de Ttito (bajada)
      const LatLng(-13.532277815711215, -71.96046798131891), // 28 de Julio(bajada)
      const LatLng(-13.533806988490868, -71.96070332259895), // Tercer Paradero de Ttito
      const LatLng(-13.5347621698712, -71.9608436241877), // Chávez
      const LatLng(-13.535411789012818, -71.95996704656822), // Prolongación Qoricancha
      const LatLng(-13.535253090067648, -71.95867946892523), // Cuarto
      const LatLng(-13.535691096302816, -71.95697061443421), // Quinto
      const LatLng(-13.536063392660623, -71.95584766294358), // Coliseo Uriel Gacria
      const LatLng(-13.537546293772747, -71.95106506570649), // Reloj
      const LatLng(-13.538137959780059, -71.94858500008617), // Quiosco
      const LatLng(-13.538945374360077, -71.94517213766076), // Aeropuerto Velasco Astete
      const LatLng(-13.539107384113452, -71.94181935580576), // Hilario
      const LatLng(-13.541528551476214, -71.9385143948445), // Chavín
      const LatLng(-13.542259271002047, -71.9353141058617), // Entrada Mollecito
      const LatLng(-13.542323829133053, -71.92695469379385), // Posta San Antonio
      const LatLng(-13.541929877728448, -71.92418620814134), // Paradero Zetar
      const LatLng(-13.541704735333663, -71.91754761280804), // Lorena
      const LatLng(-13.54168148770346, -71.91552509532357), // Villa El Salvador
      const LatLng(-13.541466408689194, -71.90918501584991), // Túpac Amaru
      const LatLng(-13.541514321189172, -71.90635860107156), // Rosa Túpac Amaru
      const LatLng(-13.545190323762919, -71.89926414563625), // Entrada Sucucalle
      const LatLng(-13.546775738638745, -71.89677221324048), // Puente Huatanay
      const LatLng(-13.547861788594028, -71.89506314734203), // Santa Elena
      const LatLng(-13.549086375622288, -71.89288213564313), // Mercado de Frutas
      const LatLng(-13.550740469304397, -71.88910851499215), // Villa El Sol
      const LatLng(-13.552659068674258, -71.88446853085053), // Plaza Chimpahuaylla
      const LatLng(-13.553581029196236, -71.8804579560037), // Vallecito
    ],
  ),
  Bus(
    name: 'Pegaso',
    code: 'RTU-05',
    route: [

      const LatLng(-13.533091966098695, -71.98566787955458), // Capilla
      const LatLng(-13.533024986809279, -71.98518536311883), // Bolognesi
      const LatLng(-13.532603651945283, -71.98555495687458), // Illary
      const LatLng(-13.531414025578702, -71.9857078309588), // Módulo
      const LatLng(-13.530875636339978, -71.98268589255527), // Tupac Amaru, 48-pegaso
      const LatLng(-13.529884566676696, -71.98306418398235), // Esquina- primero de mayo
      const LatLng(-13.528603998409503, -71.98349061130419), // Puente Zarzuela
      const LatLng(-13.527892620298642, -71.98240764997637), // Esquina
      const LatLng(-13.527034319631374, -71.98368947311148), // 3s, 1193
      const LatLng(-13.525797101403565, -71.98322566889098), // Santísimo, 1081
      const LatLng(-13.525101239958365, -71.98322687706188), // Plaza Santiago
      const LatLng(-13.522805310477628, -71.98247067811731), // Puente Santiago
      const LatLng(-13.522503579737602, -71.98223474991828), // Paraíso
      const LatLng(-13.521020907987658, -71.9808241041055), // Tahuantinsuyo- calle Tecte
      const LatLng(-13.520287966035264, -71.9799410512226),//Mesón de la Estrella
      const LatLng(-13.521004051386107, -71.97928396204631), //Matara
      const LatLng(-13.521898937932715, -71.97832380910147), // Lechugal
      const LatLng(-13.524234, -71.975764), // 18. Humberto Luna
      const LatLng(-13.523201518186882, -71.97446036746861), // 19. Correo
      const LatLng(-13.522419520626036, -71.97323835958935), // 20. La Salle
      const LatLng(-13.51985299601859, -71.97340776265365), // Limacpampa
      const LatLng(-13.520187295257758, -71.9714780010104), // Huáscar
      const LatLng(-13.52062921878832, -71.9687721829894), // Tacna -Corinda Matto
      ...culturaRoutes,
      const LatLng(-13.53302870660512, -71.92269590581027), // Camionero
      const LatLng(-13.532857178742448, -71.92090292990267), // Santa Rosa
      const LatLng(-13.532514677489024, -71.9193561097896), // Mercadillo
      const LatLng(-13.531765746120982, -71.91619485062255), // San Miguel
      const LatLng(-13.5319909959673, -71.91430716139831), // Sol de Oro
      const LatLng(-13.533597036001527, -71.91189349444828), // Enaco
      const LatLng(-13.535385233636358, -71.90926541568524), // Cachimayo
      const LatLng(-13.53635067456182, -71.90770696115035), // Puente Túpac Amaru
      const LatLng(-13.536960382610417, -71.90680389749781), // Grifo Móvil
      const LatLng(-13.5386855027454, -71.90415142310371), // Universidad Andina
      const LatLng(-13.539535889574514, -71.90297443193317), // Teléfono
      const LatLng(-13.540785265181189, -71.90125454267654), // Tingo
      const LatLng(-13.541820755214406, -71.8997920052805), // Aprovite
      const LatLng(-13.542797266136303, -71.89842551451899), // Grifo San Martín
      const LatLng(-13.545190323762919, -71.89926414563625), // Entrada Sucucalle
      const LatLng(-13.546775738638745, -71.89677221324048), // Puente Huatanay
      const LatLng(-13.547861788594028, -71.89506314734203), // Santa Elena
      const LatLng(-13.548701121720018, -71.89534538179933), // Medio
      const LatLng(-13.549874112639525, -71.8960024845203),  // Alameda 4 de Octubres
      const LatLng(-13.549629999259926, -71.89710286744678), // 30 de Setiembre
      const LatLng(-13.547869663437211, -71.89722667677123), // Iglesia Fidalelfia
      const LatLng(-13.546653252566765, -71.89909325948084), // Urbanización Picol
      const LatLng(-13.546571703158294, -71.90208421550139), // Las Palmeras
      const LatLng(-13.547122325972374, -71.90350063392509), // Los Girasoles
      const LatLng(-13.547774361988534, -71.90503607903459), // Pillao Matao
      const LatLng(-13.549083237285554, -71.90575545153771), // Parque de Vallecito
      const LatLng(-13.550810667639105, -71.90663109981911), // Asociación Vallecito
    ],
  ),
  Bus(
      name: 'Inka Express',
      code: 'RTU-07',
      route: [

        const LatLng(-13.551785474885271, -71.98718976391413), // Final Cachona
        const LatLng(-13.550251964908615, -71.98674854439071), // Octavo
        const LatLng(-13.551349856095488, -71.98853855376979), // Séptimo
        const LatLng(-13.551672600051377, -71.9908849134707), // Sexto
        const LatLng(-13.550975746688659, -71.98964037896708), // Quinto
        const LatLng(-13.549922888183296, -71.98836679700942), // Cuarto
        const LatLng(-13.54890015708374, -71.9873316422914), // Reservorio
        const LatLng(-13.547945951332924, -71.98567240416149), // Segundo
        const LatLng(-13.546257671498859, -71.98436910586364), // Primero
        const LatLng(-13.545067529760678, -71.98328388792487), // Subida - Juan Espinoza Medrano
        const LatLng(-13.545190345485686, -71.98209270132311), // Esquina - Carretera Comunidad Chocco
        const LatLng(-13.544375492269161, -71.9820611818743), // Entrada
        const LatLng(-13.542871501708774, -71.98193243971029), // Grifo
        const LatLng(-13.542067876637358, -71.98222782018743), // Puente
        const LatLng(-13.54109034726613, -71.98154655647235), // Salcatay
        const LatLng(-13.540142338789058, -71.9812739508574), // Esquina
        const LatLng(-13.53901931397426, -71.9808734600432), // Gradas
        const LatLng(-13.537511676703668, -71.98011929579592), // Puerto
        const LatLng(-13.536445162171388, -71.98007796323591), // Mercado De Huancaro
        const LatLng(-13.535192860916103, -71.98055410631179), // Colegio San Jose Obreo
        const LatLng(-13.53226158157488, -71.98005136549965), // Desvío-peru
        const LatLng(-13.529812417151286, -71.97942082732858), // Zarzuela
        const LatLng(-13.527171116080098, -71.97872044336115), // Ccoripata
        const LatLng(-13.525807151983182, -71.97825307743246), // Belempampa
        const LatLng(-13.523500993886772, -71.9794649272443), // calle Belén(Subida)
        const LatLng(-13.522385323456236, -71.98197794499896), // Paraíso
        const LatLng(-13.521020907987658, -71.9808241041055), // Tahuantinsuyo- calle Tecte
        const LatLng(-13.521898937932715, -71.97832380910147), // Lechugal
        const LatLng(-13.524234, -71.975764), // 18. Humberto Luna
        const LatLng(-13.523201518186882, -71.97446036746861), // 19. Correo
        const LatLng(-13.522419520626036, -71.97323835958935), // 20. La Salle
        const LatLng(-13.51985299601859, -71.97340776265365), // Limacpampa
        const LatLng(-13.520187295257758, -71.9714780010104), // Huáscar
        const LatLng(-13.52062921878832, -71.9687721829894), // Tacna -Corinda Matto
        const LatLng(-13.519903189594572, -71.96860739241963), // Plaza Zarumilla(Zarumilla)
        const LatLng(-13.518732387761538, -71.96893667243585), // Callejón Retiro
        const LatLng(-13.517388215861619, -71.96905733503421), // Atahualpa
        const LatLng(-13.517488200536622, -71.9678071611385), // Recolecta
        const LatLng(-13.518001331967485, -71.96582841508118), // Mercado de Rosaspata
        const LatLng(-13.518521468447279, -71.96381199843266), // Mariscal Gamarra
        const LatLng(-13.518596725034149, -71.96139051083324), // Occhullo
        const LatLng(-13.517618345430112, -71.96032370311407), // Andes Perú
        const LatLng(-13.517214181771518, -71.95933799006903), // Hotel Mirador
        const LatLng(-13.516830810882585, -71.95715476731603), // Lorohuachana
        const LatLng(-13.51642947683582, -71.9589793269939), // Mirador Kanka
        const LatLng(-13.516334593039232, -71.96072774748176), // Media Luna
        const LatLng(-13.516055526618343, -71.96039774834013), // Paradero Tienda
        const LatLng(-13.515937796528283, -71.95868213403307), // Tercero de Chinchaysuyo
        const LatLng(-13.515786000839952, -71.95765889548049), // Curva de Huaracpunco
        const LatLng(-13.51477491648193, -71.95695437077221), // Manzanares
        const LatLng(-13.515360341019166, -71.95566170795014), // Arequipa
        const LatLng(-13.51563194452674, -71.95408999723989), // Qoriqoyllor
        const LatLng(-13.514641618421514, -71.95298034199482), // Qory Huairachina
        const LatLng(-13.51357344334857, -71.95388137456325), // Portada del Sol
        const LatLng(-13.514512785065858, -71.95452536423339), // Calle F
        const LatLng(-13.513971075002594, -71.95536963036419), // Pasaje Samaná
        const LatLng(-13.512940099019007, -71.95680184576541), // Iglesia de Huaracpunco
        const LatLng(-13.51250068678961, -71.95779169500636), // Ayuda Mutua
      ],
  ),
  Bus(
    name: 'Wimpillay',
    code: 'RTU-08',
    route: [
      const LatLng(-13.542277305463225, -71.95192982672967), // Willpillay
      const LatLng(-13.541025460007997, -71.95314947666112), // Manco Inca
      const LatLng(-13.540350048740581, -71.95381739174896), // Capilla de Willpillay
      const LatLng(-13.539716784294603, -71.95456665202984), // Iglesia de Jesucristo
      const LatLng(-13.538675790003918, -71.95594207939429), // General Ollanta
      const LatLng(-13.538079788728137, -71.95728713760771), // Señor de Huanca
      const LatLng(-13.53754398618604, -71.95921571314015), // Viva El Perú
      const LatLng(-13.536952846045011, -71.96097408853419), // Manco Cápac
      const LatLng(-13.536558246428495, -71.96206733999934), // Molino
      const LatLng(-13.535813535155732, -71.96395307832046), // Picador
      const LatLng(-13.53421836262193, -71.96707225128888), // Terminal Terrestre Wanchaq(Subida)
      const LatLng(-13.531530225065435, -71.9680499166691), // Óvalo Pachacuteq (Subida)
      const LatLng(-13.528862987534946, -71.96997489850794), // Cruce Andina(Subida)
      const LatLng(-13.528011351883197, -71.9704952994937), // Confreternidad(Subida)
      const LatLng(-13.525644166046678, -71.97202826152366), // Estación
      const LatLng(-13.522659405963207, -71.97295469835984), // La Salle(Subida)
      const LatLng(-13.51985299601859, -71.97340776265365), // Limacpampa
      const LatLng(-13.520187295257758, -71.9714780010104), // Huáscar
      const LatLng(-13.52062921878832, -71.9687721829894), // Tacna -Corinda Matto
      ...culturaRoutes,
      const LatLng(-13.53302870660512, -71.92269590581027), // Camionero
      const LatLng(-13.532857178742448, -71.92090292990267), // Santa Rosa
      const LatLng(-13.532514677489024, -71.9193561097896), // Mercadillo
      const LatLng(-13.531765746120982, -71.91619485062255), // San Miguel
      const LatLng(-13.5319909959673, -71.91430716139831), // Sol de Oro
      const LatLng(-13.533597036001527, -71.91189349444828), // Enaco
      const LatLng(-13.535385233636358, -71.90926541568524), // Cachimayo
      const LatLng(-13.53635067456182, -71.90770696115035), // Puente Túpac Amaru
      const LatLng(-13.536960382610417, -71.90680389749781), // Grifo Móvil
      const LatLng(-13.5386855027454, -71.90415142310371), // Universidad Andina
      const LatLng(-13.539535889574514, -71.90297443193317), // Teléfono
      const LatLng(-13.540785265181189, -71.90125454267654), // Tingo
      const LatLng(-13.541820755214406, -71.8997920052805), // Aprovite
      const LatLng(-13.542954619876825, -71.89817198804033), // San Martín
      const LatLng(-13.54461627363419, -71.89580443596408), // Miraflores
      const LatLng(-13.545133850139878, -71.89473223926336), // Penal
      const LatLng(-13.54589620690304, -71.89211010406221), // San Juan
      const LatLng(-13.546039012482021, -71.8899699749744), // Control
      const LatLng(-13.542833513633637, -71.8881618111077), //Mercado Vinocanchón(Subida)
      const LatLng(-13.540841004393553, -71.88686027855628), //  Urbanización Pancho Flores
    ],
  ),
  Bus(
    name: 'Liebre',
    code: 'RTU-09',
    route: [
      const LatLng(-13.509991999637002, -71.98803402599806), // Agua Potable de Cusco
      const LatLng(-13.510008708547199, -71.98966192832947), // Pasaje Chanapata
      const LatLng(-13.512483595421834, -71.9879078247114), // Libertadores
      const LatLng(-13.513421719486523, -71.98681837438247), // Pasaje San Sebastián
      const LatLng(-13.51442075387159, -71.9854445241153), // Plazoleta Santa Ana
      const LatLng(-13.515662539312522, -71.98373452075703), // Esquina Arcopata
      const LatLng(-13.516462186791044, -71.9831570813501), // Meloc
      const LatLng(-13.517375871078613, -71.98258457856723), // Arones
      const LatLng(-13.518787882429022, -71.9815715516448), //Plaza San Francisco
      const LatLng(-13.520287966035264, -71.9799410512226), //Mesón de la Estrella
      const LatLng(-13.521004051386107, -71.97928396204631), //Matara
      const LatLng(-13.52050866888769, -71.97850476126645), //Ayacucho
      const LatLng(-13.51948365181845, -71.97761927589094), //Av Sol - EL Sol
      const LatLng(-13.519816620671133, -71.97628435637807), //Pampa De Castillo, 408
      const LatLng(-13.51985299601859, -71.97340776265365), //Limacpampa
      const LatLng(-13.520187295257758, -71.9714780010104), //Huascar
      const LatLng(-13.52062921878832, -71.9687721829894), //Tacna - Clorinda Matto
      const LatLng(-13.521317532907313, -71.96651320899271), //Garcilaso
      const LatLng(-13.522359303212086, -71.9631560083819), //Amauta
      const LatLng(-13.52347720169373, -71.95948577846217), //Univercidad San Antonio de Abad
      const LatLng(-13.525621685872098, -71.95744015011809), // Coliseo
      const LatLng(-13.52711449827041, -71.958803888939), // Segundo de Huayruropata
      const LatLng(-13.529063525126832, -71.9606944216465), // Calca
      const LatLng(-13.531710358207544, -71.96045546859268), // Mercado de Ttito (bajada)
      const LatLng(-13.532277815711215, -71.96046798131891), // 28 de Julio(bajada)
      const LatLng(-13.533806988490868, -71.96070332259895), // Tercer Paradero de Ttito
      const LatLng(-13.5347621698712, -71.9608436241877), // Chávez
      const LatLng(-13.535411789012818, -71.95996704656822), // Prolongación Qoricancha
      const LatLng(-13.532943099535022, -71.95841818889508), // Cuarto Puente (Via Expresas)
      const LatLng(-13.533172298832634, -71.95582927932803), // Quinto Puente(Via Expresas)
      const LatLng(-13.534459727784318, -71.95557498046927), // Coliseo Uriel García(todo de bajada)
      const LatLng(-13.535876453803771, -71.95567657313528), // Primero de Velasco
      const LatLng(-13.537546293772747, -71.95106506570649), // Reloj
      const LatLng(-13.538137959780059, -71.94858500008617), // Quiosco
      const LatLng(-13.538945374360077, -71.94517213766076), // Aeropuerto Velasco Astete
      const LatLng(-13.539107384113452, -71.94181935580576), // Hilario
      const LatLng(-13.541528551476214, -71.9385143948445), // Chavín
      const LatLng(-13.542259271002047, -71.9353141058617), // Entrada Mollecito
      const LatLng(-13.542323829133053, -71.92695469379385), // Posta San Antonio
      const LatLng(-13.541929877728448, -71.92418620814134), // Paradero Zetar
      const LatLng(-13.54223624944909, -71.919086556847), // Paradero Vía
      const LatLng(-13.543280812791508, -71.92020624681454), // Karamascara
      const LatLng(-13.544634673978926, -71.92053907544302), // Final Uvima - Sector 7
    ],
  ),
  Bus(
    name: 'Culumbia',
    code: 'RTU-10',
    route:[
      const LatLng(-13.547624256006012, -71.9794006776055), // Inicial Huancaro
      const LatLng(-13.546804239416355, -71.9801043916299), // Paradero Medio
      const LatLng(-13.546263387686578, -71.98125206789987), // Paradero Escolar
      const LatLng(-13.545391969955359, -71.98188252839729), // Paradero Walka
      const LatLng(-13.543476155363738, -71.98224018549305), // Puente Capulichayoc
      const LatLng(-13.544375492269161, -71.9820611818743), // Entrada -Puente Capulichayoc
      const LatLng(-13.542871501708774, -71.98193243971029), // Grifo
      const LatLng(-13.542067876637358, -71.98222782018743), // Puente
      const LatLng(-13.54109034726613, -71.98154655647235), // Salcatay
      const LatLng(-13.540142338789058, -71.9812739508574), // Esquina
      const LatLng(-13.53901931397426, -71.9808734600432), // Gradas
      const LatLng(-13.537511676703668, -71.98011929579592), // Puerto
      const LatLng(-13.536445162171388, -71.98007796323591), // Mercado De Huancaroz
      const LatLng(-13.535185937029578, -71.97951826993406), // Didaskalio
      const LatLng(-13.533174545660332, -71.97673053115405), // Huancaro
      const LatLng(-13.531721284556728, -71.974829028697),   // Cuartel
      const LatLng(-13.53072307974895, -71.97353251518027),  // Alas Peruanas
      const LatLng(-13.52936999929739, -71.97134525331442),  // Electro
      const LatLng(-13.527740687160948, -71.97175128779497), // Entrada Huancaro
      const LatLng(-13.526157224455392, -71.97276916749804), // Mariano de los Santos
      const LatLng(-13.52485648104197, -71.97678222478784),  // Puente Grau
      const LatLng(-13.523500993886772, -71.9794649272443), // calle Belén(Subida)
      const LatLng(-13.521898937932715, -71.97832380910147), // Lechugal
      const LatLng(-13.524234, -71.975764), // 18. Humberto Luna
      const LatLng(-13.523201518186882, -71.97446036746861), // 19. Correo
      const LatLng(-13.522419520626036, -71.97323835958935), // 20. La Salle
      const LatLng(-13.51985299601859, -71.97340776265365), // Limacpampa
      const LatLng(-13.520187295257758, -71.9714780010104), // Huáscar
      const LatLng(-13.52062921878832, -71.9687721829894), // Tacna -Corinda Matto
      const LatLng(-13.518987644995883, -71.96737305326526), // Puputi(subida)
      const LatLng(-13.518001331967485, -71.96582841508118), // Mercado de Rosaspata
      const LatLng(-13.518521468447279, -71.96381199843266), // Mariscal Gamarra
      const LatLng(-13.518596725034149, -71.96139051083324), // Occhullo
      const LatLng(-13.517618345430112, -71.96032370311407), // Andes Perú
      const LatLng(-13.517214181771518, -71.95933799006903), // Hotel Mirador
      const LatLng(-13.516830810882585, -71.95715476731603), // Lorohuachana
      const LatLng(-13.51686354944264, -71.95302328013821), // Estanquillo
      const LatLng(-13.517072529675564, -71.95193220181318), // Bombonera
      const LatLng(-13.518348201184653, -71.9528637836363), // Colegio de Tipón
      const LatLng(-13.519371793467167, -71.95186072176779), // Paracas
      const LatLng(-13.519037272289234, -71.95062974819254), // Garcilaso(Paradero Final de Transportes Columbia)
    ],
  ),
  Bus(
    name: 'Nuevo Amanecer',
    code: 'RTU-11A',
    route:[
      const LatLng(-13.541131716814322, -71.98756504740354), // La Estrella
      const LatLng(-13.540386525310195, -71.98650131765515), // Parque La Estrella
      const LatLng(-13.538687662427309, -71.98636956372842), // Ramiro Prialé
      const LatLng(-13.535896501995085, -71.98701302616776), // Emiliano Huamantica
      const LatLng(-13.533449734769865, -71.98628826148425), // Arias y Aragüez
      const LatLng(-13.53125682413458, -71.9867970013196),   // Arica
      const LatLng(-13.53026585033743, -71.98619476246427),  // Salón Comunal Francisco Bologneesi
      const LatLng(-13.52972309375958, -71.98924704044406),  // Dignidad
      const LatLng(-13.528072868835359, -71.98935817915381), // Entrada Dignidad Nacional
      const LatLng(-13.526745683959179, -71.98932394512786), // Grifo Terminal
      const LatLng(-13.525474493238212, -71.98903574650758), // Terminal de Quillabamba
      const LatLng(-13.525977176789878, -71.9874342437958), // Almudena
      const LatLng(-13.52602803532868, -71.98469851005572), // Los Ángeles
      const LatLng(-13.525479946153322, -71.98378211796806), //  Esquina Plaza Santiago
      const LatLng(-13.525101239958365, -71.98322687706188), // Parque Plaza Santiago
      const LatLng(-13.522805310477628, -71.98247067811731), // Puente Santiago
      const LatLng(-13.522679463888107, -71.98154029735002), // Tres Cruces de Oro, 240a
      const LatLng(-13.523533258289838, -71.97951966325776), // Belén
      const LatLng(-13.524283155956805, -71.97816702250941), // Puente Grau paradero
      const LatLng(-13.522990338561778, -71.97729318071401), // Colegio Rosario
      const LatLng(-13.523865668173276, -71.97623287512116), // Humberto Luna
      const LatLng(-13.523170246801234, -71.97443997799354), // Correo
      const LatLng(-13.522440041921502, -71.97324173978173), // La Salle
      const LatLng(-13.523581193698904, -71.97170501615281), // Manco Inca(una cuadra abajo)
      const LatLng(-13.523806105612234, -71.96999152752124), // Wayna Capac(una cuadra abajo)
      const LatLng(-13.523939499358884, -71.96896300957636), // Tacna(una cuadra abajo)
      const LatLng(-13.526783666191482, -71.96862449892237), // Marianito Ferro
      const LatLng(-13.529349419306339, -71.96858220431963), // La Paz
      const LatLng(-13.530917264349796, -71.9685646958755),  // Óvalo Pachatuteq(Av infancia)
      const LatLng(-13.534104337364811, -71.96722893582243), // Terminal Terrestre Wanchaq
      const LatLng(-13.535936763269115, -71.9638992101467), // Picador
      const LatLng(-13.536589744575853, -71.96218529635719), // Molino
      const LatLng(-13.537017279325362, -71.9610054083792), // Manco Cápac
      const LatLng(-13.53761465856539, -71.95930900141755), // Viva El Perú
      const LatLng(-13.538187971056855, -71.95727795009836), // Señor de Huanca
      const LatLng(-13.53872825345323, -71.95595821960234),  // General Ollanta
      const LatLng(-13.539836060474208, -71.95443974049361), // Iglesia de Jesucristo
      const LatLng(-13.540416026372291, -71.95384531575971), // Capilla de Willpillay
      const LatLng(-13.541075656087251, -71.95319279805638), // Manco Inca
      const LatLng(-13.542072290524066, -71.95219146867746), // Willpillay
      const LatLng(-13.542814058371556, -71.95262195175299), // gradas
      const LatLng(-13.54371374668133, -71.95344236915511), // Entrada
      const LatLng(-13.544354941712026, -71.95355632320218), // Aldea Villa Paraíso
      const LatLng(-13.544569007765308, -71.95292230073564), // Runas Expeditions
    ],
  ),
  Bus(
    name: 'Luis Vallejo Santoni',
    code: 'RTU-11B',
    route:[
      const LatLng(-13.541131716814322, -71.98756504740354), // La Estrella
      const LatLng(-13.540386525310195, -71.98650131765515), // Parque La Estrella
      const LatLng(-13.538687662427309, -71.98636956372842), // Ramiro Prialé
      const LatLng(-13.535896501995085, -71.98701302616776), // Emiliano Huamantica
      const LatLng(-13.533449734769865, -71.98628826148425), // Arias y Aragüez
      const LatLng(-13.53125682413458, -71.9867970013196),   // Arica
      const LatLng(-13.53026585033743, -71.98619476246427),  // Salón Comunal Francisco Bologneesi
      const LatLng(-13.52972309375958, -71.98924704044406),  // Dignidad
      const LatLng(-13.528072868835359, -71.98935817915381), // Entrada Dignidad Nacional
      const LatLng(-13.526745683959179, -71.98932394512786), // Grifo Terminal
      const LatLng(-13.525474493238212, -71.98903574650758), // Terminal de Quillabamba
      const LatLng(-13.525977176789878, -71.9874342437958), // Almudena
      const LatLng(-13.52602803532868, -71.98469851005572), // Los Ángeles
      const LatLng(-13.525479946153322, -71.98378211796806), //  Esquina Plaza Santiago
      const LatLng(-13.525101239958365, -71.98322687706188), // Parque Plaza Santiago
      const LatLng(-13.522805310477628, -71.98247067811731), // Puente Santiago
      const LatLng(-13.522679463888107, -71.98154029735002), // Tres Cruces de Oro, 240a
      const LatLng(-13.523533258289838, -71.97951966325776), // Belén
      const LatLng(-13.524283155956805, -71.97816702250941), // Puente Grau paradero
      const LatLng(-13.522990338561778, -71.97729318071401), // Colegio Rosario
      const LatLng(-13.523865668173276, -71.97623287512116), // Humberto Luna
      const LatLng(-13.523170246801234, -71.97443997799354), // Correo
      const LatLng(-13.522440041921502, -71.97324173978173), // La Salle
      const LatLng(-13.523581193698904, -71.97170501615281), // Manco Inca(una cuadra abajo)
      const LatLng(-13.523806105612234, -71.96999152752124), // Wayna Capac(una cuadra abajo)
      const LatLng(-13.523939499358884, -71.96896300957636), // Tacna(una cuadra abajo)
      const LatLng(-13.526783666191482, -71.96862449892237), // Marianito Ferro
      const LatLng(-13.529349419306339, -71.96858220431963), // La Paz
      const LatLng(-13.530917264349796, -71.9685646958755),  // Óvalo Pachatuteq(Av infancia)
      const LatLng(-13.534104337364811, -71.96722893582243), // Terminal Terrestre Wanchaq
      const LatLng(-13.535936763269115, -71.9638992101467), // Picador
      const LatLng(-13.536589744575853, -71.96218529635719), // Molino
      const LatLng(-13.537017279325362, -71.9610054083792), // Manco Cápac
      const LatLng(-13.53761465856539, -71.95930900141755), // Viva El Perú
      const LatLng(-13.538187971056855, -71.95727795009836), // Señor de Huanca
      const LatLng(-13.53872825345323, -71.95595821960234),  // General Ollanta
      const LatLng(-13.539836060474208, -71.95443974049361), // Iglesia de Jesucristo
      const LatLng(-13.540416026372291, -71.95384531575971), // Capilla de Willpillay
      const LatLng(-13.541075656087251, -71.95319279805638), // Manco Inca
      const LatLng(-13.542072290524066, -71.95219146867746), // Willpillay
      const LatLng(-13.542814058371556, -71.95262195175299), // gradas
      const LatLng(-13.54371374668133, -71.95344236915511), // Entrada
      const LatLng(-13.544354941712026, -71.95355632320218), // Aldea Villa Paraíso
      const LatLng(-13.544569007765308, -71.95292230073564), // Runas Expeditions
    ],
  ),
  Bus(
    name: 'Imperial',
    code: 'RTU-12',
    route:[
      const LatLng(-13.512378594099607, -71.97780723651016), // Choquechaka
      const LatLng(-13.513830402958765, -71.97688564062248), // Ladrillo
      const LatLng(-13.515763869760502, -71.97564409066787), // Cuesta San Blas
      const LatLng(-13.518093879493625, -71.97406473886419), // De Paso
      const LatLng(-13.51985299601859, -71.97340776265365), // Limacpampa
      const LatLng(-13.520187295257758, -71.9714780010104), // Huáscar
      const LatLng(-13.52062921878832, -71.9687721829894), // Tacna -Corinda Matto
      const LatLng(-13.517388215861619, -71.96905733503421), // Atahualpa
      const LatLng(-13.517488200536622, -71.9678071611385), // Recolecta
      const LatLng(-13.518001331967485, -71.96582841508118), // Mercado de Rosaspata
      const LatLng(-13.518521468447279, -71.96381199843266), // Mariscal Gamarra
      const LatLng(-13.520885429518115, -71.96101713931262), // Universitaria(UNSSAC) puerta 6
      const LatLng(-13.52230709744588, -71.96124937474828),  // Amauta(av universitaria)
      const LatLng(-13.52347720169373, -71.95948577846217), //Univercidad San Antonio de Abad
      const LatLng(-13.525621685872098, -71.95744015011809), // Coliseo
      const LatLng(-13.52711449827041, -71.958803888939), // Segundo de Huayruropata
      const LatLng(-13.529063525126832, -71.9606944216465), // Calca
      const LatLng(-13.531710358207544, -71.96045546859268), // Mercado de Ttito (bajada)
      const LatLng(-13.532277815711215, -71.96046798131891), // 28 de Julio(bajada)
      const LatLng(-13.533806988490868, -71.96070332259895), // Tercer Paradero de Ttito
      const LatLng(-13.5347621698712, -71.9608436241877), // Chávez
      const LatLng(-13.535411789012818, -71.95996704656822), // Prolongación Qoricancha
      const LatLng(-13.535253090067648, -71.95867946892523), // Cuarto
      const LatLng(-13.535691096302816, -71.95697061443421), // Quinto
      const LatLng(-13.536063392660623, -71.95584766294358), // Coliseo Uriel Gacria
      const LatLng(-13.537546293772747, -71.95106506570649), // Reloj
      const LatLng(-13.538137959780059, -71.94858500008617), // Quiosco
      const LatLng(-13.538945374360077, -71.94517213766076), // Aeropuerto Velasco Astete
      const LatLng(-13.539107384113452, -71.94181935580576), // Hilario
      const LatLng(-13.539540297558982, -71.93905559961827), // San Luis
      const LatLng(-13.54027161999868, -71.93713404945352), // Cevicheria
      const LatLng(-13.540574495320783, -71.93567873092663), // Kiosko - Nogales
      const LatLng(-13.540754324883212, -71.93483952867186), // Esquina Paracas
      const LatLng(-13.541187334787475, -71.93280910167373), // Gradas
      const LatLng(-13.541240489544963, -71.93168518638325), // Manantiales
      const LatLng(-13.540112862359852, -71.93156220398156), // Colegio Bolivariano
      const LatLng(-13.540271580657, -71.9302978502214), // Pacifico
      const LatLng(-13.540590374399127, -71.92694593853076), // Ctar
      const LatLng(-13.539270595628562, -71.92667836348255), // Esquina
      const LatLng(-13.539585642055997, -71.92324169207313), // Joyas
      const LatLng(-13.539707757930314, -71.92193259085828), // Cancha Sintetica
      const LatLng(-13.53975531382972, -71.92196188474503), // Gradas
      const LatLng(-13.539893941170334, -71.92045284311106), // Virgen Del Carmen
      const LatLng(-13.540027730832623, -71.91897161219545), // Uvima
      const LatLng(-13.540023688792816, -71.9163112419493), // Las Orquídeas
      const LatLng(-13.540507289133721, -71.91532460343778), // Villa El Salvador
      const LatLng(-13.540640628338139, -71.91189769980447), // Tupac
      const LatLng(-13.539660194505156, -71.91162500183614), // Medio
      const LatLng(-13.538115811052519, -71.91166754188112), // Mini Hospital
      const LatLng(-13.535356344072982, -71.9126822462964), // Colegio
      const LatLng(-13.533736727050519, -71.91173194756323), // Enaco
     const LatLng(-13.535385233636358, -71.90926541568524), // Cachimayo
      const LatLng(-13.53635067456182, -71.90770696115035), // Puente Túpac Amaru
      const LatLng(-13.536960382610417, -71.90680389749781), // Grifo Móvil
      const LatLng(-13.5386855027454, -71.90415142310371), // Universidad Andina
      const LatLng(-13.539535889574514, -71.90297443193317), // Teléfono
      const LatLng(-13.540785265181189, -71.90125454267654), // Tingo
      const LatLng(-13.542514714354581, -71.90171370889317)//Urbanización Versalles
    ],
  ),
  Bus(
    name: 'Tupac Amaru II',
    code: 'RTU-13',
    route:[
      const LatLng(-13.542118172015513, -71.96526212672963), // Viva El Perú - Segunda Etapa
      const LatLng(-13.540519618014095, -71.96464645996429), // Casa Blanca
      const LatLng(-13.539403811706816, -71.96424384742868), // Florida House
      const LatLng(-13.539094005941253, -71.96312210793957), // Paradero Bosque
      const LatLng(-13.53771108610911, -71.9620007358502), // San José de Praga
      const LatLng(-13.537678632602809, -71.96122685211083), // Posta de Manco Cápac
      const LatLng(-13.536558246428495, -71.96206733999934), // Molino
      const LatLng(-13.535813535155732, -71.96395307832046), // Picador
      const LatLng(-13.53421836262193, -71.96707225128888), // Terminal Terrestre Wanchaq(Subida)
      const LatLng(-13.532801163471536, -71.96866360878484), // Acomayo
      const LatLng(-13.533665621694263, -71.96941522203433), // Río Huancaro
      const LatLng(-13.534998002509393, -71.97133074752547), // Paradero Poste
      const LatLng(-13.536989062111537, -71.97146949372927), // Calle Pachacuteq
      const LatLng(-13.53854846696324, -71.97042622620447), // Canchita de 1ro de Mayo
      const LatLng(-13.539516628748979, -71.9711551842494), // Primero de Enero
      const LatLng(-13.540560909678435, -71.97232140002396), // Cusco Transfer
      const LatLng(-13.539260034822549, -71.97337632114511), // Santa María
      const LatLng(-13.537483044510216, -71.97434361115138), // Paradero Señal
      const LatLng(-13.53622181660829, -71.9739695550874), // Arahuay
      const LatLng(-13.535854838480859, -71.97560252280832), // Pecador
      const LatLng(-13.535986481315176, -71.97703402982923), // Costumbre
      const LatLng(-13.534930693838893, -71.97600863214687), // Puente 1
      const LatLng(-13.535458991505543, -71.97798732305284), // Puente 2
      const LatLng(-13.536445162171388, -71.98007796323591), // Mercado De Huancaro
      const LatLng(-13.535192860916103, -71.98055410631179), // Colegio San Jose Obreo
      const LatLng(-13.532433597269412, -71.98009661252236), // Perú
      const LatLng(-13.529812417151286, -71.97942082732858), // Zarzuela
      const LatLng(-13.527171116080098, -71.97872044336115), // Ccoripata
      const LatLng(-13.526315960278817, -71.9811835862189), // Plaza Belén
      const LatLng(-13.52618841901422, -71.9818037072165), // Colegio Fe y Alegría
      const LatLng(-13.525101239958365, -71.98322687706188), // Plaza Santiago
      const LatLng(-13.522805310477628, -71.98247067811731), // Puente Santiago
      const LatLng(-13.522679463888107, -71.98154029735002), // Tres Cruces de Oro, 240a
      const LatLng(-13.523533258289838, -71.97951966325776), // Belén
      const LatLng(-13.524283155956805, -71.97816702250941), // Puente Grau paradero
      const LatLng(-13.52293, -71.977355), //  Colegio Rosario
      const LatLng(-13.524234, -71.975764), //  Humberto Luna
      const LatLng(-13.523201518186882, -71.97446036746861), //  Correo
      const LatLng(-13.522419520626036, -71.97323835958935), //  La Salle
      const LatLng(-13.523581193698904, -71.97170501615281), // Manco Inca(una cuadra abajo)
      const LatLng(-13.523806105612234, -71.96999152752124), // Wayna Capac(una cuadra abajo)
      const LatLng(-13.523939499358884, -71.96896300957636), // Tacna(una cuadra abajo)
      const LatLng(-13.52426322163572, -71.96685777206135), // Estadio Garcilazo(una cuadra abajo)
      const LatLng(-13.524469987810322, -71.96575923417703), // Terminal Urubamba - Sicuani(una cuadra abajo)
      const LatLng(-13.525031282128557, -71.96449261336498), // Cine(una cuadra abajo)
      const LatLng(-13.525442779312884, -71.96354346779218), // Región(una cuadra abajo)
      const LatLng(-13.52624307196772, -71.96155104039526), // Seguro
      const LatLng(-13.527280444591792, -71.95905241984178), // Seguro Huayruropata
      const LatLng(-13.528404269530405, -71.95639081669633), // Grifo
      const LatLng(-13.529400239202937, -71.95370760865298), // Calvario
      const LatLng(-13.528374309113454, -71.95286984736458), // Miguel Grau
      const LatLng(-13.526394435569497, -71.95337671619718), // Incas
      const LatLng(-13.525375786338358, -71.95334673534994), // Prado
      const LatLng(-13.525736587902498, -71.95196221699389), // Manuel Prado
      const LatLng(-13.526705866234407, -71.94887952422619), // Magisterio
      const LatLng(-13.527464308545843, -71.94615587236648), // Marcavalle
      const LatLng(-13.527795690068562, -71.94333863965413), // Santa Ursula
      const LatLng(-13.528193249388455, -71.94018526301657), // 1er Paradero SS
      const LatLng(-13.528728880776407, -71.93834060938691), // Callejón
      const LatLng(-13.529330563309049, -71.9362245362867), // 2do Paradero SS
      const LatLng(-13.529658446725437, -71.93496250356029), // 3er Paradero SS
      const LatLng(-13.530284676783914, -71.93280987118418), // 4to Paradero SS
      const LatLng(-13.531073107156718, -71.93009082154326), // 5to Paradero SS
      const LatLng(-13.53150618723304, -71.92835825349091), // 6to Paradero SS
      const LatLng(-13.53229298699121, -71.92571276515717), // 7mo Paradero SS
      const LatLng(-13.53302870660512, -71.92269590581027), // Camionero
      const LatLng(-13.532857178742448, -71.92090292990267), // Santa Rosa
      const LatLng(-13.532514677489024, -71.9193561097896), // Mercadillo
      const LatLng(-13.531765746120982, -71.91619485062255), // San Miguel
      const LatLng(-13.5319909959673, -71.91430716139831), // Sol de Oro
      const LatLng(-13.533597036001527, -71.91189349444828), // Enaco
      const LatLng(-13.535385233636358, -71.90926541568524), // Cachimayo
      const LatLng(-13.53635067456182, -71.90770696115035), // Puente Túpac Amaru
      const LatLng(-13.538322354414543, -71.90877587535844), // Grifo Vía Expresa
      const LatLng(-13.539275834296804, -71.90939130895615), // Plaza Túpac Amaru
      const LatLng(-13.53982925913364, -71.91102264041842), // Túpac Katari
      const LatLng(-13.540483226794311, -71.91100687847585), // Katari
      const LatLng(-13.541227803234111, -71.91168747663163), // Puente Tomás Katari
      const LatLng(-13.541755820329769, -71.90963650712305), // Túpac Amaru
      const LatLng(-13.541662394100012, -71.90832382163286), // Bernando Tambowacso
      const LatLng(-13.542693543950788, -71.90858030786889), // Kiosko
      const LatLng(-13.544239874318368, -71.90890177386954), // Calle Kantus
      const LatLng(-13.545007883504205, -71.90976603551444), // Paradero Coca Cola
      const LatLng(-13.545014844636555, -71.90803869554703), // Entrada Caneños
      const LatLng(-13.546260244893507, -71.90873982276754), // Tienda Caneños
      const LatLng(-13.54593929671265, -71.90656145236984), // Acceso Electrosur Este
      const LatLng(-13.54522669553137, -71.90492344396301), // Asociación Caneños
    ],
  ),
  Bus(
    name: 'El Chaski',
    code: 'RTU-14',
    route:[
      const LatLng(-13.545581925630694, -71.94176849801951), // Patrón San Sebastián
      const LatLng(-13.544178442836714, -71.94081460752192), // Esquina
      const LatLng(-13.543128376288273, -71.94021061306), // Gradas
      const LatLng(-13.542703590846662, -71.93974702726348), // Callejón
      const LatLng(-13.542378811625191, -71.93907115665982), // Ruinas
      const LatLng(-13.541295812972907, -71.94024527605067), // Entrada a Agua Buena
      const LatLng(-13.540968714112308, -71.94068766126361), // Puente
      const LatLng(-13.538981668830463, -71.94159238399718), // Hilario
      const LatLng(-13.53887599878623, -71.94521959546617), // Aeropuerto Velasco Astete
      const LatLng(-13.538012385057817, -71.94849761676612), // Quiosco
      const LatLng(-13.537380359256405, -71.95103942853423), // Reloj
      const LatLng(-13.535785509001045, -71.95549993017742), // Primero de Velasco
      const LatLng(-13.534377034151154, -71.95590835136858), // Coliseo Uriel García
    const  LatLng(-13.534214619232028, -71.95658390153613), // Quinto Paradero de Ttito(subida)
      const LatLng(-13.534037956428689, -71.95849836821442), // Cuarto Paradero de Ttito(Subida)
      const LatLng(-13.533806988490868, -71.96070332259895), // Tercer Paradero de Ttito(SUBIDA)
      const LatLng(-13.533634166909561, -71.9624832748661), // Segundo Puente(SUBIDA)
      const LatLng(-13.53352163950123, -71.96354747220428), // Segundo Paradero de Ttito(SUBIDA)
      const LatLng(-13.53332871063205, -71.96536051207376), // Primer Paradero de Ttito(SUBIDA)
      const LatLng(-13.533196085149452, -71.96664137148437), // Terminal Terrestre
      const LatLng(-13.531762038013934, -71.96709827757974), // Avenida 28 de Julio
      const LatLng(-13.531530225065435, -71.9680499166691), // Óvalo Pachacuteq (subida)
      const LatLng(-13.528862987534946, -71.96997489850794), // Cruce Andina(Subida)
      const LatLng(-13.528011351883197, -71.9704952994937), // Confreternidad(Subida)
      const LatLng(-13.526157224455392, -71.97276916749804), // Mariano de los Santos
      const LatLng(-13.52485648104197, -71.97678222478784),  // Puente Grau(subida )
      const LatLng(-13.525616129670045, -71.97835127493038), // Belempampa Subida
      const LatLng(-13.524996341221122, -71.97999073223895), // 14. 21 de Mayo
      const LatLng(-13.523635, -71.979962), // 15. Puente Belén
      const LatLng(-13.524269, -71.97817), // 16. Puente Grau
      const LatLng(-13.52293, -71.977355), // 17. Colegio Rosario
      const LatLng(-13.524234, -71.975764), // 18. Humberto Luna
      const LatLng(-13.523201518186882, -71.97446036746861), // 19. Correo
      const LatLng(-13.522419520626036, -71.97323835958935), // 20. La Salle
      const LatLng(-13.522428198917847, -71.97233149918758), // Mercado Wanchaq
      const LatLng(-13.52261238771284, -71.97102501605578), //Manco Inca
      const LatLng(-13.522825358523258, -71.96988870113522), // Huayna Capac
      ...culturaRoutes,
      const LatLng(-13.53302870660512, -71.92269590581027), // Camionero
      const LatLng(-13.532857178742448, -71.92090292990267), // Santa Rosa
      const LatLng(-13.532514677489024, -71.9193561097896), // Mercadillo
      const LatLng(-13.531765746120982, -71.91619485062255), // San Miguel
      const LatLng(-13.5319909959673, -71.91430716139831), // Sol de Oro
      const LatLng(-13.529697236000406, -71.91415396486222), // Piscina Sol de Oro
      const LatLng(-13.528330623505065, -71.91424590349868), // Curva
      const LatLng(-13.527464383942299, -71.91195087876142), // Cementerio
      const LatLng(-13.527184090853305, -71.91262846386981), // Reservorio
      const LatLng(-13.524781240289553, -71.91241159109364), // Cuesta
      const LatLng(-13.523458840513905, -71.91357741257137), // Desvío
      const LatLng(-13.522027631800235, -71.9141203764151), // Punanmarca
      const LatLng(-13.521677309989409, -71.91630361383369), // Kiosko
      const LatLng(-13.522157543078242, -71.91963182747426), // Bosque
      const LatLng(-13.522917813329652, -71.92229451730195), // Quebrada
      const LatLng(-13.522827239697001, -71.92445813361894), // Canchón
      const LatLng(-13.522089888079252, -71.92680582457037), // Mercado Virgen del Carmen
      const LatLng(-13.521621850295956, -71.92627600802452), // San Nicolás
      const LatLng(-13.520943505380782, -71.92510594961924), // Confraternidad
      const LatLng(-13.520666617212525, -71.92463220059315), // Atahuallpa
      const LatLng(-13.520802425816026, -71.92414594292602), // Final Tienda (Valle de los Duendes)
    ],
  ),  Bus(
    name: 'Rápidos',
    code: 'RTU-15',
    route: [
      const LatLng(-13.515028488388237, -71.98779087128483),
      // Avenue Ayahuayco,28
      const LatLng(-13.516157578914196, -71.98763602761557),
      //Arcopata
      const LatLng(-13.516260517063014, -71.98693671398539),
      //Avenida Apurimac,595
      const LatLng(-13.515859333030015, -71.98380075531524),
      //Esquina Arcopata
      const LatLng(-13.51740969980007, -71.98254613528833),
      //Arones
      const LatLng(-13.518787882429022, -71.9815715516448),
      //Plaza San Francisco
      const LatLng(-13.520287966035264, -71.9799410512226),
      //Mesón de la Estrella
      const LatLng(-13.521004051386107, -71.97928396204631),
      //Matara
      const LatLng(-13.52050866888769, -71.97850476126645),
      //Ayacucho
      const LatLng(-13.51948365181845, -71.97761927589094),
      //Av Sol - EL Sol
      const LatLng(-13.519816620671133, -71.97628435637807),
      //Pampa De Castillo, 408
      const LatLng(-13.51985299601859, -71.97340776265365),
      //Limacpampa
      const LatLng(-13.520187295257758, -71.9714780010104),
      //Huascar
      const LatLng(-13.52062921878832, -71.9687721829894),
      //Tacna - Clorinda Matto
      const LatLng(-13.521317532907313, -71.96651320899271),
      //Garcilaso
      const LatLng(-13.522359303212086, -71.9631560083819),
      //Amauta
      const LatLng(-13.52347720169373, -71.95948577846217),
      //Univercidad San Antonio de Abad
      const LatLng(-13.524473967615657, -71.95626285928323),
      // Hospital Regional
      const LatLng(-13.525736587902498, -71.95196221699389),
      //Manuel Prado
      const LatLng(-13.526705866234407, -71.94887952422619),
      //Magisterio
      const LatLng(-13.527464308545843, -71.94615587236648),
      // Marcavalle
      const LatLng(-13.527795690068562, -71.94333863965413),
      // Santa Ursula
      const LatLng(-13.528193249388455, -71.94018526301657),
      // Primer paradero de San Sebastia
      const LatLng(-13.528728880776407, -71.93834060938691),
      // callejon
      const LatLng(-13.529330563309049, -71.9362245362867),
      // Segundo  paradero de San Sebastian
      const LatLng(-13.529658446725437, -71.93496250356029),
      // Tercero paradero de San Sebastian
      const LatLng(-13.530284676783914, -71.93280987118418),
      // Cuarto paradero de San Sebastian
      const LatLng(-13.531073107156718, -71.93009082154326),
      // quinto paradero de San Sebastian
      const LatLng(-13.53150618723304, -71.92835825349091),
      //  Sexto paradero de San Sebastian
      const LatLng(-13.53229298699121, -71.92571276515717),
      // Setimo paradero de San Sebastian
      const LatLng(-13.53302870660512, -71.92269590581027),
      // Camionero
      const LatLng(-13.532857178742448, -71.92090292990267),
      // Santa Rosa
      const LatLng(-13.532514677489024, -71.9193561097896),
      // Mercadillo
      const LatLng(-13.531765746120982, -71.91619485062255),
      // San migel
      const LatLng(-13.5319909959673, -71.91430716139831),
      // Sol de Oro
      const LatLng(-13.533597036001527, -71.91189349444828),
      // Enaco
      const LatLng(-13.535385233636358, -71.90926541568524),
      // Cachimayo
      const LatLng(-13.53635067456182, -71.90770696115035),
      // puente
      const LatLng(-13.536960382610417, -71.90680389749781),
      // Grifo
      const LatLng(-13.5386855027454, -71.90415142310371),
      // Univercidad Andina
      const LatLng(-13.538267776002398, -71.90368091973673),
      //Entrada
      const LatLng(-13.53707968371883, -71.9031724216996),
      //Esquina(2 Álamos)
      const LatLng(-13.53550174841079, -71.90247347564437),
      //Circunvalacion Norte, 260(parque)
      const LatLng(-13.535884699044168, -71.90146690204335),
      //Circunvalacion Norte, 260
      const LatLng(-13.538398914998968, -71.89824986671877),
      //Circunvalacion Norte, 260
      const LatLng(-13.540696189650678, -71.89379934089561),
      //Ciro Alegria
      const LatLng(-13.54209828684231, -71.89020181169562),
      //Lima, 15
      const LatLng(-13.54073397512021, -71.88802520747781),
      //Circunvalacion Norte, 869
    ],
  ),
  Bus(
    name: 'Servicio Rápido',
    code: 'RTU-16',
    route:[
      const LatLng(-13.510779702728309, -71.99498116045721), // Estacionamiento Servicio Rápido S.A. (5 de Abril)
      const LatLng(-13.509383259621023, -71.99699345715662), // APV Villa Flor
      const LatLng(-13.50935137549229, -71.99636224979714), // Pasaje
      const LatLng(-13.508616652620619, -71.99719536674041), // Ferretería "El Amigo Soto"
      const LatLng(-13.508071560506165, -71.99641601145312), // Escaleras
      const LatLng(-13.50758426744558, -71.99742192808864), // Posta Miraflores
      const LatLng(-13.507096568281485, -71.99660366416995), // Grifo Tica Tica
      const LatLng(-13.504339096036611, -71.99605225552364), // Cruce Santa Ana
      const LatLng(-13.504598473419557, -71.9952921768615), // Huertos
      const LatLng(-13.506458622858023, -71.99482041994564), // Chozas
      const LatLng(-13.505753623158865, -71.99345118333842), // Callanca
      const LatLng(-13.507175785520701, -71.99309766110987), // Chinchero
      const LatLng(-13.509386292909634, -71.99166480544044), // Calle D
      const LatLng(-13.510364347410448, -71.99124445404703), // San Benito
      const LatLng(-13.512483595421834, -71.9879078247114), // Libertadores
      const LatLng(-13.513421719486523, -71.98681837438247), // Pasaje San Sebastián
      const LatLng(-13.51442075387159, -71.9854445241153), // Plazoleta Santa Ana
      const LatLng(-13.515295976532267, -71.98632072237494), // Fierro
      const LatLng(-13.516157578914196, -71.98763602761557), //Arcopata
      const LatLng(-13.516260517063014, -71.98693671398539), //Avenida Apurimac,595
      const LatLng(-13.515859333030015, -71.98380075531524), //Esquina Arcopata
      const LatLng(-13.516462186791044, -71.9831570813501), // Meloc
      const LatLng(-13.51740969980007, -71.98254613528833), //Arones
      const LatLng(-13.518787882429022, -71.9815715516448), //Plaza San Francisco
      const LatLng(-13.520287966035264, -71.9799410512226), //Mesón de la Estrella
      const LatLng(-13.521004051386107, -71.97928396204631), //Matara
      const LatLng(-13.52050866888769, -71.97850476126645), //Ayacucho
      const LatLng(-13.51948365181845, -71.97761927589094), //Av Sol - EL Sol
      const LatLng(-13.519816620671133, -71.97628435637807), // Pampa del Castillo
      const LatLng(-13.51985299601859, -71.97340776265365), // Limacpampa
      const LatLng(-13.520187295257758, -71.9714780010104), // Huáscar
      const LatLng(-13.52062921878832, -71.9687721829894), // Tacna -Corinda Matto
      ...culturaRoutes,
      const LatLng(-13.53302870660512, -71.92269590581027), // Camionero
      const LatLng(-13.532857178742448, -71.92090292990267), // Santa Rosa
      const LatLng(-13.532514677489024, -71.9193561097896), // Mercadillo
      const LatLng(-13.531765746120982, -71.91619485062255), // San Miguel
      const LatLng(-13.5319909959673, -71.91430716139831), // Sol de Oro
      const LatLng(-13.533597036001527, -71.91189349444828), // Enaco
      const LatLng(-13.535385233636358, -71.90926541568524), // Cachimayo
      const LatLng(-13.53635067456182, -71.90770696115035), // Puente Túpac Amaru
      const LatLng(-13.536960382610417, -71.90680389749781), // Grifo Móvil
      const LatLng(-13.5386855027454, -71.90415142310371), // Universidad Andina
      const LatLng(-13.531917490971438, -71.90090009264676), // Los Pinos
      const LatLng(-13.531150639449589, -71.90055320105242), // Esquina
      const LatLng(-13.531894000683234, -71.89867189173397), // Paradero Servicio Rápido S.A. (Larapa)
    ],
  ),
  Bus(
    name: 'Ttio la Florida',
    code: 'RTU-17',
    route:[
      const LatLng(-13.516492936763045, -71.98885022972789), // Centro de Salud Picchu La Rinconada
      const LatLng(-13.515279456777154, -71.98829650706105), // 9 de Diciembre
      const LatLng(-13.516260517063014, -71.98693671398539), //Avenida Apurimac,595
      const LatLng(-13.515859333030015, -71.98380075531524), //Esquina Arcopata
      const LatLng(-13.516462186791044, -71.9831570813501), // Meloc
      const LatLng(-13.51740969980007, -71.98254613528833), //Arones
      const LatLng(-13.517804983666027, -71.98309016222954), // Colegio San Francisco
      const LatLng(-13.51840750065633, -71.98408068124347), // Unión
      const LatLng(-13.520033173205292, -71.98241121664299), // Mercado San Pedro
      const LatLng(-13.519672104340568, -71.98165947225577), // Condevidayoc
      const LatLng(-13.520287966035264, -71.9799410512226), // Mesón de la Estrella
      const LatLng(-13.521004051386107, -71.97928396204631), // Matará
      const LatLng(-13.52050866888769, -71.97850476126645), // Ayacucho
      const LatLng(-13.51948365181845, -71.97761927589094), // El Sol
      const LatLng(-13.520410531363503, -71.97670841673501), // Qoricancha
      const LatLng(-13.522869891491233, -71.9746424978066), // Correo
      const LatLng(-13.525752265081335, -71.97216209719083), // Estación Avenida Pardo
      const LatLng(-13.52817326771042, -71.9707900124316), // Confraternidad
      const LatLng(-13.529277345250904, -71.97017187189006), // Cruce Andina
      const LatLng(-13.530603098638641, -71.9694211495448), // Parque Urpicha
      const LatLng(-13.53128336687838, -71.96891870142359), // Óvalo Pachacuteq(bajada)
      const LatLng(-13.532072357675244, -71.96719097020294),//Monumento Inca Pachacutec
      const LatLng(-13.532072602597596, -71.96519303769574), // Primer Puente
      const LatLng(-13.532420609294295, -71.9623055578912), // Segundo Puente
      const LatLng(-13.532639517845867, -71.96011752846148), // Tercer Paradero (DE VIA EXPRESA)
      const LatLng(-13.532943099535022, -71.95841818889508), // Cuarto Puente
      const LatLng(-13.533172298832634, -71.95582927932803), // Quinto Puente
      const LatLng(-13.530469964235705, -71.95485036081416), // Túpac Amaru
      const LatLng(-13.531114390515251, -71.95174294104582), // República de Brasil
      const LatLng(-13.5317882549519, -71.94926647122612), // Colombia
      const LatLng(-13.532605390357851, -71.94738993168414), // Chile
      const LatLng(-13.532852787185696, -71.94544835494564), // Américas
      const LatLng(-13.532461306692843, -71.94240574554846), // República de Argentina
      const LatLng(-13.531729653019063, -71.94013261849506), // República del Perú
      const LatLng(-13.534189539328375, -71.93934791438724), // Vía Expresa
      const LatLng(-13.53505492301468, -71.9354152285981), // Sucre
      const LatLng(-13.53530092044513, -71.93345547338485), // Tomás Tuyro Túpac
      const LatLng(-13.535633472711863, -71.92969659829006), // Las Palmeras
      const LatLng(-13.535563985510992, -71.92586854455735), // Vía Expresa
      const LatLng(-13.53229298699121, -71.92571276515717), // 7mo Paradero SS
      const LatLng(-13.53302870660512, -71.92269590581027), // Camionero
      const LatLng(-13.532857178742448, -71.92090292990267), // Santa Rosa
      const LatLng(-13.532514677489024, -71.9193561097896), // Mercadillo
      const LatLng(-13.531765746120982, -71.91619485062255), // San Miguel
      const LatLng(-13.5319909959673, -71.91430716139831), // Sol de Oro
      const LatLng(-13.533597036001527, -71.91189349444828), // Enaco
      const LatLng(-13.535385233636358, -71.90926541568524), // Cachimayo
      const LatLng(-13.53635067456182, -71.90770696115035), // Puente Túpac Amaru
      const LatLng(-13.536960382610417, -71.90680389749781), // Grifo Móvil
      const LatLng(-13.5386855027454, -71.90415142310371), // Universidad Andina
      const LatLng(-13.539535889574514, -71.90297443193317), // Teléfono
      const LatLng(-13.540785265181189, -71.90125454267654), // Tingo
      const LatLng(-13.541820755214406, -71.8997920052805), // Aprovite
      const LatLng(-13.542954619876825, -71.89817198804033), // San Martín
      const LatLng(-13.54461627363419, -71.89580443596408), // Miraflores
      const LatLng(-13.545133850139878, -71.89473223926336), // Penal
      const LatLng(-13.54589620690304, -71.89211010406221), // San Juan
      const LatLng(-13.546039012482021, -71.8899699749744), // Control
      const LatLng(-13.542833513633637, -71.8881618111077), //Mercado Vinocanchón(Subida)
      const LatLng(-13.540841004393553, -71.88686027855628), //  Urbanización Pancho Flores
      const LatLng(-13.541709955710608, -71.88353578656286), // Clorinda Matto de Turner
      const LatLng(-13.541601463107718, -71.88185452189158), // Sorama
      const LatLng(-13.541305362203751, -71.88006554914602), // Almudena
    ],
  ),
  Bus(
    name: 'Correcaminos',
    code: 'RTU-18',
    route:[
      const LatLng(-13.519952324957687, -71.9934625234991), // Los Cipreses
      const LatLng(-13.519417540925565, -71.99163187588634), // Colegio Simón Bolívar
      const LatLng(-13.520645671505939, -71.99003032359545), // Cuesta Picchu
      const LatLng(-13.520642382420794, -71.98790184454347), // Cruce
      const LatLng(-13.51903340805543, -71.98679999634643), // Qheswa
      const LatLng(-13.518491595521871, -71.98695557939872), // Petrocentro
      const LatLng(-13.51695256430695, -71.98703936766695), // Ataneo
      const LatLng(-13.516260517063014, -71.98693671398539), //Avenida Apurimac,595- acropata
      const LatLng(-13.515859333030015, -71.98380075531524), //Esquina Arcopata
      const LatLng(-13.516462186791044, -71.9831570813501), // Meloc
      const LatLng(-13.51740969980007, -71.98254613528833), //Arones
      const LatLng(-13.516260517063014, -71.98693671398539), //Avenida Apurimac,595- acropata
      const LatLng(-13.515859333030015, -71.98380075531524), //Esquina Arcopata
      const LatLng(-13.516462186791044, -71.9831570813501), // Meloc
      const LatLng(-13.51740969980007, -71.98254613528833), //Arones
      const LatLng(-13.517804983666027, -71.98309016222954), // Colegio San Francisco
      const LatLng(-13.51840750065633, -71.98408068124347), // Unión
      const LatLng(-13.520033173205292, -71.98241121664299), // Mercado San Pedro
      const LatLng(-13.519672104340568, -71.98165947225577), // Condevidayoc
      const LatLng(-13.520696572507838, -71.9809342592476), // Calle Cruz Verde
      const LatLng(-13.521173825699405, -71.98026976280653), // Calle Nueva
      const LatLng(-13.51948365181845, -71.97761927589094),  // Ayacucho
      const LatLng(-13.519527881754883, -71.97648569498786), // El Sol
      const LatLng(-13.520410531363503, -71.97670841673501), // Qoricancha
      const LatLng(-13.522869891491233, -71.9746424978066), // Correo
      const LatLng(-13.525752265081335, -71.97216209719083), // Estación Avenida Pardo
      const LatLng(-13.52817326771042, -71.9707900124316), // Confraternidad
      const LatLng(-13.529277345250904, -71.97017187189006), // Cruce Andina
      const LatLng(-13.530603098638641, -71.9694211495448), // Parque Urpicha
      const LatLng(-13.53128336687838, -71.96891870142359), // Óvalo Pachacuteq(bajada)
      const LatLng(-13.532288425140855, -71.96740873704128), // Entrada a Terminal
      const LatLng(-13.533240130931372, -71.96662279955476), // Hospedaje
      const LatLng(-13.534723439660278, -71.963959601254), // El Molino
      const LatLng(-13.535179069852408, -71.96126085076199), // Puente
      const LatLng(-13.534911227534929, -71.96093748368892), // Unión
      const LatLng(-13.535253090067648, -71.95867946892523), // Cuarto
      const LatLng(-13.535691096302816, -71.95697061443421), // Quinto
      const LatLng(-13.536063392660623, -71.95584766294358), // Coliseo Uriel Gacria
      const LatLng(-13.537546293772747, -71.95106506570649), // Reloj
      const LatLng(-13.538137959780059, -71.94858500008617), // Quiosco
      const LatLng(-13.538945374360077, -71.94517213766076), // Aeropuerto Velasco Astete
      const LatLng(-13.539107384113452, -71.94181935580576), // Hilario
      const LatLng(-13.541528551476214, -71.9385143948445), // Chavín
      const LatLng(-13.542259271002047, -71.9353141058617), // Entrada Mollecito
      const LatLng(-13.542323829133053, -71.92695469379385), // Posta San Antonio
      const LatLng(-13.541929877728448, -71.92418620814134), // Paradero Zetar
      const LatLng(-13.541704735333663, -71.91754761280804), // Lorena
      const LatLng(-13.54168148770346, -71.91552509532357), // Villa El Salvador
      const LatLng(-13.541466408689194, -71.90918501584991), // Túpac Amaru
      const LatLng(-13.541514321189172, -71.90635860107156), // Rosa Túpac Amaru
      const LatLng(-13.545190323762919, -71.89926414563625), // Entrada Sucucalle
      const LatLng(-13.546775738638745, -71.89677221324048), // Puente Huatanay
      const LatLng(-13.547861788594028, -71.89506314734203), // Santa Elena
      const LatLng(-13.549086375622288, -71.89288213564313), // Mercado de Frutas
      const LatLng(-13.550740469304397, -71.88910851499215), // Villa El Sol
      const LatLng(-13.552659068674258, -71.88446853085053), // Plaza Chimpahuaylla
      const LatLng(-13.553581029196236, -71.8804579560037), // Vallecito
    ],
  ),
  Bus(
    name: 'C4M',
    code: 'RTU-19',
    route:[
      const LatLng(-13.522992742376152, -71.99183322223698), // 28 de Julio
      const LatLng(-13.524399342824944, -71.99158369561448), // Venezuela
      const LatLng(-13.525301963059212, -71.99193305369809), // Puente
      const LatLng(-13.526349292300651, -71.99101226096165), // Chicago
      const LatLng(-13.528081980821097, -71.98951066995055), // Curva
      const LatLng(-13.526745683959179, -71.98932394512786), // Grifo Terminal
      const LatLng(-13.525474493238212, -71.98903574650758), // Terminal de Quillabamba
      const LatLng(-13.525977176789878, -71.9874342437958), // Almudena
      const LatLng(-13.524624734107995, -71.9860438340637), // 7 Mascarrones
      const LatLng(-13.524825125516703, -71.98545613459665), // Villa del Sol
      const LatLng(-13.525479946153322, -71.98378211796806), //  Esquina Plaza Santiago
      const LatLng(-13.526165040068918, -71.98198980252445), // Colegio Fe y Alegría
      const LatLng(-13.526584631060507, -71.98074086655129), // Plaza Belén
      const LatLng(-13.52373993273681, -71.97997802482969),  // Puente Belén
      const LatLng(-13.522733601403077, -71.97727410165174), // Matará
      const LatLng(-13.521898937932715, -71.97832380910147), // Lechugal
      const LatLng(-13.52100086120398, -71.97658997513967), // El Sol
      const LatLng(-13.522869891491233, -71.9746424978066), // Correo
      const LatLng(-13.522419520626036, -71.97323835958935), // 20. La Salle
      const LatLng(-13.523581193698904, -71.97170501615281), // Manco Inca(una cuadra abajo)
      const LatLng(-13.523806105612234, -71.96999152752124), // Wayna Capac(una cuadra abajo)
      const LatLng(-13.523939499358884, -71.96896300957636), // Tacna(una cuadra abajo)
      const LatLng(-13.526783666191482, -71.96862449892237), // Marianito Ferro
      const LatLng(-13.529349419306339, -71.96858220431963), // La Paz
      const LatLng(-13.530917264349796, -71.9685646958755),  // Óvalo Pachatuteq(Av infancia)
      const LatLng(-13.532072357675244, -71.96719097020294),//Monumento Inca Pachacutec
      const LatLng(-13.532072602597596, -71.96519303769574), // Primer Puente
      const LatLng(-13.532420609294295, -71.9623055578912), // Segundo Puente
      const LatLng(-13.532639517845867, -71.96011752846148), // Tercer Paradero (DE VIA EXPRESA)
      const LatLng(-13.532943099535022, -71.95841818889508), // Cuarto Puente
      const LatLng(-13.533172298832634, -71.95582927932803), // Quinto Puente
      const LatLng(-13.534459727784318, -71.95557498046927), // Coliseo Uriel García(todo de bajada)
      const LatLng(-13.535876453803771, -71.95567657313528), // Primero de Velasco
      const LatLng(-13.537546293772747, -71.95106506570649), // Reloj
      const LatLng(-13.538137959780059, -71.94858500008617), // Quiosco
      const LatLng(-13.538945374360077, -71.94517213766076), // Aeropuerto Velasco Astete
      const LatLng(-13.539107384113452, -71.94181935580576), // Hilario
      const LatLng(-13.539540297558982, -71.93905559961827), // San Luis
      const LatLng(-13.54027161999868, -71.93713404945352), // Cevicheria
      const LatLng(-13.540574495320783, -71.93567873092663), // Kiosko - Nogales
      const LatLng(-13.540754324883212, -71.93483952867186), // Esquina Paracas
      const LatLng(-13.541187334787475, -71.93280910167373), // Gradas
      const LatLng(-13.541240489544963, -71.93168518638325), // Manantiales
      const LatLng(-13.542323829133053, -71.92695469379385), // Posta San Antonio
      const LatLng(-13.541929877728448, -71.92418620814134), // Paradero Zetar
      const LatLng(-13.541704735333663, -71.91754761280804), // Lorena
      const LatLng(-13.54168148770346, -71.91552509532357), // Villa El Salvador
      const LatLng(-13.541195773103448, -71.91163796744146), // Puente Tomás Katari
      const LatLng(-13.539660194505156, -71.91162500183614), // Medio
      const LatLng(-13.538115811052519, -71.91166754188112), // Mini Hospital
      const LatLng(-13.535356344072982, -71.9126822462964), // Colegio
      const LatLng(-13.533736727050519, -71.91173194756323), // Enaco
      const LatLng(-13.535385233636358, -71.90926541568524), // Cachimayo
      const LatLng(-13.53635067456182, -71.90770696115035), // Puente Túpac Amaru
      const LatLng(-13.536960382610417, -71.90680389749781), // Grifo Móvil
      const LatLng(-13.5386855027454, -71.90415142310371), // Universidad Andina
      const LatLng(-13.539535889574514, -71.90297443193317), // Teléfono
      const LatLng(-13.540785265181189, -71.90125454267654), // Tingo
      const LatLng(-13.541820755214406, -71.8997920052805), // Aprovite
      const LatLng(-13.542954619876825, -71.89817198804033), // San Martín
      const LatLng(-13.54461627363419, -71.89580443596408), // Miraflores
      const LatLng(-13.545133850139878, -71.89473223926336), // Penal
      const LatLng(-13.54589620690304, -71.89211010406221), // San Juan
      const LatLng(-13.546039012482021, -71.8899699749744), // Control
      const LatLng(-13.542833513633637, -71.8881618111077), //Mercado Vinocanchón(Subida)
      const LatLng(-13.540841004393553, -71.88686027855628), //  Urbanización Pancho Flores
    ],
  ),
  Bus(
    name: ' Arco Iris',
    code: 'RTU-20',
    route:[

      const LatLng(-13.534058563793359, -71.98988506614332), // Paradero Arco Iris S.A.
      const LatLng(-13.535625155838417, -71.99060040772623), // APV Los Jardines
      const LatLng(-13.535329371621193, -71.99145083321869), // Callejón
      const LatLng(-13.533626322040805, -71.9920095612231),  // Casablanca
      const LatLng(-13.531443829031783, -71.99217691910853), // Virgen Concepción
      const LatLng(-13.531321117824614, -71.9931993077235),  // 1 de Mayo
      const LatLng(-13.529199577356009, -71.99216960197946), // 1 de Diciembre
      const LatLng(-13.528364162885381, -71.99209701020281), // Sol Moqueguano
      const LatLng(-13.52699426226316, -71.99232833217438),  // Curva
      const LatLng(-13.528003511082185, -71.99149977890829), // Escaleras
      const LatLng(-13.527376031476681, -71.99118214472274), // Esquina
      const LatLng(-13.526384745800447, -71.99100898184264), // Chicago
      const LatLng(-13.528081980821097, -71.98951066995055), // Curva
      const LatLng(-13.526745683959179, -71.98932394512786), // Grifo Terminal
      const LatLng(-13.525474493238212, -71.98903574650758), // Terminal de Quillabamba
      const LatLng(-13.525977176789878, -71.9874342437958), // Almudena
      const LatLng(-13.524624734107995, -71.9860438340637), // 7 Mascarrones
      const LatLng(-13.524825125516703, -71.98545613459665), // Villa del Sol
      const LatLng(-13.525479946153322, -71.98378211796806), //  Esquina Plaza Santiago
      const LatLng(-13.526165040068918, -71.98198980252445), // Colegio Fe y Alegría
      const LatLng(-13.526584631060507, -71.98074086655129), // Plaza Belén
      const LatLng(-13.52373993273681, -71.97997802482969),  // Puente Belén
      const LatLng(-13.51948365181845, -71.97761927589094),  // Ayacucho
      const LatLng(-13.519527881754883, -71.97648569498786), // El Sol
      const LatLng(-13.519816620671133, -71.97628435637807), // Pampa del Castillo
      const LatLng(-13.51985299601859, -71.97340776265365), // Limacpampa
      const LatLng(-13.520187295257758, -71.9714780010104), // Huáscar
      const LatLng(-13.52062921878832, -71.9687721829894), // Tacna -Corinda Matto
      const LatLng(-13.521317532907313, -71.96651320899271), // Garcilaso
      const LatLng(-13.520892695076501, -71.96085915573181), // Puerta 6
      const LatLng(-13.519688254582398, -71.96067812481294), // Collasuyo
      const LatLng(-13.52009252256531, -71.95801373129119), // Andenes
      const LatLng(-13.520581495959867, -71.95546254764842), // Paradero Kiosko
      const LatLng(-13.520706914864077, -71.95464644810811), // Paradero Aldea
      const LatLng(-13.52108602409088, -71.95300701877257), // Manzanares
      const LatLng(-13.521736144725987, -71.9500031915857), // Plaza Vea
      const LatLng(-13.522635434247318, -71.94615345569918), // Restaurante
      const LatLng(-13.523155567486477, -71.94470393497726), // Imperio
      const LatLng(-13.524177567417999, -71.94369061051817), // Universidad Global
      const LatLng(-13.5249081908304, -71.94297054056183), // Paradero
      const LatLng(-13.525339515245397, -71.94253051984897), // Trilce
      const LatLng(-13.525709644683547, -71.94107301843682), // Esquina
      const LatLng(-13.525916221478433, -71.93963699526554), // Iquique
      const LatLng(-13.524906727683936, -71.93946447223723), // Calle Bolívar
      const LatLng(-13.525396848557518, -71.93836268640094), // Velasco Alvarado
      const LatLng(-13.526081943982572, -71.93667112568419), // Albergue
      const LatLng(-13.527541816706869, -71.93567317140175), // Rompemuelle
      const LatLng(-13.529054012729409, -71.93599579521914), //  Esquina Segundo Paradero de San Sebastián
      const LatLng(-13.529658446725437, -71.93496250356029), // 3er Paradero SS
      const LatLng(-13.530284676783914, -71.93280987118418), // 4to Paradero SS
      const LatLng(-13.5302636076592, -71.93153488596427), // ALTO QOSQO

    ],
  ),
  Bus(
    name: 'Huancaro',
    code: 'RTU-21',
    route:[
      const LatLng(-13.545273447458865, -71.98618289219856), // Cementerio Huancaro
      const LatLng(-13.543994811186087, -71.98502914412511), // Luis Vallejo Santoni
      const LatLng(-13.542769331283674, -71.9841564760678),  // Estrella
      const LatLng(-13.541839, -71.983519), // 4. Apurímac
      const LatLng(-13.540637, -71.982743), // 5. Domingo Guevara
const LatLng(-13.538639983338438, -71.98176089799405), // Iglesia
const LatLng(-13.53645253302605, -71.98085215520875), // Mercado Mayorista
      const LatLng(-13.535192860916103, -71.98055410631179), // Colegio San Jose Obreo
      const LatLng(-13.532433597269412, -71.98009661252236), // Perú
      const LatLng(-13.529812417151286, -71.97942082732858), // Zarzuela
      const LatLng(-13.527171116080098, -71.97872044336115), // Ccoripata
      const LatLng(-13.526360188477142, -71.98066161849623), // Plaza Belén
      const LatLng(-13.522733601403077, -71.97727410165174), // Matará
      const LatLng(-13.521898937932715, -71.97832380910147), // Lechugal
      const LatLng(-13.524234, -71.975764), // 18. Humberto Luna
      const LatLng(-13.523624998650662, -71.97509481269873), // Pardo Paseo de los Héroes
      const LatLng(-13.525453670428083, -71.97248150922731), // Estación Hotel
      const LatLng(-13.522659405963207, -71.97295469835984), // La Salle (Subida)
      const LatLng(-13.522428198917847, -71.97233149918758), // Mercado Wanchaq
      const LatLng(-13.52261238771284, -71.97102501605578), // Manco Inca
      const LatLng(-13.522825358523258, -71.96988870113522), // Huayna Capac
      const LatLng(-13.521980567943329, -71.96846333931995), // Institución Educativa
      const LatLng(-13.520753160755225, -71.96853990286903), // Grifo
      const LatLng(-13.519903189594572, -71.96860739241963), // Plaza Zarumilla(Zarumilla)
      const LatLng(-13.517956787117527, -71.96843072048752), // Retiro
      const LatLng(-13.517488200536622, -71.9678071611385), // Recolecta
      const LatLng(-13.518001331967485, -71.96582841508118), // Mercado de Rosaspata
      const LatLng(-13.518521468447279, -71.96381199843266), // Mariscal Gamarra
      const LatLng(-13.518596725034149, -71.96139051083324), // Occhullo
      const LatLng(-13.517618345430112, -71.96032370311407), // Andes Perú
      const LatLng(-13.517214181771518, -71.95933799006903), // Hotel Mirador
      const LatLng(-13.516830810882585, -71.95715476731603), // Lorohuachana
      const LatLng(-13.51686354944264, -71.95302328013821), // Estanquillo
      const LatLng(-13.517072529675564, -71.95193220181318), // Bombonera
      const LatLng(-13.518348201184653, -71.9528637836363), // Colegio de Tipón
      const LatLng(-13.519371793467167, -71.95186072176779), // Paracas
      const LatLng(-13.519037272289234, -71.95062974819254), // Garcilaso(Paradero Final de Transportes Columbia)
      const LatLng(-13.519089494138875, -71.95043235300287), //  Esquina
      const LatLng(-13.520154887042487, -71.95022511423481), //  Medio
      const LatLng(-13.52062539316546, -71.94882555019343),  //  Dirigentes
      const LatLng(-13.520901390867596, -71.94836223036904), //  Primero de Mayo
    ],
  ),
  Bus(
    name: 'Servicio Andino',
    code: 'RTU-22',
    route:[
      const LatLng(-13.519952324957687, -71.9934625234991), // Los Cipreses
      const LatLng(-13.519417540925565, -71.99163187588634), // Colegio Simón Bolívar
      const LatLng(-13.520645671505939, -71.99003032359545), // Cuesta Picchu
      const LatLng(-13.520642382420794, -71.98790184454347), // Cruce
      const LatLng(-13.51903340805543, -71.98679999634643), // Qheswa
      const LatLng(-13.516260517063014, -71.98693671398539), //Avenida Apurimac,595- acropata
      const LatLng(-13.515859333030015, -71.98380075531524), //Esquina Arcopata
      const LatLng(-13.516462186791044, -71.9831570813501), // Meloc
      const LatLng(-13.51740969980007, -71.98254613528833), //Arones
      const LatLng(-13.517804983666027, -71.98309016222954), // Colegio San Francisco
      const LatLng(-13.51840750065633, -71.98408068124347), // Unión
      const LatLng(-13.520033173205292, -71.98241121664299), // Mercado San Pedro
      const LatLng(-13.519672104340568, -71.98165947225577), // Condevidayoc
      const LatLng(-13.520696572507838, -71.9809342592476), // Calle Cruz Verde
      const LatLng(-13.521173825699405, -71.98026976280653), // Calle Nueva
      const LatLng(-13.51948365181845, -71.97761927589094),  // Ayacucho
      const LatLng(-13.519527881754883, -71.97648569498786), // El Sol
      const LatLng(-13.519816620671133, -71.97628435637807), // Pampa del Castillo
      const LatLng(-13.51985299601859, -71.97340776265365), // Limacpampa
      const LatLng(-13.520187295257758, -71.9714780010104), // Huáscar
      const LatLng(-13.52062921878832, -71.9687721829894), // Tacna -Corinda Matto
      const LatLng(-13.519903189594572, -71.96860739241963), // Plaza Zarumilla(Zarumilla)
      const LatLng(-13.517956787117527, -71.96843072048752), // Retiro
      const LatLng(-13.517488200536622, -71.9678071611385), // Recolecta
      const LatLng(-13.518001331967485, -71.96582841508118), // Mercado de Rosaspata
      const LatLng(-13.518521468447279, -71.96381199843266), // Mariscal Gamarra
      const LatLng(-13.520885429518115, -71.96101713931262), // Universitaria(UNSSAC) puerta 6
      const LatLng(-13.52230709744588, -71.96124937474828),  // Amauta(av universitaria)
      const LatLng(-13.52347720169373, -71.95948577846217), //Univercidad San Antonio de Abad
      const LatLng(-13.524473967615657, -71.95626285928323), // Hospital Regional
      const LatLng(-13.525736587902498, -71.95196221699389), // Manuel Prado
      const LatLng(-13.526705866234407, -71.94887952422619), // Magisterio
      const LatLng(-13.527464308545843, -71.94615587236648), // Marcavalle
      const LatLng(-13.527795690068562, -71.94333863965413), // Santa Ursula
      const LatLng(-13.528193249388455, -71.94018526301657), // Primer paradero de San Sebastián
      const LatLng(-13.528728880776407, -71.93834060938691), // Callejón
      const LatLng(-13.529330563309049, -71.9362245362867), // Segundo paradero de San Sebastián
      const LatLng(-13.529658446725437, -71.93496250356029), // Tercero paradero de San Sebastián
      const LatLng(-13.530284676783914, -71.93280987118418), // Cuarto paradero de San Sebastián
      const LatLng(-13.531073107156718, -71.93009082154326), // Quinto paradero de San Sebastián
      const LatLng(-13.53150618723304, -71.92835825349091), // Sexto paradero de San Sebastián
      const LatLng(-13.53229298699121, -71.92571276515717), // Séptimo paradero de San Sebastián
      const LatLng(-13.53302870660512, -71.92269590581027), // Camionero
      const LatLng(-13.532857178742448, -71.92090292990267), // Santa Rosa
      const LatLng(-13.532514677489024, -71.9193561097896), // Mercadillo
      const LatLng(-13.531765746120982, -71.91619485062255), // San Miguel
      const LatLng(-13.5319909959673, -71.91430716139831), // Sol de Oro
      const LatLng(-13.533597036001527, -71.91189349444828), // Enaco
      const LatLng(-13.535385233636358, -71.90926541568524), // Cachimayo
      const LatLng(-13.53635067456182, -71.90770696115035), // Puente
      const LatLng(-13.536960382610417, -71.90680389749781), // Grifo
      const LatLng(-13.5386855027454, -71.90415142310371), // Universidad Andina
      const LatLng(-13.539535889574514, -71.90297443193317), // Teléfono
      const LatLng(-13.540785265181189, -71.90125454267654), // Tingo
      const LatLng(-13.541820755214406, -71.8997920052805), // Aprovite
      const LatLng(-13.542954619876825, -71.89817198804033), // San Martín
      const LatLng(-13.54461627363419, -71.89580443596408), // Miraflores
      const LatLng(-13.545133850139878, -71.89473223926336), // Penal
      const LatLng(-13.54589620690304, -71.89211010406221), // San Juan
      const LatLng(-13.546458319463957, -71.88966081845638), // Control-corporation roca
      const LatLng(-13.549113944431502, -71.88981949378771), // Montessoriano

    ],
  ),


  // Bus(
  //   name: 'Batman',
  //   code: 'RTU-23',
  //   route:[],
  // ),
  // Bus(
  //   name: 'Expreso Santiago',
  //   code: 'RTU-24',
  //   route:[],
  // ),
  // Bus(
  //   name: 'Yllary Qosqo',
  //   code: 'RTU-25',
  //   route:[],
  // ),
  // Bus(
  //   name: 'Expreso San Sebastián',
  //   code: 'RTU-26',
  //   route:[],
  // ),
  // Bus(
  //   name: 'Expreso el Zorro',
  //   code: 'RTU-27',
  //   route:[],
  // ),
  // Bus(
  //   name: 'Nueva Chaska',
  //   code: 'RTU-28',
  //   route:[],
  // ),
  // Bus(
  //   name: 'Doradino',
  //   code: 'RTU-30',
  //   route:[],
  // ),

];

