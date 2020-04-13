package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import com.davidmartos96.sqflite_sqlcipher.SqfliteSqlCipherPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    SqfliteSqlCipherPlugin.registerWith(registry.registrarFor("com.davidmartos96.sqflite_sqlcipher.SqfliteSqlCipherPlugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}
