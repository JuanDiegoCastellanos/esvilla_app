# Notas de Versión - ESVILLA E.S.P. v1.2.0

## Español (Colombia) - es-419

**Nuevas características:**
• Autocompletado de direcciones con búsqueda en tiempo real
• Filtro mejorado de noticias por rango de fechas con botón para limpiar
• Mejor persistencia de sesión y actualización automática de tokens

**Correcciones:**
• Manejo correcto de anuncios sin imágenes
• Filtro de fechas más preciso
• Mensajes de error más claros y amigables
• Mejoras en el perfil de usuario

**Optimizaciones:**
• Mejor rendimiento de la aplicación
• Gestión de estado mejorada

---

## Configuración de Optimización

Tu app ya está configurada con:
- ✅ `minifyEnabled true` - Optimización de código
- ✅ `shrinkResources true` - Reducción de recursos
- ✅ `android.r8.optimizedResourceShrinking=true` - Shrinking optimizado de recursos
- ✅ ProGuard rules configuradas

### Para subir el archivo de mapping (símbolos de depuración):

Después de generar el AAB, sube también el archivo de mapping que se genera en:
```
build/app/outputs/mapping/release/mapping.txt
```

Este archivo ayuda a Google Play a analizar errores ANR y crashes de forma más precisa.
