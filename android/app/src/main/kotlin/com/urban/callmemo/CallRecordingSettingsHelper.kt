package com.urban.callmemo

import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.telecom.TelecomManager

/**
 * Best-effort open of OEM dialer / call-recording settings.
 * There is no universal Android Intent for "auto call recording".
 */
object CallRecordingSettingsHelper {

    fun openAutoRecordSettings(context: Context, brandHint: String?): Map<String, Any?> {
        val brand = (brandHint ?: Build.BRAND).lowercase()
        val tried = mutableListOf<String>()

        for (intent in buildCandidates(context, brand)) {
            val label = describe(intent)
            tried.add(label)
            if (tryStart(context, intent)) {
                return mapOf(
                    "opened" to true,
                    "target" to label,
                    "brand" to brand,
                    "tried" to tried,
                )
            }
        }

        return mapOf(
            "opened" to false,
            "target" to null,
            "brand" to brand,
            "tried" to tried,
        )
    }

    fun openPhoneApp(context: Context): Map<String, Any?> {
        val dialer = defaultDialerPackage(context)
        if (dialer != null) {
            val launch = context.packageManager.getLaunchIntentForPackage(dialer)
            if (launch != null && tryStart(context, launch)) {
                return mapOf("opened" to true, "target" to dialer)
            }
        }

        val dial = Intent(Intent.ACTION_DIAL).apply {
            data = Uri.parse("tel:")
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        if (tryStart(context, dial)) {
            return mapOf("opened" to true, "target" to "ACTION_DIAL")
        }

        return mapOf("opened" to false, "target" to null)
    }

    private fun buildCandidates(context: Context, brand: String): List<Intent> {
        val list = mutableListOf<Intent>()

        when {
            brand.contains("samsung") -> {
                list += components(
                    "com.samsung.android.dialer" to
                        "com.samsung.android.dialer.callsettings.CallSettingsActivity",
                    "com.samsung.android.app.telephonyui" to
                        "com.samsung.android.app.telephonyui.activity.CallSettingsActivity",
                    "com.samsung.android.app.telephonyui" to
                        "com.samsung.android.app.telephonyui.setting.callsettings.CallSettingsActivity",
                    "com.android.phone" to "com.android.phone.CallFeaturesSetting",
                    "com.android.phone" to "com.android.phone.settings.PhoneAccountSettingsActivity",
                )
                list += packageLaunches(
                    context,
                    "com.samsung.android.dialer",
                    "com.samsung.android.app.telephonyui",
                )
            }

            brand.contains("xiaomi") ||
                brand.contains("redmi") ||
                brand.contains("poco") ||
                brand.contains("blackshark") -> {
                list += components(
                    "com.android.phone" to "com.android.phone.CallFeaturesSetting",
                    "com.android.phone" to "com.android.phone.settings.PhoneSettingsActivity",
                    "com.miui.securitycenter" to
                        "com.miui.permcenter.permissions.AppPermissionsEditorActivity",
                )
                list += googleDialerRecordingIntents()
                list += packageLaunches(
                    context,
                    "com.android.phone",
                    "com.android.contacts",
                    "com.google.android.dialer",
                )
            }

            brand.contains("oppo") ||
                brand.contains("realme") ||
                brand.contains("oneplus") ||
                brand.contains("oplus") -> {
                list += components(
                    "com.android.phone" to "com.android.phone.CallFeaturesSetting",
                    "com.oplus.odialer" to "com.oplus.odialer.DialtactsActivity",
                    "com.heytap.speechassist" to "com.heytap.speechassist.MainActivity",
                )
                list += googleDialerRecordingIntents()
                list += packageLaunches(
                    context,
                    "com.oplus.odialer",
                    "com.android.phone",
                    "com.google.android.dialer",
                    "com.coloros.phonemanager",
                )
            }

            brand.contains("vivo") || brand.contains("iqoo") -> {
                list += components(
                    "com.android.phone" to "com.android.phone.CallFeaturesSetting",
                    "com.android.incallui" to "com.android.incallui.InCallActivity",
                )
                list += packageLaunches(
                    context,
                    "com.android.phone",
                    "com.android.contacts",
                    "com.google.android.dialer",
                )
            }

            brand.contains("tecno") ||
                brand.contains("infinix") ||
                brand.contains("itel") ||
                brand.contains("transsion") -> {
                list += components(
                    "com.android.phone" to "com.android.phone.CallFeaturesSetting",
                    "com.android.phone" to "com.android.phone.settings.PhoneSettingsActivity",
                )
                list += packageLaunches(
                    context,
                    "com.android.phone",
                    "com.android.contacts",
                    "com.google.android.dialer",
                )
            }

            brand.contains("huawei") || brand.contains("honor") -> {
                list += components(
                    "com.android.phone" to "com.android.phone.CallFeaturesSetting",
                    "com.huawei.contacts" to "com.android.contacts.activities.DialtactsActivity",
                    "com.hihonor.contacts" to "com.android.contacts.activities.DialtactsActivity",
                )
                list += packageLaunches(
                    context,
                    "com.android.phone",
                    "com.huawei.contacts",
                    "com.hihonor.contacts",
                    "com.google.android.dialer",
                )
            }

            brand.contains("motorola") || brand.contains("lenovo") -> {
                list += googleDialerRecordingIntents()
                list += components(
                    "com.android.phone" to "com.android.phone.CallFeaturesSetting",
                )
                list += packageLaunches(
                    context,
                    "com.google.android.dialer",
                    "com.android.phone",
                )
            }

            brand.contains("google") || brand.contains("pixel") -> {
                list += googleDialerRecordingIntents()
                list += packageLaunches(context, "com.google.android.dialer")
            }

            brand.contains("nothing") -> {
                list += googleDialerRecordingIntents()
                list += packageLaunches(
                    context,
                    "com.google.android.dialer",
                    "com.nothing.dialer",
                )
            }

            brand.contains("sony") -> {
                list += googleDialerRecordingIntents()
                list += packageLaunches(
                    context,
                    "com.sonyericsson.android.socialphonebook",
                    "com.google.android.dialer",
                    "com.android.phone",
                )
            }

            brand.contains("asus") || brand.contains("rog") -> {
                list += components(
                    "com.android.phone" to "com.android.phone.CallFeaturesSetting",
                )
                list += googleDialerRecordingIntents()
                list += packageLaunches(
                    context,
                    "com.asus.mobilemanager",
                    "com.google.android.dialer",
                    "com.android.phone",
                )
            }

            brand.contains("nokia") || brand.contains("hmd") -> {
                list += googleDialerRecordingIntents()
                list += packageLaunches(
                    context,
                    "com.google.android.dialer",
                    "com.android.phone",
                )
            }

            else -> {
                list += googleDialerRecordingIntents()
                list += components(
                    "com.android.phone" to "com.android.phone.CallFeaturesSetting",
                )
            }
        }

        // Universal: default dialer + dial action.
        defaultDialerPackage(context)?.let { pkg ->
            list += packageLaunches(context, pkg)
        }
        list += Intent(Intent.ACTION_DIAL).apply {
            data = Uri.parse("tel:")
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }

        return list
    }

    private fun googleDialerRecordingIntents(): List<Intent> = listOf(
        Intent("com.google.android.dialer.CALL_SETTINGS").apply {
            setPackage("com.google.android.dialer")
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        },
        component(
            "com.google.android.dialer",
            "com.android.dialer.app.settings.DialerSettingsActivity",
        ),
        component(
            "com.google.android.dialer",
            "com.android.dialer.main.impl.MainActivity",
        ),
    )

    private fun components(vararg pairs: Pair<String, String>): List<Intent> =
        pairs.map { (pkg, cls) -> component(pkg, cls) }

    private fun component(pkg: String, cls: String): Intent =
        Intent().apply {
            component = ComponentName(pkg, cls)
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }

    private fun packageLaunches(context: Context, vararg packages: String): List<Intent> {
        val pm = context.packageManager
        return packages.mapNotNull { pkg ->
            pm.getLaunchIntentForPackage(pkg)?.apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
        }
    }

    private fun defaultDialerPackage(context: Context): String? {
        return try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                val telecom = context.getSystemService(Context.TELECOM_SERVICE) as? TelecomManager
                telecom?.defaultDialerPackage
            } else {
                null
            }
        } catch (_: Exception) {
            null
        }
    }

    private fun tryStart(context: Context, intent: Intent): Boolean {
        return try {
            val pm = context.packageManager
            val resolve = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                pm.resolveActivity(
                    intent,
                    PackageManager.ResolveInfoFlags.of(PackageManager.MATCH_DEFAULT_ONLY.toLong()),
                )
            } else {
                @Suppress("DEPRECATION")
                pm.resolveActivity(intent, PackageManager.MATCH_DEFAULT_ONLY)
            }
            if (resolve == null) return false
            context.startActivity(intent)
            true
        } catch (_: Exception) {
            false
        }
    }

    private fun describe(intent: Intent): String {
        val cn = intent.component
        if (cn != null) return "${cn.packageName}/${cn.className}"
        if (intent.`package` != null) return "${intent.`package`}:${intent.action}"
        return intent.action ?: "unknown"
    }
}
