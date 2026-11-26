package com.suryakaranr.label_flutter_plugin

import com.suryakaranr.labelsdk.LabelSdk
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.mockito.ArgumentMatchers.anyString
import org.mockito.ArgumentMatchers.isNull
import org.mockito.Mockito
import kotlin.test.BeforeTest
import kotlin.test.Test

/*
 * Run with `./gradlew :label_flutter_plugin:testDebugUnitTest` from `example/android/`
 * after the example app has been built once.
 */
internal class LabelFlutterPluginTest {

    private val plugin = LabelFlutterPlugin()
    private val result: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)

    @BeforeTest
    fun setUp() = LabelSdk.reset()

    @Test
    fun getLabel_beforeInitialize_returnsLicenseError() {
        plugin.onMethodCall(MethodCall("getLabel", null), result)
        Mockito.verify(result).error("LICENSE_ERROR", "not_initialized", null)
    }

    @Test
    fun isLicensed_beforeInitialize_isFalse() {
        plugin.onMethodCall(MethodCall("isLicensed", null), result)
        Mockito.verify(result).success(false)
    }

    @Test
    fun initialize_withMissingArguments_returnsInvalidArgument() {
        plugin.onMethodCall(MethodCall("initialize", mapOf("packageId" to "pkg")), result)
        Mockito.verify(result).error(Mockito.eq("INVALID_ARGUMENT"), anyString(), isNull())
    }

    @Test
    fun unknownMethod_isNotImplemented() {
        plugin.onMethodCall(MethodCall("nope", null), result)
        Mockito.verify(result).notImplemented()
    }
}
