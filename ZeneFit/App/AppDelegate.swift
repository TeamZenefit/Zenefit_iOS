//
//  AppDelegate.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/09/26.
//

import UIKit
import KakaoSDKCommon
import FirebaseCore
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard let appKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_APP_KEY") as? String else { return true }
        KakaoSDK.initSDK(appKey: appKey)
        FirebaseApp.configure()
        
        self.registerForPushNotifications()
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        
        didReceiveInBackgroundMode(launchOptions: launchOptions)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    //MARK: - RemotePushNotification
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                print("Permission granted: \(granted)")
                self.getNotificationSettings()
            }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("디바이스 토큰 정상 발급 완료")
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register(deviceToken): \(error)")
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // 포그라운드에서 받았을 때
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // 로그인 여부
        guard let _ = KeychainManager.read(ZFKeyType.accessToken.rawValue) else {
            return
        }
        
        let content = notification.request.content
        print("title: \(content.title)")
        print("body: \(content.body)")
        print(content.userInfo)

        completionHandler([.badge , .banner, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        guard let _ = KeychainManager.read(ZFKeyType.accessToken.rawValue) else {
            return
        }
        
        let content = response.notification.request.content
        
        print("title: \(content.title)")
        print("body: \(content.body)")
        print("userInfo: \(content.userInfo)")
        
        if let policyIdString = content.userInfo["policyId"] as? String,
           let policyId = Int(policyIdString) {
            Task {
                SceneDelegate.mainCoordinator?.tabBarCoorinator?.setAction(.welfareDetail(welfareId: policyId))
            }
        }
        
        
        completionHandler()
    }
    
    func didReceiveInBackgroundMode(launchOptions: [UIApplication.LaunchOptionsKey : Any]?) {
        guard let _ = KeychainManager.read(ZFKeyType.accessToken.rawValue) else {
            return
        }
        
        guard let userInfo = launchOptions?[.remoteNotification] as? [AnyHashable: Any] else {
            return
        }
        
        if let policyIdString = userInfo["policyId"] as? String,
           let policyId = Int(policyIdString) {
            SceneDelegate.mainCoordinator?.setAction(.tabBar)
            SceneDelegate.mainCoordinator?.tabBarCoorinator?.setAction(.welfareDetail(welfareId: policyId))
        }
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken else { return }
        print("fcmToken 정상 발급 : \(fcmToken)")
        UserDefaults.standard.set(fcmToken, forKey: ZFKeyType.fcmToken.rawValue)
    }
}
