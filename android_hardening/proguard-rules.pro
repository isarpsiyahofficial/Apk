# Release R8 rules for AndroidX classes instantiated reflectively.
-keep class * extends androidx.room.RoomDatabase {
    <init>();
}

-keep class * extends androidx.work.InputMerger {
    <init>();
}
