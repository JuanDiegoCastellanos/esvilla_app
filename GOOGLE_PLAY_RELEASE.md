# Guía de Publicación en Google Play Store

## ✅ Estado Actual del Proyecto

### Versión Actual
- **Version Name:** 1.2.0
- **Version Code:** 4 (incrementado desde 3)

### Configuración Android
- **Namespace:** co.esvilla.esvilla_app
- **Application ID:** co.esvilla.esvilla_app
- **Min SDK:** 21 (Android 5.0)
- **Target SDK:** 35
- **Compile SDK:** 35

### Estado de Configuración
- ✅ Versioning configurado en pubspec.yaml
- ✅ Signing config configurado en build.gradle
- ✅ ProGuard habilitado para release
- ✅ Multidex habilitado
- ✅ Permisos configurados en AndroidManifest.xml
- ✅ Launcher icon configurado
- ✅ Assets y fonts configurados

## 📋 Checklist Pre-Publicación

### 1. Configurar archivo local.properties (ya debe existir)
```properties
flutter.versionCode=4
flutter.versionName=1.2.0
storeFile=/path/to/keystore.jks
storePassword=tu_password_store
keyPassword=tu_password_key
```

### 2. Verificar que el keystore existe
- Ubicación del keystore debe estar configurada
- Las contraseñas deben ser correctas
- Key alias: `esvilla_key`

### 3. Configuración de ProGuard
El archivo `android/app/proguard-rules.pro` debe contener las reglas necesarias.

## 🚀 Comandos para Generar el Bundle

### 1. Limpiar el proyecto
```bash
cd C:\Users\juanc\dev\personal_flutter_projects\esvilla_app
fvm flutter clean
fvm flutter pub get
```

### 2. Generar el App Bundle (formato requerido por Google Play)
```bash
fvm flutter build appbundle --release
```

Este comando generará el archivo:
```
build/app/outputs/bundle/release/app-release.aab
```

### 3. (Opcional) Generar APK para testing interno
```bash
fvm flutter build apk --release
```

Este comando generará:
```
build/app/outputs/flutter-apk/app-release.apk
```

### 4. Verificar el tamaño del bundle
```bash
bundletool build-apks --bundle=build/app/outputs/bundle/release/app-release.aab --output=output.apks
bundletool get-size total --apks=output.apks
```

## 📤 Subir a Google Play Console

### Pasos en Google Play Console:

1. **Iniciar sesión en Google Play Console**
   - https://play.google.com/console

2. **Crear la aplicación** (si es la primera vez)
   - Nombre de la app: "ESVILLA E.S.P."
   - Idioma predeterminado: Español
   - Tipo de aplicación: App

3. **Configuración de contenido**
   - Desarrollador: Información de contacto
   - Privacidad: URL de política de privacidad
   - Derechos de administración: Cumplimiento

4. **Cargar el bundle**
   - Ir a "Producción" o "Lanzamiento interno/cerrado"
   - Hacer clic en "Crear nueva versión"
   - Subir el archivo `app-release.aab`
   - Agregar notas de versión

5. **Configurar contenido de la tienda**
   - Descripción corta (80 caracteres)
   - Descripción larga (4000 caracteres)
   - Capturas de pantalla (mínimo 2, recomendado 8)
   - Imagen destacada (1024x500)
   - Ícono de la app (512x512)
   - Video promocional (opcional)

6. **Configuración de la app**
   - Clasificación de contenido (PEGI, ESRB)
   - Política de privacidad
   - Restricciones de contenido
   - Datos personales recopilados

7. **Precios y distribución**
   - Gratis o de pago
   - Países de distribución
   - Descripción de la app

8. **Revisar y enviar**
   - Verificar que todo esté completo
   - Enviar a revisión

## 🔐 Consideraciones de Seguridad

### ProGuard está habilitado
- ✅ `minifyEnabled true`
- ✅ `shrinkResources true`
- ✅ ProGuard rules configurados

### Permisos de usuario
La app solicita permisos para:
- ✅ Acceso a Internet
- ✅ Acceso a la cámara (image_picker)
- ✅ Acceso a almacenamiento (image_picker)
- ✅ Estado de red (connectivity_plus)

## ⚠️ Requisitos Adicionales

### 1. Política de Privacidad
Debes tener una URL pública con tu política de privacidad que mencione:
- Qué datos recopilas
- Cómo usas los datos
- Con quién compartes los datos
- Cómo los usuarios pueden solicitar eliminación de datos

### 2. Descripción de la App
```markdown
Aplicación oficial de ESVILLA E.S.P. que permite a los usuarios:
- Consultar su información personal
- Realizar PQRS (Peticiones, Quejas, Reclamos y Sugerencias)
- Ver noticias y anuncios
- Consultar horarios de recolección
- Administrar su perfil (para administradores)
```

### 3. Capturas de Pantalla Necesarias
Mínimo requerido por Google Play:
- Teléfonos: 2 capturas
- Tablets (si aplica): 2 capturas

Recomendado:
- Teléfonos: 8 capturas
- Tablets: 8 capturas (opcional)

### 4. Imágenes Requeridas
- **Ícono de alta resolución**: 512x512 px (PNG sin transparencia)
- **Imagen destacada**: 1024x500 px (JPG o PNG, 24 bit)

## 📊 Monitoreo Post-Lanzamiento

### Métricas a monitorear:
- Crashes y errores
- ANR (Application Not Responding)
- Calificaciones y reseñas
- Instalaciones y desinstalaciones
- Engagement de usuarios

### Herramientas:
- Firebase Crashlytics (recomendado agregar)
- Google Play Console analytics
- Firebase Analytics (recomendado agregar)

## 🔄 Para Próximas Versiones

Cada vez que quieras publicar una nueva versión:

1. **Incrementar version en pubspec.yaml:**
   ```yaml
   version: 1.2.1+5  # incrementa patch o minor y build number
   ```

2. **Incrementar en local.properties (si usas):**
   ```properties
   flutter.versionCode=5
   flutter.versionName=1.2.1
   ```

3. **Regenerar el bundle:**
   ```bash
   fvm flutter clean
   fvm flutter pub get
   fvm flutter build appbundle --release
   ```

4. **Subir a Google Play Console**
   - Nueva versión en el track correspondiente
   - Agregar notas de versión con cambios

## 📝 Notas Importantes

- El bundle (AAB) es **obligatorio** para nuevas apps desde agosto 2021
- No subas APKs, usa siempre bundles (AAB)
- Mantén el versionCode siempre incrementando
- El versionName puede tener formato semántico (1.2.0)
- Google Play realizará una revisión que puede tomar 1-7 días

## 🆘 Troubleshooting

### Error: "Keystore not found"
- Verifica la ruta en local.properties
- Verifica que el archivo existe

### Error: "Wrong password"
- Verifica las contraseñas en local.properties
- Verifica que el alias de la clave sea "esvilla_key"

### Error: "App bundle size too large"
- El tamaño inicial no puede exceder 150MB
- Considera usar Android App Bundle feature delivery

## 📚 Recursos Útiles

- [Google Play Console Help](https://support.google.com/googleplay/android-developer)
- [Flutter Deploy to Production](https://docs.flutter.dev/deployment/android)
- [Google Play Policy](https://play.google.com/about/developer-content-policy/)
- [App Bundle Format](https://developer.android.com/guide/app-bundle)
