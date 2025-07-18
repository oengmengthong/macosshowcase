//
//  DataStateDemoView.swift
//  macosshowcase
//
//  Created by Mengthong on 18/7/25.
//

import SwiftUI
import SwiftData

@Model
final class DemoItem {
    var name: String
    var count: Int
    var isEnabled: Bool
    var createdAt: Date
    
    init(name: String, count: Int = 0, isEnabled: Bool = true) {
        self.name = name
        self.count = count
        self.isEnabled = isEnabled
        self.createdAt = Date()
    }
}

class DemoDataManager: ObservableObject {
    @Published var counter = 0
    @Published var message = "Hello, World!"
    @Published var isActive = false
}

struct DataStateDemoView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var demoItems: [DemoItem]
    
    @State private var localCounter = 0
    @StateObject private var dataManager = DemoDataManager()
    @AppStorage("userPreference") private var userPreference = "Default"
    @SceneStorage("sceneState") private var sceneState = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                headerSection("Data & State Management")
                
                stateManagementSection
                swiftDataSection
                
                Spacer(minLength: 50)
            }
            .padding()
        }
        .navigationTitle("Data & State")
    }
    
    private var stateManagementSection: some View {
        demoSection("State Management") {
            VStack(spacing: 20) {
                GroupBox("@State - Local State") {
                    VStack(spacing: 10) {
                        Text("Counter: \(localCounter)")
                            .font(.headline)
                        
                        HStack {
                            Button("-") { localCounter -= 1 }
                            Button("+") { localCounter += 1 }
                        }
                        
                        Text("Local view state that triggers UI updates")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                GroupBox("@StateObject/@ObservedObject") {
                    VStack(spacing: 10) {
                        Text("Manager Counter: \(dataManager.counter)")
                            .font(.headline)
                        
                        Text("Message: \(dataManager.message)")
                        
                        Toggle("Active", isOn: $dataManager.isActive)
                        
                        HStack {
                            Button("Increment") {
                                dataManager.counter += 1
                                dataManager.message = "Updated at \(Date().formatted(.dateTime.hour().minute().second()))"
                            }
                            
                            Button("Reset") {
                                dataManager.counter = 0
                                dataManager.message = "Reset!"
                            }
                        }
                        
                        Text("ObservableObject for complex state management")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                GroupBox("@AppStorage - UserDefaults") {
                    VStack(spacing: 10) {
                        TextField("User Preference", text: $userPreference)
                            .textFieldStyle(.roundedBorder)
                        
                        Text("Stored value: \(userPreference)")
                            .font(.caption)
                        
                        Text("Persists across app launches using UserDefaults")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                GroupBox("@SceneStorage - Scene State") {
                    VStack(spacing: 10) {
                        TextField("Scene State", text: $sceneState)
                            .textFieldStyle(.roundedBorder)
                        
                        Text("Scene value: \(sceneState)")
                            .font(.caption)
                        
                        Text("Persists per scene/window session")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
    
    private var swiftDataSection: some View {
        demoSection("SwiftData Integration") {
            VStack(spacing: 20) {
                GroupBox("@Model & @Query") {
                    VStack(spacing: 15) {
                        Text("Demo Items: \(demoItems.count)")
                            .font(.headline)
                        
                        if demoItems.isEmpty {
                            Text("No items yet")
                                .foregroundColor(.secondary)
                        } else {
                            LazyVStack(spacing: 8) {
                                ForEach(demoItems) { item in
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(item.name)
                                                .font(.headline)
                                            Text("Count: \(item.count) • Created: \(item.createdAt.formatted(.dateTime.hour().minute()))")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        
                                        Spacer()
                                        
                                        Button("+1") {
                                            item.count += 1
                                        }
                                        .buttonStyle(.bordered)
                                        
                                        Button("Delete") {
                                            deleteItem(item)
                                        }
                                        .buttonStyle(.bordered)
                                        .foregroundColor(.red)
                                    }
                                    .padding(8)
                                    .background(Color(.controlBackgroundColor))
                                    .cornerRadius(6)
                                }
                            }
                            .frame(maxHeight: 200)
                        }
                        
                        HStack {
                            Button("Add Random Item") {
                                addRandomItem()
                            }
                            .buttonStyle(.borderedProminent)
                            
                            if !demoItems.isEmpty {
                                Button("Clear All") {
                                    clearAllItems()
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                        
                        Text("SwiftData for persistent storage with @Model and @Query")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                GroupBox("Environment Values") {
                    VStack(spacing: 10) {
                        EnvironmentInfoView()
                        
                        Text("@Environment provides access to system values")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
    
    private func addRandomItem() {
        let names = ["Task", "Project", "Document", "Note", "Reminder"]
        let randomName = names.randomElement() ?? "Item"
        let item = DemoItem(name: "\(randomName) \(Int.random(in: 1...100))")
        modelContext.insert(item)
    }
    
    private func deleteItem(_ item: DemoItem) {
        modelContext.delete(item)
    }
    
    private func clearAllItems() {
        for item in demoItems {
            modelContext.delete(item)
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
            
            Text("State management patterns and data persistence with SwiftData")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

struct EnvironmentInfoView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.locale) private var locale
    @Environment(\.timeZone) private var timeZone
    @Environment(\.calendar) private var calendar
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Color Scheme: \(colorScheme == .dark ? "Dark" : "Light")")
            Text("Locale: \(locale.identifier)")
            Text("Time Zone: \(timeZone.identifier)")
            Text("Calendar: \(calendar.identifier)")
        }
        .font(.caption)
        .padding(8)
        .background(Color(.controlBackgroundColor))
        .cornerRadius(6)
    }
}

#Preview {
    NavigationStack {
        DataStateDemoView()
    }
}
