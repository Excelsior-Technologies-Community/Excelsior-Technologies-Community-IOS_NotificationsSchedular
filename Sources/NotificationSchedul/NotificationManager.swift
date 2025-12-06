//
//  NotificationManager.swift
//  NotificationSchedul
//
//  Created by Noman belim on 07/12/25.
//

import SwiftUI
import Foundation
import UserNotifications
import SwiftUI

public class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {

    public static let shared = NotificationManager()

    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
   public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        completionHandler([.banner, .sound, .list])
    }


    // MARK: - Request Permission
    public func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            print("Permission granted: \(granted)")
            if let error = error { print("Error: \(error.localizedDescription)") }
        }
    }

    // MARK: - Schedule Notification
   public  func schedule(_ item: NotificationItem) {
        delete(item.id) // remove old one if exists

        let content = UNMutableNotificationContent()
        content.title = item.title
        content.sound = UNNotificationSound(named: UNNotificationSoundName(item.sound))

        let trigger: UNNotificationTrigger

        switch item.type {

        // ---------------------------------------
        // MARK: ONE-TIME NOTIFICATION
        // ---------------------------------------
        case .oneTime:
            guard let date = item.date else { return }
            var components = Calendar.current.dateComponents([.year, .month, .day], from: date)
            let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: item.time)

            components.hour = timeComponents.hour
            components.minute = timeComponents.minute

            trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        // ---------------------------------------
        // MARK: DAILY NOTIFICATION
        // ---------------------------------------
        case .daily:
            var components = Calendar.current.dateComponents([.hour, .minute], from: item.time)
            trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

        // ---------------------------------------
        // MARK: WEEKLY NOTIFICATION
        // ---------------------------------------
        case .weekly:
            guard let days = item.selectedDays else { return }

            for day in days {
                var components = DateComponents()
                components.weekday = day + 1
                components.hour = Calendar.current.component(.hour, from: item.time)
                components.minute = Calendar.current.component(.minute, from: item.time)

                let newTrigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

                let req = UNNotificationRequest(
                    identifier: "\(item.id)_\(day)",
                    content: content,
                    trigger: newTrigger
                )

                UNUserNotificationCenter.current().add(req)
            }
            return

        // ---------------------------------------
        // MARK: HOURLY NOTIFICATION
        // ---------------------------------------
        case .hourly:
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3600, repeats: true)
        }

        let request = UNNotificationRequest(
            identifier: item.id,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
        print("SCHEDULED → \(item.title)")
    }

    // MARK: Delete Notification
   public  func delete(_ id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [id])
    }

    // MARK: Delete all
    func deleteAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}
 
