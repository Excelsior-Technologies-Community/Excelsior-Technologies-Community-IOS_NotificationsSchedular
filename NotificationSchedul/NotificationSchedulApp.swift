//
//  NotificationSchedulApp.swift
//  NotificationSchedul
//
//  Created by Noman belim on 07/12/25.
//

import SwiftUI
@main
struct NotificationSchedulApp: App {
  

    init() {
        NotificationManager.shared.requestPermission()
    }

    var body: some Scene {
        WindowGroup {
            NotificationSchedulerView()
        }
    }
}
