import UIKit
import Flutter
import ChatSDK
import ChatProvidersSDK
import MessagingSDK

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let batteryChannel = FlutterMethodChannel(name: "com.cakewallet.cakewallet/legacy_wallet_migration",
                                                  binaryMessenger: controller.binaryMessenger)
        let liveChatChannel = FlutterMethodChannel(name: "com.cakewallet.cake_wallet/live-chat", binaryMessenger: controller.binaryMessenger)
        
        batteryChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            
            switch call.method {
            case "decrypt":
                guard let args = call.arguments as? Dictionary<String, Any>,
                      let data = args["bytes"] as? FlutterStandardTypedData,
                      let key = args["key"] as? String,
                      let salt = args["salt"] as? String else {
                    result(nil)
                    return
                }
                
                let content = decrypt(data: data.data, key: key, salt: salt)
                result(content)
            case "read_user_defaults":
                guard let args = call.arguments as? Dictionary<String, Any>,
                      let key = args["key"] as? String,
                      let type = args["type"] as? String else {
                    result(nil)
                    return
                }
                
                var value: Any?
                
                switch (type) {
                case "string":
                    value = UserDefaults.standard.string(forKey: key)
                case "int":
                    value = UserDefaults.standard.integer(forKey: key)
                case "bool":
                    value = UserDefaults.standard.bool(forKey: key)
                default:
                    break
                }
                
                result(value)
            default:
                result(FlutterMethodNotImplemented)
            }
        })
        
        liveChatChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            
            switch call.method {
            case "startLiveChat":
                do {
                    try self.startChat()
                } catch {
                    result(nil)
                }
                result(nil)
            default:
                result(FlutterMethodNotImplemented)
            }
        })
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func startChat() throws {
        Chat.initialize(accountKey: "Account key", appId: "com.cakewallet.cake_wallet")
        
        let messagingConfiguration = MessagingConfiguration()
        messagingConfiguration.name = "Cake Wallet Bot"

        let chatConfiguration = ChatConfiguration()
        
        let chatAPIConfiguration = ChatAPIConfiguration()
        chatAPIConfiguration.department = "Cake Wallet"
        chatAPIConfiguration.visitorInfo = VisitorInfo()
        Chat.instance?.configuration = chatAPIConfiguration

        let chatEngine = try ChatEngine.engine()
        let viewController = try Messaging.instance.buildUI(engines: [chatEngine], configs: [messagingConfiguration, chatConfiguration])

        let controller = self.window?.rootViewController
        controller?.navigationController?.pushViewController(viewController, animated: true)
    }
}
