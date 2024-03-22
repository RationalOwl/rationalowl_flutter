import Flutter
import RationalOwl
import UIKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(_ application: UIApplication,
                              didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        GeneratedPluginRegistrant.register(with: self)

        application.registerForRemoteNotifications()
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
