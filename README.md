 
```markdown
# 📣 iOS Local Notification Scheduler (SwiftUI + Swift Package Manager)

A lightweight, reusable **Local Push Notification Scheduler** for iOS written in Swift.  
This package allows any iOS developer to easily schedule:

- 🕒 One-Time Notifications  
- 🔁 Daily Notifications  
- 📅 Weekly Notifications  
- ⏰ Hourly Notifications  
- 🔊 Custom Sound Notifications  

Built completely in SwiftUI with a clean & reusable API.

---

# 🚀 Features

✔ Schedule one-time reminders  
✔ Schedule repeating daily notifications  
✔ Set notifications for specific weekdays  
✔ Hourly repeating notifications  
✔ Custom notification sounds (`.wav`, `.caf`, `.aiff`)  
✔ Easy integration using Swift Package Manager  
✔ Includes a ready-to-use SwiftUI UI component  
✔ iOS 15+ support  

---

# 📦 Installation (Swift Package Manager)

### Step 1 — Open Xcode  
Go to:

```

File → Add Packages…

```

### Step 2 — Enter the repository URL:

```

[https://github.com/Excelsior-Technologies-Community/Excelsior-Technologies-Community-IOS_NotificationsSchedular](https://github.com/Excelsior-Technologies-Community/Excelsior-Technologies-Community-IOS_NotificationsSchedular)

```

### Step 3 — Select Dependency Rule
Use:

```

Branch → main

````

Then click **Add Package**.

### Step 4 — Import in your code:

```swift
import NotificationSchedul
````

Package is ready to use.

---

# 🧩 Usage Guide

The package exposes two main components:

## 1️⃣ **LocalNotificationScheduler**

Core engine for scheduling notifications.

## 2️⃣ **NotificationSchedulerView**

A ready-made SwiftUI UI for testing/previewing notifications.

---

# 🟦 Request Permission

Add this in your App file (`AppNameApp.swift`):

```swift
import NotificationSchedulerKit

@main
struct YourApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    LocalNotificationScheduler.shared.requestPermission { granted in
                        print("Permission:", granted)
                    }
                }
        }
    }
}
```
# 🧪 Using the Built-In SwiftUI Testing View

Your package includes a complete testing UI.

Just use:

```swift
import NotificationSchedulerKit

struct ContentView: View {
    var body: some View {
        NotificationSchedulerView()
    }
}
```
-> Explanation how this works 
---

# 🕒 1. Schedule One-Time Notification

```swift
LocalNotificationScheduler.shared.scheduleOnce(
    id: UUID().uuidString,
    at: Date().addingTimeInterval(10), // fires after 10 seconds
    title: "Reminder",
    body: "This is a one-time notification",
    soundName: "whistle.wav"
)
```

---

# 🔁 2. Schedule Daily Notification

```swift
LocalNotificationScheduler.shared.scheduleDaily(
    id: UUID().uuidString,
    at: someTimePickerValue,
    title: "Daily Alert",
    body: "This fires daily at the selected time",
    soundName: "dazzle.wav"
)
```

---

# 📅 3. Schedule Weekly Notification

```swift
LocalNotificationScheduler.shared.scheduleWeekly(
    id: UUID().uuidString,
    weekday: 2, // Monday
    at: someTimePickerValue,
    title: "Weekly Meeting",
    body: "Reminder for your weekly task",
    soundName: "voicelaugh.wav"
)
```

---

# ⏰ 4. Schedule Hourly Notification

```swift
LocalNotificationScheduler.shared.scheduleHourly(
    id: UUID().uuidString,
    at: 30, // at minute 30 every hour
    title: "Hourly Update",
    body: "This runs every hour",
    soundName: "failurepiano.wav"
)
```

---

# 🗑 Cancel Notification

```swift
LocalNotificationScheduler.shared.cancel(id)
```

---

# 🧹 Cancel All Notifications

```swift
LocalNotificationScheduler.shared.clearAll()
```

---



This allows developers to test notifications without writing extra code.

---

# 🔊 Adding Custom Sounds

Your sound files **must** follow:

* Format: `.wav`, `.aiff`, or `.caf`
* Length < 30 seconds
* Added to app target

Example folder structure:

```
Assets/
Sounds/
   - whistle.wav
   - dazzle.wav
   - clownhornsounds.wav
```

Make sure each sound file is inside:

```
Target → Build Phases → Copy Bundle Resources
```

---
 
