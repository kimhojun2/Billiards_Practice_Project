## Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
# 토큰 저장이 안되서 추가
-keep class androidx.security.crypto.** { *; }
# 밑에 2개는 이미지 안오는게 있어서 추가
-keep class com.bumptech.glide.** { *; }
-keep class com.yourpackage.** { *; }
-dontwarn io.flutter.embedding.**