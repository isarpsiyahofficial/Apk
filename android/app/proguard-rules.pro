# R8 full-mode compatibility for AndroidX classes instantiated reflectively.
# Flutter's Gradle plugin automatically includes this file in minified release builds.
-keep class * extends androidx.room.RoomDatabase {
    <init>();
}

-keep class * extends androidx.work.InputMerger {
    <init>();
}
