# Ignoriere Warnungen für Annotationen und externe Helfer
-dontwarn com.google.errorprone.annotations.**
-dontwarn javax.annotation.**
-dontwarn com.google.api.client.**
-dontwarn org.joda.time.**

# Schütze Tink-Bibliothek vor zu starker Optimierung
-keep class com.google.crypto.tink.** { *; }
-keep class com.google.crypto.tink.proto.** { *; }

# Falls Google HTTP Client Klassen vom R8 entfernt werden, sichere die Kernklassen
-keep class com.google.api.client.** { *; }
-keep class com.google.http.client.** { *; }

# Behalte Joda-Time-Klassen falls sie zur Laufzeit gebraucht werden
-keep class org.joda.time.** { *; }

