class BusAssetHelper {
  static const String _basePath = 'assets/buses';

  // Map of normalized bus names (lowercase, no accents) to their specific filenames
  static final Map<String, String> _busImageMap = {
    'arco iris': 'Arco Iris.png',
    'c4m': 'C4M.png',
    'correcaminos': 'Correcaminos.png',
    'cristo blanco': 'Cristo Blanco.png',
    'cristo blaco': 'Cristo Blanco.png',
    'el chaki': 'El Chaki.jpg',
    'el chaski': 'El Chaki.jpg',
    'huancaro': 'Huancaro.jpg',
    'imperial': 'Imperial.jpg',
    'inka expreso': 'Inka Expreso.jpg',
    'inka express': 'Inka Expreso.jpg',
    'leon de san jeronimo': 'Leon de san jeronimo.jpg',
    'liebre': 'Liebre.jpg',
    'luis vallejos santoni': 'Luis Vallejos Santoni.jpg',
    'luis vallejo santoni': 'Luis Vallejos Santoni.jpg',
    'nuevo amanecer': 'Nuevo amanecer.jpg',
    'patron de san jeronimo': 'Patron de San jerónimo.jpg',
    'pegaso': 'Pegaso.jpg',
    'rapidos': 'Rápidos.jpg',
    'satelite': 'Satélite.jpg',
    'saylla huasao': 'Saylla Huasao.jpg',
    'saylla tipon oropesa': 'Saylla tipon Oropesa.jpg', // Fixed typo: Orepesa -> Oropesa
    'saylla tipon orepesa': 'Saylla tipon Oropesa.jpg', // Keep variant just in case
    'saylla tipon': 'Saylla Tipon.jpg', // Use distinct image since it exists
    'senor cabildo': 'Señor del Cabildo.jpg',
    'senor del cabildo': 'Señor del Cabildo.jpg',
    'senor del huerto': 'Señor del Huerto.jpg', // Fixed extension: .png -> .jpg
    'servicio rapido': 'Servicio Rápido.jpg',
    'servicio andino': 'Servicio andino.jpg',
    'tupac amaru': 'Tupac Amaru.jpg',
    'wimpillay': 'Wimpillay.jpg',
    'columbia': 'columbia.jpg',
    'culumbia': 'columbia.jpg',
    'el dorado': 'el Dorado.jpg',
    'nuevo mirador': 'nuevo mirador.jpg',
    'pachacutec': 'pachacutec.jpg',
    'titto la florida': 'Titto la Florida.jpg',
    'ttio la florida': 'Titto la Florida.jpg',
  };

  static String getBusImagePath(String busName) {
    if (busName.isEmpty) return 'assets/prototipo_bus_andina.png';

    // Normalize: lowercase, trim, and remove accents
    final normalizedName = _removeDiacritics(busName.toLowerCase().trim());
    
    // Check for exact match
    if (_busImageMap.containsKey(normalizedName)) {
      return '$_basePath/${_busImageMap[normalizedName]}';
    }

    // Fuzzy match: check if the normalized key is contained within the bus name or vice versa
    for (var key in _busImageMap.keys) {
      if (normalizedName.contains(key) || key.contains(normalizedName)) {
        return '$_basePath/${_busImageMap[key]}';
      }
    }

    // Default image if no match found
    return 'assets/prototipo_bus_andina.png';
  }

  static String _removeDiacritics(String str) {
    var withDia = 'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    var withoutDia = 'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

    for (int i = 0; i < withDia.length; i++) {
      str = str.replaceAll(withDia[i], withoutDia[i]);
    }
    return str;
  }
}


