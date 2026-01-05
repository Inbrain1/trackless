# Scripts Directory - README

## ⚠️ Scripts Deshabilitados

Los siguientes scripts han sido **DESHABILITADOS** (renombrados con `.DISABLED`) para evitar que sobrescriban las coordenadas de las rutas en Firestore:

### Scripts Peligrosos (DESHABILITADOS)

| Script | Razón | Acción |
|--------|-------|--------|
| `fix_route_geometry.dart.DISABLED` | Sobrescribe campo `route` en busRoutes | ❌ NO EJECUTAR |
| `migrate_bus_stops.dart.DISABLED` | Migra paradas a colección `routes` | ❌ NO EJECUTAR |
| `seed_data.dart.DISABLED` | Sobrescribe datos completos de busRoutes desde JSON | ❌ NO EJECUTAR |
| `upload_cabildo_simple.dart.DISABLED` | Sobrescribe ruta "Señor del Cabildo" | ❌ NO EJECUTAR |
| `restore_cabildo.dart.DISABLED` | Restaura datos de Cabildo | ❌ NO EJECUTAR |
| `rutes_to_upload_to_firebase.dart.DISABLED` | Sube rutas específicas a Firestore | ❌ NO EJECUTAR |
| `setup_fireb.dart.DISABLED` | Setup inicial de Firebase | ❌ NO EJECUTAR |

### Scripts Seguros (ACTIVOS)

| Script | Propósito | Estado |
|--------|-----------|--------|
| `generate_full_route.dart` | Genera rutas suaves con Directions API, **SOLO actualiza campo `route`** | ✅ SEGURO |
| `verify_firestore.dart` | Verifica datos en Firestore (solo lectura) | ✅ SEGURO |
| `verify_firestore_users.dart` | Verifica usuarios en Firestore (solo lectura) | ✅ SEGURO |
| `verify_specific_route.dart` | Verifica ruta específica (solo lectura) | ✅ SEGURO |
| `check_cabildo.dart` | Verifica ruta Cabildo (solo lectura) | ✅ SEGURO |
| `find_cabildo.dart` | Busca ruta Cabildo (solo lectura) | ✅ SEGURO |
| `test.dart` | Script de pruebas | ✅ SEGURO |
| `test_parser.dart` | Parser de pruebas | ✅ SEGURO |

## 🚀 Cómo Usar `generate_full_route.dart`

Este es el **ÚNICO script** que debe usarse para actualizar rutas:

```bash
# Ejecutar en iPhone/iOS simulator
flutter run -d "iPhone 17 Pro" scripts/generate_full_route.dart

# O en macOS (requiere configuración)
flutter run -d macos scripts/generate_full_route.dart
```

### ✅ Lo que hace:
- Lee las paradas existentes del campo `stops`
- Llama a Google Directions API
- **SOLO actualiza el campo `route`**
- **NO toca el campo `stops`**

### ❌ Lo que NO hace:
- NO modifica coordenadas de paradas
- NO elimina datos
- NO sobrescribe `stops`

## 🔒 Protección de Datos

### Campos Protegidos en `busRoutes`:
- `stops` - **NUNCA debe modificarse**
- `name` - **NUNCA debe modificarse**
- `code` - **NUNCA debe modificarse**

### Campos Actualizables:
- `route` - Puede actualizarse con `generate_full_route.dart`
- `routeUpdatedAt` - Timestamp automático
- `routeSource` - Fuente de la ruta
- `routePointsCount` - Contador de puntos

## 📊 Estado Actual

**Última actualización**: 2025-12-28

- ✅ 30/30 rutas con polylines suaves
- ✅ Campo `stops` intacto
- ✅ Campo `route` actualizado con Directions API
- ✅ Scripts peligrosos deshabilitados

## ⚠️ IMPORTANTE

**NUNCA** renombres los archivos `.DISABLED` de vuelta a `.dart` sin antes:
1. Revisar el código
2. Confirmar que NO modifica `stops`
3. Hacer backup de Firestore
4. Obtener aprobación

## 🆘 Si Necesitas Restaurar

Si accidentalmente ejecutaste un script deshabilitado:

1. **NO PÁNICO**
2. Revisa los logs de Firestore
3. Usa el backup más reciente
4. Contacta al equipo de desarrollo

---

**Mantenido por**: Equipo de Desarrollo  
**Última revisión**: 2025-12-28
