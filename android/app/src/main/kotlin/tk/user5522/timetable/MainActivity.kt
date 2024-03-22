package tk.user5522.timetable

import io.flutter.embedding.android.FlutterActivity
import android.os.Build
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity() {
    private val CHANNEL = "tk.user5522.timetable/androidVersion"

    fun getAndroidVersion(): Int {
        return Build.VERSION.SDK_INT
    }

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
        call, result ->
        if (call.method == "getAndroidVersion") {
            val androidVersion = getAndroidVersion()
        
            if (androidVersion != -1) {
              result.success(androidVersion)
            } else {
            //   result.error("UNAVAILABLE", 0, null)
            }
          } else {
            result.notImplemented()
          }
      }
  }

}
