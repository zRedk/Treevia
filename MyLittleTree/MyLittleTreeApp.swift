//
//  MyLittleTreeApp.swift
//  MyLittleTree
//
//  Created by Emanuele Di Pietro on 17/10/23.
//

import SwiftUI
import UserNotifications
import BackgroundTasks

@main
struct YourApp: App {
    @Environment(\.scenePhase) private var phase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    

    /*init() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "yourApp.backgroundTask", using: nil) { [weak timerViewModel] task in
            guard let timerViewModel = timerViewModel else {
                task.setTaskCompleted(success: false)
                return
            }
            timerViewModel.startTimer()
            task.setTaskCompleted(success: true)
        }
    }*/
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    private func applicationDidFinishLaunching(_ notification: Notification) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
        UNUserNotificationCenter.current().delegate = self
    }
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Update your timer and schedule notifications here.
        completionHandler(.newData)
    }

}
