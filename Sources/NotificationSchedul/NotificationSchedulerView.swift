import SwiftUI

// MARK: - Main View

struct NotificationSchedulerView: View {
    @State private var selectedTab = 0
    @State private var showAddSheet = false
    @State private var editingNotification: NotificationItem?
    @State private var notifications: [NotificationItem] = []
    @State private var showPastEnableAlert = false
    @State private var editingForFutureCorrection: NotificationItem?
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background Gradient
                LinearGradient(
                    colors: [Color(hex: "E0E7FF"), Color(hex: "F3E8FF"), Color(hex: "FCE7F3")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    headerView
                    
                    // Tabs
                    tabPickerView
                    
                    // List
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(filteredNotifications) { notification in
                                NotificationCard(
                                    notification: notification,
                                    onToggle: { toggleNotification(notification.id) },
                                    onDelete: { deleteNotification(notification.id) },
                                    onEdit: { editingNotification = notification },
                                    onAskForFutureTime: {
                                        editingForFutureCorrection = notification
                                        showPastEnableAlert = true
                                    }
                                )
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showAddSheet) {
                AddNotificationSheet(editingNotification: nil) { newItem in
                    addOrUpdateNotification(newItem)
                }
            }
            .sheet(item: $editingNotification) { item in
                AddNotificationSheet(editingNotification: item) { updated in
                    addOrUpdateNotification(updated)
                }
            }
            .alert("Notification in Past", isPresented: $showPastEnableAlert) {
                Button("Edit Time") {
                    if let item = editingForFutureCorrection {
                        editingNotification = item
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This notification already fired in the past. Please choose a new future time to enable it again.")
            }
        }
    }
    
    // MARK: - Header
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Notifications")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("\(notifications.filter { $0.isEnabled }.count) active reminders")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: { showAddSheet = true }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "6366F1"), Color(hex: "8B5CF6")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 60)
        .padding(.bottom, 20)
    }
    
    // MARK: - Tabs
    
    private var tabPickerView: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                TabButton(title: "One Time", icon: "bell.fill", isSelected: selectedTab == 0) {
                    withAnimation(.spring(response: 0.3)) {
                        selectedTab = 0
                    }
                }
                
                TabButton(title: "Daily", icon: "sun.max.fill", isSelected: selectedTab == 1) {
                    withAnimation(.spring(response: 0.3)) {
                        selectedTab = 1
                    }
                }
            }
            
            HStack(spacing: 12) {
                TabButton(title: "Weekly", icon: "calendar", isSelected: selectedTab == 2) {
                    withAnimation(.spring(response: 0.3)) {
                        selectedTab = 2
                    }
                }
                
                TabButton(title: "Hourly", icon: "clock.arrow.circlepath", isSelected: selectedTab == 3) {
                    withAnimation(.spring(response: 0.3)) {
                        selectedTab = 3
                    }
                }
                
                TabButton(title: "All", icon: "list.bullet", isSelected: selectedTab == 4) {
                    withAnimation(.spring(response: 0.3)) {
                        selectedTab = 4
                    }
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 16)
    }
    
    // MARK: - Filtering
    
    private var filteredNotifications: [NotificationItem] {
        switch selectedTab {
        case 0: return notifications.filter { $0.type == .oneTime }
        case 1: return notifications.filter { $0.type == .daily }
        case 2: return notifications.filter { $0.type == .weekly }
        case 3: return notifications.filter { $0.type == .hourly }
        default: return notifications
        }
    }
    
    // MARK: - Placeholder Methods (Replace with your logic)
    private func addOrUpdateNotification(_ item: NotificationItem) {
        if let index = notifications.firstIndex(where: { $0.id == item.id }) {
            notifications[index] = item
        } else {
            notifications.append(item)
        }

        NotificationManager.shared.schedule(item)
    }

    private func toggleNotification(_ id: String) {
        guard let index = notifications.firstIndex(where: { $0.id == id }) else { return }

        notifications[index].isEnabled.toggle()

        if notifications[index].isEnabled {
            NotificationManager.shared.schedule(notifications[index])
        } else {
            NotificationManager.shared.delete(id)
        }
    }

    
    private func deleteNotification(_ id: String) {
        NotificationManager.shared.delete(id)
        notifications.removeAll { $0.id == id }
    }

}

// MARK: - Tab Button

struct TabButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
            }
            .foregroundColor(isSelected ? .white : .primary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                isSelected ?
                LinearGradient(
                    colors: [Color(hex: "6366F1"), Color(hex: "8B5CF6")],
                    startPoint: .leading,
                    endPoint: .trailing
                ) : LinearGradient(colors: [Color.white], startPoint: .leading, endPoint: .trailing)
            )
            .cornerRadius(16)
            .shadow(color: isSelected ? Color(hex: "6366F1").opacity(0.3) : Color.black.opacity(0.05), radius: 8, y: 4)
        }
    }
}

