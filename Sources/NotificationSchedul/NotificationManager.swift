//
//  NotificationManager.swift
//

import SwiftUI
import Foundation
import UserNotifications

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

    // MARK: - Permission
    public func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {
            granted, error in
            print("Notification permission: \(granted)")
        }
    }

    // MARK: - Schedule
    public func schedule(_ item: NotificationItem) {

        delete(item.id)

        let content = UNMutableNotificationContent()
        content.title = item.title
        content.sound = UNNotificationSound(named: UNNotificationSoundName(item.sound))

        let trigger: UNNotificationTrigger

        switch item.type {

        case .oneTime:
            guard let date = item.date else { return }

            var components = Calendar.current.dateComponents(
                [.year, .month, .day],
                from: date
            )
            let t = Calendar.current.dateComponents([.hour, .minute], from: item.time)

            components.hour = t.hour
            components.minute = t.minute

            trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        case .daily:
            var components = Calendar.current.dateComponents([.hour, .minute], from: item.time)
            trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

        case .weekly:
            guard let days = item.selectedDays else { return }
            for day in days {

                var components = DateComponents()
                components.weekday = day + 1
                components.hour = Calendar.current.component(.hour, from: item.time)
                components.minute = Calendar.current.component(.minute, from: item.time)

                let newTrigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

                let request = UNNotificationRequest(
                    identifier: "\(item.id)_\(day)",
                    content: content,
                    trigger: newTrigger
                )

                UNUserNotificationCenter.current().add(request)
            }
            return

        case .hourly:
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3600, repeats: true)
        }

        let request = UNNotificationRequest(identifier: item.id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

    public func delete(_ id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [id])
    }

    public func deleteAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    public func scheduleCustomInterval(_ item: NotificationItem, interval: TimeInterval) {

        delete(item.id)

        let content = UNMutableNotificationContent()
        content.title = item.title
        content.sound = UNNotificationSound(named: UNNotificationSoundName(item.sound))

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: true)

        let request = UNNotificationRequest(
            identifier: item.id,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }

} 
