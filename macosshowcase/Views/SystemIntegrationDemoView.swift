//
//  SystemIntegrationDemoView.swift
//  macosshowcase
//
//  Created by Mengthong on 18/7/25.
//

import SwiftUI

struct SystemIntegrationDemoView: View {
    @State private var keyPressInfo = "Press any key..."
    @FocusState private var textFieldFocused: Bool
    @State private var shareText = "Check out this amazing macOS app!"
    @State private var urlToOpen = "https://www.apple.com"
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                headerSection("System Integration")
                
                accessibilitySection
                keyboardFocusSection
                systemServicesSection
                
                Spacer(minLength: 50)
            }
            .padding()
        }
        .navigationTitle("System Integration")
        .onKeyPress { keyPress in
            keyPressInfo = "Key pressed: \(keyPress.characters)"
            return .handled
        }
    }
    
    private var accessibilitySection: some View {
        demoSection("Accessibility Features") {
            VStack(spacing: 20) {
                GroupBox("Accessibility Labels") {
                    VStack(spacing: 15) {
                        Button("Important Action") {
                            // Action
                        }
                        .accessibilityLabel("Perform important action")
                        .accessibilityHint("This will execute the main app function")
                        .buttonStyle(.borderedProminent)
                        
                        HStack {
                            Image(systemName: "star.fill")
                                .accessibilityLabel("Rating")
                                .accessibilityValue("5 out of 5 stars")
                            
                            Text("Premium Feature")
                                .accessibilityAddTraits(.isHeader)
                        }
                        
                        Toggle("Enable notifications", isOn: .constant(true))
                            .accessibilityLabel("Notification toggle")
                            .accessibilityHint("Turn notifications on or off")
                        
                        Text("Accessibility makes apps usable by everyone")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                GroupBox("Dynamic Type Support") {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Large Title")
                            .font(.largeTitle)
                        Text("Body text that scales with system preferences")
                            .font(.body)
                        Text("Caption text")
                            .font(.caption)
                        
                        Text("Text automatically scales with system font size settings")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
    
    private var keyboardFocusSection: some View {
        demoSection("Keyboard & Focus") {
            VStack(spacing: 20) {
                GroupBox("Keyboard Input") {
                    VStack(spacing: 15) {
                        Text(keyPressInfo)
                            .font(.headline)
                            .padding()
                            .background(Color(.controlBackgroundColor))
                            .cornerRadius(8)
                        
                        Text("Global key press detection (any key)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                GroupBox("Focus Management") {
                    VStack(spacing: 15) {
                        TextField("Focus me with Tab", text: .constant(""))
                            .textFieldStyle(.roundedBorder)
                            .focused($textFieldFocused)
                        
                        Button(textFieldFocused ? "Remove Focus" : "Focus TextField") {
                            textFieldFocused.toggle()
                        }
                        
                        Text("Programmatic focus control with @FocusState")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                GroupBox("Keyboard Shortcuts") {
                    VStack(spacing: 10) {
                        Button("Save (⌘S)") {
                            // Save action
                        }
                        .keyboardShortcut("s", modifiers: .command)
                        
                        Button("New (⌘N)") {
                            // New action
                        }
                        .keyboardShortcut("n", modifiers: .command)
                        
                        Button("Delete (⌫)") {
                            // Delete action
                        }
                        .keyboardShortcut(.delete)
                        
                        Text("Keyboard shortcuts for common actions")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
    
    private var systemServicesSection: some View {
        demoSection("System Services") {
            VStack(spacing: 20) {
                GroupBox("Sharing & External Apps") {
                    VStack(spacing: 15) {
                        ShareLink("Share Text", item: shareText)
                            .buttonStyle(.bordered)
                        
                        Button("Open URL") {
                            if let url = URL(string: urlToOpen) {
                                NSWorkspace.shared.open(url)
                            }
                        }
                        .buttonStyle(.bordered)
                        
                        HStack {
                            TextField("URL to open", text: $urlToOpen)
                                .textFieldStyle(.roundedBorder)
                        }
                        
                        Text("System sharing and URL opening capabilities")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                GroupBox("Notifications") {
                    VStack(spacing: 15) {
                        Button("Schedule Local Notification") {
                            scheduleNotification()
                        }
                        .buttonStyle(.bordered)
                        
                        Button("Request Permission") {
                            requestNotificationPermission()
                        }
                        .buttonStyle(.bordered)
                        
                        Text("Local notifications for user alerts")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                GroupBox("System Information") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("System Version: \(ProcessInfo.processInfo.operatingSystemVersionString)")
                        Text("App Bundle: \(Bundle.main.bundleIdentifier ?? "Unknown")")
                        Text("App Version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown")")
                        
                        Text("Access to system and app information")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.top, 5)
                    }
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
    
    private func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Demo Notification"
        content.body = "This is a test notification from the macOS Showcase app"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let request = UNNotificationRequest(identifier: "demo-notification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else if let error = error {
                print("Error requesting permission: \(error)")
            }
        }
    }
    
    private func demoSection<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
            
            content()
        }
    }
    
    private func headerSection(_ title: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Integration with macOS system services and accessibility features")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

import UserNotifications

#Preview {
    NavigationStack {
        SystemIntegrationDemoView()
    }
}
