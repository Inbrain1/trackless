# Bus Stops Migration Scripts

This directory contains scripts to migrate bus stop data from hardcoded Dart files to Cloud Firestore.

## 📁 Files

### 1. `test_parser.dart` 
**Purpose:** Test the parsing logic without touching Firebase.

**What it does:**
- Reads `lib/delete/data/bus_routes.dart`
- Uses regex to extract coordinates and stop names
- Validates the data
- Shows statistics and a preview

**Usage:**
```bash
dart scripts/test_parser.dart
```

**Output:**
- Total stops parsed
- Data validation results
- First & last 10 stops preview
- Duplicate name statistics

---

### 2. `migrate_bus_stops.dart`
**Purpose:** Full migration script that uploads data to Firestore.

**What it does:**
1. Parses the hardcoded bus routes file
2. Shows a preview of parsed data
3. **Asks for confirmation** before proceeding
4. Initializes Firebase
5. **Deletes all existing documents** in the `routes` collection
6. Uploads new data in **batches of 500** to avoid rate limits
7. Verifies the upload

**Usage:**
```bash
dart scripts/migrate_bus_stops.dart
```

**Safety Features:**
- ⚠️ Asks for confirmation before any Firebase operations
- 🗑️ Clears old data before uploading new data
- 📦 Uses batched writes (500 docs/batch) to avoid rate limits
- ✅ Verifies upload count after completion

---

## 🔍 Parsing Logic

### Regex Pattern
```regex
const\s+LatLng\s*\(\s*(-?\d+\.?\d*)\s*,\s*(-?\d+\.?\d*)\s*\)\s*,\s*//\s*(?:\d+\.\s*)?(.+?)(?:\s*$)
```

### What it matches:
```dart
const LatLng(-13.544466, -71.986992), // 1. Luis Vallejo Santoni
          ↑           ↑                      ↑
       latitude   longitude                 name
```

### Extraction groups:
- **Group 1:** Latitude (e.g., `-13.544466`)
- **Group 2:** Longitude (e.g., `-71.986992`)
- **Group 3:** Stop name (e.g., `Luis Vallejo Santoni`)

### Name cleaning:
- Removes leading/trailing whitespace
- Removes optional numbering prefix (e.g., `1. `)
- Skips spread operators (`...culturaRoutes`)

---

## 📊 Test Results (Latest Run)

```
✓ Parsed 1859 bus stops
✓ Unique stop names: 624
✓ Stops with duplicate names: 375
✓ All coordinates valid
✓ All coordinates in Cusco area
```

### Sample parsed data:
```dart
BusStop(lat: -13.544466, lng: -71.986992, name: "Luis Vallejo Santoni")
BusStop(lat: -13.5435505763437, lng: -71.98561188775224, name: "Losa 1")
BusStop(lat: -13.542744987648884, lng: -71.98445787311506, name: "Estrella")
```

---

## 🔥 Firestore Document Structure

Each bus stop will be stored as:
```json
{
  "location": GeoPoint(-13.544466, -71.986992),
  "name": "Luis Vallejo Santoni"
}
```

**Collection:** `routes`  
**Document ID:** Auto-generated  
**Total Documents:** 1859

---

## 🚀 Migration Workflow

### Step 1: Test the Parser (Optional but Recommended)
```bash
dart scripts/test_parser.dart
```
Review the output to ensure parsing is correct.

### Step 2: Run the Migration
```bash
dart scripts/migrate_bus_stops.dart
```

### Step 3: Confirm
When prompted:
```
Continue with Firebase migration? (yes/no):
```
Type `yes` to proceed.

### Step 4: Wait
The script will:
1. Delete existing documents (in batches)
2. Upload new documents (in batches of 500)
3. Verify the upload count

---

## ⚠️ Important Notes

1. **Duplicate Names:** Some stop names appear multiple times (e.g., "Luis Vallejo Santoni" appears 3 times). This is expected as the same stop may be used by different bus routes.

2. **Rate Limiting:** The script uses batched writes (500 docs/batch) to comply with Firestore limits.

3. **Data Deletion:** The migration script **deletes all existing documents** in the `routes` collection before uploading. Make sure you have a backup if needed.

4. **Firebase Config:** Ensure your Firebase project is properly configured in your Flutter app before running the migration.

---

## 🛠️ Troubleshooting

### File not found error
Make sure you run the script from the project root:
```bash
cd /Users/ibrain/IdeaProjects/trackless2
dart scripts/test_parser.dart
```

### Firebase initialization error
Ensure you have:
- Added `firebase_core` and `cloud_firestore` to `pubspec.yaml`
- Configured Firebase in your Flutter project
- Run `flutter pub get`

### Permission denied error
Make sure your Firebase security rules allow writes to the `routes` collection.

---

## 📝 Script Maintenance

If the format of `bus_routes.dart` changes, you may need to update the regex pattern in both scripts:

```dart
static final RegExp _pattern = RegExp(
  r'const\s+LatLng\s*\(\s*(-?\d+\.?\d*)\s*,\s*(-?\d+\.?\d*)\s*\)\s*,\s*//\s*(?:\d+\.\s*)?(.+?)(?:\s*$)',
  multiLine: true,
);
```

Test changes using `test_parser.dart` before running the full migration.
