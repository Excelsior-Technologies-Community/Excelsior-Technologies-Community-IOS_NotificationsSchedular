
#   **iOS Local Notification Scheduler (Swift Package Manager)**

A lightweight Swift package that gives you a **super simple API** to schedule:

* One-Time Notifications
* Daily Notifications
* Weekly Notifications
* Repeating Interval Notifications
* Custom Sound Notifications

No built-in UI required — developers can use **their own SwiftUI or UIKit interface** and call your API.

---

#   **Features**

✔ Easy for beginners
✔ Works with **any UI**
✔ Fully dynamic (custom date, time, sound, title)
✔ Daily reminders
✔ Weekly reminders
✔ One-time reminders
✔ Repeating reminders (every X minutes/hours)
✔ Custom sound support
✔ iOS 15+
✔ Clean & simple API

---

#   **Installation (Swift Package Manager)**

### Step 1 — Open Xcode

Go to:

```
File → Add Packages…
```

### Step 2 — Enter the repository URL:

```
https://github.com/Excelsior-Technologies-Community/IOS_NotificationsSchedular
```

### Step 3 — Choose:

```
Branch → main
```

Click **Add Package**.

### Step 4 — Import it in your code:

```swift
import NotificationSchedul
```

That’s it!  

---

#   **1. Request Notification Permission**

Every app must ask the user once.

Add this inside your first screen:

```swift
NotificationAPI.shared.requestPermission()
```

You can place it inside `.onAppear {}` or in `App.swift`.

---

#   **Understanding the Simple API**

Your package exposes **four** scheduling functions:

1️⃣ **Daily**
2️⃣ **Weekly**
3️⃣ **One-Time**
4️⃣ **Repeating (Interval)**

Each accepts:

* A `Date` (time)
* A custom title
* An optional custom sound
* An array of days (for weekly reminders)

---

#   **2. Schedule a Daily Notification**

Daily notifications fire at **the same time every day**.

### Code Example:

```swift
NotificationAPI.shared.scheduleDaily(
    at: selectedTime, 
    title: "Drink Water"
)
```

### How developers pass the time?

From a SwiftUI DatePicker:

```swift
DatePicker("Select Time",
           selection: $selectedTime,
           displayedComponents: .hourAndMinute)
```

---

#   **3. Schedule a Weekly Notification**

To schedule on multiple days:

| Number | Day       |
| ------ | --------- |
| 0      | Sunday    |
| 1      | Monday    |
| 2      | Tuesday   |
| 3      | Wednesday |
| 4      | Thursday  |
| 5      | Friday    |
| 6      | Saturday  |

### Example: Every Monday, Wednesday, Friday

```swift
NotificationAPI.shared.scheduleWeekly(
    at: selectedTime,
    days: [1, 3, 5],
    title: "Gym Time"
)
```

### Explanation for Beginners:

* `[1,3,5]` means:

  * **1 → Monday**
  * **3 → Wednesday**
  * **5 → Friday**

Developers can let users select days using buttons or toggles.

---

#   **4. Schedule a One-Time Notification**

Use this when you want a notification on **specific date + specific time**.

### Example:

```swift
NotificationAPI.shared.scheduleOneTime(
    date: selectedDate,
    time: selectedTime,
    title: "Doctor Appointment"
)
```

Example UI for selecting date:

```swift
DatePicker("Select Date",
           selection: $selectedDate,
           displayedComponents: .date)
```

---

#   **5. Schedule a Repeating Notification (Interval)**

This lets you fire a notification **every X seconds**.

### Example: Every 30 minutes

```swift
NotificationAPI.shared.scheduleRepeating(
    every: 1800,
    title: "Take a Break"
)
```

### Example: Every 1 hour

```swift
NotificationAPI.shared.scheduleRepeating(
    every: 3600,
    title: "Hourly Reminder"
)
```

---

#   **6. FULL Example: How Developers Use It in Their App**

Copy & paste this into your `ContentView.swift`:

```swift
import SwiftUI
import NotificationSchedul

struct ContentView: View {

    @State private var reminderTitle = ""
    @State private var selectedTime = Date()
    @State private var selectedDate = Date()
    @State private var selectedWeeklyDays: Set<Int> = []

    let weekDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // TITLE
                TextField("Enter Reminder Title", text: $reminderTitle)
                    .padding()
                    .background(.gray.opacity(0.2))
                    .cornerRadius(10)

                // TIME PICKER
                DatePicker("Select Time",
                           selection: $selectedTime,
                           displayedComponents: .hourAndMinute)

                // DAILY
                Button("Set Daily Reminder") {
                    NotificationAPI.shared.scheduleDaily(
                        at: selectedTime,
                        title: reminderTitle
                    )
                }

                Divider()

                // WEEKLY DAY SELECTION
                Text("Select Weekly Days")
                HStack {
                    ForEach(0..<7) { index in
                        Button {
                            if selectedWeeklyDays.contains(index) {
                                selectedWeeklyDays.remove(index)
                            } else {
                                selectedWeeklyDays.insert(index)
                            }
                        } label: {
                            Text(weekDays[index])
                                .frame(width: 45, height: 45)
                                .background(selectedWeeklyDays.contains(index)
                                            ? Color.blue
                                            : Color.gray.opacity(0.3))
                                .cornerRadius(8)
                                .foregroundColor(.white)
                        }
                    }
                }

                // WEEKLY
                Button("Set Weekly Reminder") {
                    NotificationAPI.shared.scheduleWeekly(
                        at: selectedTime,
                        days: Array(selectedWeeklyDays),
                        title: reminderTitle
                    )
                }

                Divider()

                // ONE TIME
                DatePicker("Select Date",
                           selection: $selectedDate,
                           displayedComponents: .date)

                Button("Set One-Time Reminder") {
                    NotificationAPI.shared.scheduleOneTime(
                        date: selectedDate,
                        time: selectedTime,
                        title: reminderTitle
                    )
                }

                Divider()

                // REPEATING
                Button("Repeat Every 30 Minutes") {
                    NotificationAPI.shared.scheduleRepeating(
                        every: 1800,
                        title: reminderTitle
                    )
                }
            }
            .padding()
        }
        .onAppear {
            NotificationAPI.shared.requestPermission()
        }
    }
}

#Preview {
    ContentView()
}
```

---

#   **Custom Sounds**

Developers can include any `.wav` file in their project:

```
clownhornsounds.wav
dazzle.wav
failurepiano.wav
whistle.wav
voicelaugh.wav
```

Make sure they are added to:

```
Xcode → Target → Build Phases → Copy Bundle Resources
```

Then pass the sound:

```swift
NotificationAPI.shared.scheduleDaily(
    at: time,
    title: "Water Reminder",
    sound: "dazzle.wav"
)
```

---
 