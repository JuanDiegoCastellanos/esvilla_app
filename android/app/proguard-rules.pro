# Mantener clases usadas por Deferred Components
-keep class com.google.android.play.core.tasks.OnSuccessListener { *; }
-keep class com.google.android.play.core.tasks.OnFailureListener { *; }
-keep class com.google.android.play.core.tasks.Task { *; }

-keep class com.google.android.play.core.tasks.** { *; }

# Regla adicional para callbacks
-keepclassmembers class * implements com.google.android.play.core.tasks.OnSuccessListener {
    public void onSuccess(java.lang.Object);
}
-keepclassmembers class * implements com.google.android.play.core.tasks.OnFailureListener {
    public void onFailure(java.lang.Exception);
}


# Flutter específico
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.embedding.engine.deferredcomponents.** { *; }

# Para Google Play Core
-keep class com.google.android.play.core.** { *; }
-keep class com.google.android.play.core.splitcompat.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }

# Para javax.lang.model
-dontwarn javax.lang.model.element.**
-keep class javax.lang.model.element.** { *; }

# Mantener anotaciones importantes
-keep class * extends java.lang.annotation.Annotation { *; }
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes SourceFile,LineNumberTable
-keepattributes Exceptions

# Para Http
-keepattributes EnclosingMethod
-keepattributes InnerClasses
-dontwarn org.codehaus.mojo.animal_sniffer.*
-dontwarn okhttp3.**
-dontwarn okio.**
-dontwarn javax.annotation.**
-dontwarn org.conscrypt.**

# Para Flutter Secure Storage
-keep class com.it_nomads.fluttersecurestorage.** { *; }

# Para image_picker
-keep class androidx.core.app.CoreComponentFactory { *; }
-keep class io.flutter.plugins.imagepicker.** { *; }

# Para connectivity_plus
-keep class dev.fluttercommunity.plus.connectivity.** { *; }

# Para url_launcher
-keep class io.flutter.plugins.urllauncher.** { *; }

# Para Gson que tal vez utilices indirectamente
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn sun.misc.**
-keep class com.google.gson.** { *; }

# Mantener models de tu app
-keep class com.example.esvilla_app.models.** { *; }

# Keep Serializable objects
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    !static !transient <fields>;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Para Dio
-keep class io.flutter.plugins.connectivity.** { *; }

#lineas desde el missing
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task
