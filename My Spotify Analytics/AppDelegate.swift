import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate  {
    
    var window: UIWindow?
    //lazy var sessionOpener = SessionOpener()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        SessionOpener.shared.sessionManager.application(app, open: url, options: options)
        return true
    }
  
    func applicationWillResignActive(_ application: UIApplication) {
        if (RemotePlayer.shared.appRemote.isConnected) {
            RemotePlayer.shared.appRemote.disconnect()
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        if let _ = RemotePlayer.shared.appRemote.connectionParameters.accessToken {
            RemotePlayer.shared.appRemote.connect()
        }
    }
    
    
    

    
    
    
    
}