// MARK: - Notification Card

struct NotificationCard: View {
    let notification: NotificationItem
    let onToggle: () -> Void
    let onDelete: () -> Void
    let onEdit: () -> Void
    let onAskForFutureTime: () -> Void
    
    var isPast: Bool {
        let now = Date()
        let calendar = Calendar.current
        
        switch notification.type {
        case .oneTime:
            if let date = notification.date {
                let fireDate = calendar.date(
                    bySettingHour: calendar.component(.hour, from: notification.time),
                    minute: calendar.component(.minute, from: notification.time),
                    second: 0,
                    of: date
                ) ?? date
                return fireDate < now
            }
            return false
        case .daily, .hourly:
            return false
        case .weekly:
            guard let days = notification.selectedDays else { return false }
            let today = calendar.component(.weekday, from: now) - 1
            if days.contains(today) {
                let nextTime = calendar.date(
                    bySettingHour: calendar.component(.hour, from: notification.time),
                    minute: calendar.component(.minute, from: notification.time),
                    second: 0,
                    of: now
                ) ?? now
                return nextTime < now
            }
            return false
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: notification.isEnabled ?
                            [Color(hex: "6366F1"), Color(hex: "8B5CF6")] :
                            [Color.gray.opacity(0.3), Color.gray.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 56, height: 56)
                
                Image(systemName:
                        notification.type == .daily ? "sun.max.fill" :
                        notification.type == .weekly ? "calendar" :
                        notification.type == .hourly ? "clock.arrow.circlepath" :
                        "bell.fill"
                )
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.white)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(notification.title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text(isPast ? "PAST" : "FUTURE")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(isPast ? Color.red : Color.green)
                        .cornerRadius(8)
                }
                
                HStack(spacing: 12) {
                    Label(formatTime(notification.time), systemImage: "clock.fill")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    Label(notification.sound, systemImage: "speaker.wave.2.fill")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                if notification.type == .oneTime, let date = notification.date {
                    Label(formatDate(date), systemImage: "calendar")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.secondary)
                        .padding(.top, 2)
                }
                
                if notification.type == .weekly, let days = notification.selectedDays {
                    HStack(spacing: 4) {
                        ForEach(days, id: \.self) { day in
                            Text(dayString(day))
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 3)
                                .background(Color(hex: "6366F1"))
                                .cornerRadius(6)
                        }
                    }
                    .padding(.top, 4)
                }
            }
            
            Spacer()
            
            // Controls
            VStack(spacing: 8) {
                Toggle("", isOn: Binding(
                    get: { notification.isEnabled },
                    set: { _ in
                        if isPast {
                            onAskForFutureTime()
                        } else {
                            onToggle()
                        }
                    }
                ))
                .labelsHidden()
                .tint(Color(hex: "6366F1"))
                .disabled(isPast)
                
                Button(action: onEdit) {
                    Image(systemName: "pencil.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(Color(hex: "6366F1"))
                }
                
                Button(action: onDelete) {
                    Image(systemName: "trash.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.red)
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 10, y: 4)
    }
    
    private func dayString(_ day: Int) -> String {
        ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"][day]
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

// MARK: - Add Notification Sheet

struct AddNotificationSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    var editingNotification: NotificationItem?
    var onSave: (NotificationItem) -> Void
    
    @State private var title = ""
    @State private var selectedTime = Date()
    @State private var selectedDate = Date()
    @State private var notificationType: NotificationType = .oneTime
    @State private var selectedDays: Set<Int> = []
    @State private var selectedSound = "Chime"
    @State private var showSoundPicker = false
    
    let sounds = [
        "clownhornsounds.wav",
        "dazzle.wav",
        "failurepiano.wav",
        "whistle.wav",
        "voicelaugh.wav"
    ]
    
    let weekDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    init(editingNotification: NotificationItem?, onSave: @escaping (NotificationItem) -> Void) {
        self.editingNotification = editingNotification
        self.onSave = onSave
        
        if let notification = editingNotification {
            _title = State(initialValue: notification.title)
            _selectedTime = State(initialValue: notification.time)
            _selectedDate = State(initialValue: notification.date ?? Date())
            _notificationType = State(initialValue: notification.type)
            _selectedDays = State(initialValue: Set(notification.selectedDays ?? []))
            _selectedSound = State(initialValue: notification.sound)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [Color(hex: "E0E7FF"), Color(hex: "F3E8FF")],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Title Input
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Title")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            TextField("Enter notification title", text: $title)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.05), radius: 5)
                        }
                        
                        // Time Picker
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Time")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
                                .datePickerStyle(.wheel)
                                .labelsHidden()
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.05), radius: 5)
                        }
                        
                        // Type Picker
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Frequency")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            Picker("Type", selection: $notificationType) {
                                Text("One Time").tag(NotificationType.oneTime)
                                Text("Daily").tag(NotificationType.daily)
                                Text("Weekly").tag(NotificationType.weekly)
                                Text("Hourly").tag(NotificationType.hourly)
                            }
                            .pickerStyle(.segmented)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.05), radius: 5)
                        }
                        
                        // Date Picker for One Time
                        if notificationType == .oneTime {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Date")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.primary)
                                
                                DatePicker("", selection: $selectedDate, displayedComponents: .date)
                                    .datePickerStyle(.graphical)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .shadow(color: Color.black.opacity(0.05), radius: 5)
                            }
                        }
                        
                        // Weekly Days Selection
                        if notificationType == .weekly {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Select Days")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.primary)
                                
                                HStack(spacing: 8) {
                                    ForEach(0..<7) { index in
                                        Button(action: {
                                            if selectedDays.contains(index) {
                                                selectedDays.remove(index)
                                            } else {
                                                selectedDays.insert(index)
                                            }
                                        }) {
                                            Text(weekDays[index])
                                                .font(.system(size: 14, weight: .semibold))
                                                .foregroundColor(selectedDays.contains(index) ? .white : .primary)
                                                .frame(width: 45, height: 45)
                                                .background(
                                                    selectedDays.contains(index) ?
                                                    Color(hex: "6366F1") : Color.white
                                                )
                                                .cornerRadius(12)
                                                .shadow(color: Color.black.opacity(0.05), radius: 5)
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Sound Picker
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Notification Sound")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            Button(action: { showSoundPicker.toggle() }) {
                                HStack {
                                    Image(systemName: "speaker.wave.2.fill")
                                        .foregroundColor(Color(hex: "6366F1"))
                                    Text(selectedSound)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.05), radius: 5)
                            }
                        }
                        
                        // Add/Update Button
                        Button(action: saveNotification) {
                            Text(editingNotification == nil ? "Add Notification" : "Update Notification")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    LinearGradient(
                                        colors: [Color(hex: "6366F1"), Color(hex: "8B5CF6")],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(16)
                                .shadow(color: Color(hex: "6366F1").opacity(0.4), radius: 10, y: 5)
                        }
                        .padding(.top, 16)
                    }
                    .padding(24)
                }
            }
            .navigationTitle(editingNotification == nil ? "New Notification" : "Edit Notification")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showSoundPicker) {
                SoundPickerSheet(selectedSound: $selectedSound, isPresented: $showSoundPicker, sounds: sounds)
            }
        }
    }
    
    private func saveNotification() {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let item = NotificationItem(
            id: editingNotification?.id ?? UUID().uuidString,
            title: title,
            time: selectedTime,
            type: notificationType,
            date: notificationType == .oneTime ? selectedDate : nil,
            selectedDays: notificationType == .weekly ? Array(selectedDays) : nil,
            sound: selectedSound,
            isEnabled: true
        )
        
        onSave(item)
        dismiss()
    }
}

