//
//  NotificationAPI.swift
//

import Foundation
import UserNotifications

public class NotificationAPI {

    public static let shared = NotificationAPI()
    private init() {}

    // MARK: - Permission
    public func requestPermission() {
        NotificationManager.shared.requestPermission()
    }

    // MARK: - DAILY (Dynamic Date)
    public func scheduleDaily(at time: Date,
                              title: String,
                              sound: String = "dazzle.wav") {

        let item = NotificationItem(
            title: title,
            time: time,
            type: .daily,
            sound: sound,
            isEnabled: true
        )

        NotificationManager.shared.schedule(item)
    }

    // MARK: - WEEKLY (Dynamic)
    /// days = [0=Sun, 1=Mon, 2=Tue ... 6=Sat]
    public func scheduleWeekly(at time: Date,
                               days: [Int],
                               title: String,
                               sound: String = "dazzle.wav") {

        let item = NotificationItem(
            title: title,
            time: time,
            type: .weekly,
            selectedDays: days,
            sound: sound,
            isEnabled: true
        )

        NotificationManager.shared.schedule(item)
    }

    // MARK: - HOURLY (Dynamic Interval)
    /// intervalSeconds = e.g. 3600, 1800, 900, etc.
    public func scheduleRepeating(every intervalSeconds: TimeInterval,
                                  title: String,
                                  sound: String = "dazzle.wav") {

        let item = NotificationItem(
            title: title,
            time: Date(),
            type: .hourly, // <-- we treat custom interval under hourly case
            sound: sound,
            isEnabled: true
        )

        NotificationManager.shared.scheduleCustomInterval(item, interval: intervalSeconds)
    }

    // MARK: - ONE TIME
    public func scheduleOneTime(
        date: Date,
        time: Date,
        title: String,
        sound: String = "dazzle.wav"
    ) {

        let item = NotificationItem(
            title: title,
            time: time,
            type: .oneTime,
            date: date,
            sound: sound,
            isEnabled: true
        )

        NotificationManager.shared.schedule(item)
    }
}