// MARK: - Sound Picker Sheet

struct SoundPickerSheet: View {
    @Binding var selectedSound: String
    @Binding var isPresented: Bool
    let sounds: [String]
    
    let soundDisplayNames: [String: String] = [
        "clownhornsounds.wav": "Clown Horn",
        "dazzle.wav": "Dazzle",
        "failurepiano.wav": "Piano Fail",
        "whistle.wav": "Whistle",
        "voicelaugh.wav": "Voice Laugh"
    ]
    
    var body: some View {
        NavigationView {
            List(sounds, id: \.self) { sound in
                HStack {
                    Button {
                        SoundPlayer.shared.playSound(named: sound)
                    } label: {
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(Color(hex: "6366F1"))
                    }
                    
                    Text(soundDisplayNames[sound] ?? sound)
                        .foregroundColor(.primary)
                        .padding(.leading, 8)

                    Spacer()

                    if selectedSound == sound {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color(hex: "6366F1"))
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedSound = sound
                    SoundPlayer.shared.playSound(named: sound)
                }
            }

            .navigationTitle("Select Sound")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                }
            }
        }
    }
}

// MARK: - Models

enum NotificationType: String, Codable, CaseIterable {
    case oneTime
    case daily
    case weekly
    case hourly
}

struct NotificationItem: Identifiable, Codable, Equatable {
    var id: String
    var title: String
    var time: Date
    var type: NotificationType
    var date: Date?
    var selectedDays: [Int]?
    var sound: String
    var isEnabled: Bool
    
    init(id: String = UUID().uuidString,
         title: String,
         time: Date,
         type: NotificationType,
         date: Date? = nil,
         selectedDays: [Int]? = nil,
         sound: String,
         isEnabled: Bool)
    {
        self.id = id
        self.title = title
        self.time = time
        self.type = type
        self.date = date
        self.selectedDays = selectedDays
        self.sound = sound
        self.isEnabled = isEnabled
    }
}

// MARK: - Color Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Preview

struct NotificationSchedulerView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationSchedulerView()
    }
}
