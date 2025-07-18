//
//  ControlsInputDemoView.swift
//  macosshowcase
//
//  Created by Mengthong on 18/7/25.
//

import SwiftUI

struct ControlsInputDemoView: View {
    @State private var textFieldText = ""
    @State private var secureFieldText = ""
    @State private var textEditorText = "Multi-line text editor content..."
    @State private var toggleValue = false
    @State private var pickerSelection = "Option 1"
    @State private var stepperValue = 5
    @State private var sliderValue = 0.5
    @State private var selectedColor = Color.blue
    @State private var selectedDate = Date()
    @State private var searchText = ""
    
    private let pickerOptions = ["Option 1", "Option 2", "Option 3"]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                headerSection("Controls & Input Components")
                
                buttonsActionsSection
                textInputSection
                selectionControlsSection
                
                Spacer(minLength: 50)
            }
            .padding()
        }
        .navigationTitle("Controls & Input")
    }
    
    private var buttonsActionsSection: some View {
        demoSection("Buttons & Actions") {
            VStack(spacing: 20) {
                GroupBox("Button Styles") {
                    VStack(spacing: 15) {
                        HStack(spacing: 15) {
                            Button("Default") { }
                            
                            Button("Bordered") { }
                                .buttonStyle(.bordered)
                            
                            Button("Prominent") { }
                                .buttonStyle(.borderedProminent)
                        }
                        
                        HStack(spacing: 15) {
                            Button("Plain") { }
                                .buttonStyle(.plain)
                            
                            Button("Link") { }
                                .buttonStyle(.link)
                            
                            Button("Accessory Bar") { }
                                .buttonStyle(.accessoryBar)
                        }
                        
                        Text("Various button styles available in SwiftUI")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                GroupBox("Menu Button") {
                    VStack(alignment: .leading, spacing: 10) {
                        Menu("Options Menu") {
                            Button("New File", systemImage: "doc.badge.plus") { }
                            Button("Open File", systemImage: "folder") { }
                            Divider()
                            Button("Delete", systemImage: "trash", role: .destructive) { }
                        }
                        .menuStyle(.borderlessButton)
                        
                        Text("Menu provides dropdown options")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                GroupBox("Link Button") {
                    VStack(alignment: .leading, spacing: 10) {
                        Link("Visit Apple.com", destination: URL(string: "https://apple.com")!)
                        
                        Text("Link opens URLs in default browser")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
    
    private var textInputSection: some View {
        demoSection("Text Input") {
            VStack(spacing: 20) {
                GroupBox("Text Fields") {
                    VStack(spacing: 15) {
                        TextField("Enter text here", text: $textFieldText)
                            .textFieldStyle(.roundedBorder)
                        
                        SecureField("Enter password", text: $secureFieldText)
                            .textFieldStyle(.roundedBorder)
                        
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.secondary)
                            TextField("Search", text: $searchText)
                        }
                        .padding(8)
                        .background(Color(.controlBackgroundColor))
                        .cornerRadius(8)
                        
                        VStack(alignment: .leading) {
                            Text("Text Editor:")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            TextEditor(text: $textEditorText)
                                .frame(height: 80)
                                .border(Color.gray.opacity(0.3))
                        }
                    }
                }
            }
        }
    }
    
    private var selectionControlsSection: some View {
        demoSection("Selection Controls") {
            VStack(spacing: 20) {
                GroupBox("Toggle & Picker") {
                    VStack(spacing: 15) {
                        Toggle("Enable Feature", isOn: $toggleValue)
                        
                        Picker("Choose Option", selection: $pickerSelection) {
                            ForEach(pickerOptions, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        .pickerStyle(.menu)
                        
                        Picker("Segmented Picker", selection: $pickerSelection) {
                            ForEach(pickerOptions, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                }
                
                GroupBox("Stepper & Slider") {
                    VStack(spacing: 15) {
                        Stepper("Value: \(stepperValue)", value: $stepperValue, in: 0...10)
                        
                        VStack {
                            HStack {
                                Text("0")
                                Slider(value: $sliderValue, in: 0...1)
                                Text("1")
                            }
                            Text("Slider Value: \(sliderValue, specifier: "%.2f")")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                GroupBox("Color & Date Pickers") {
                    VStack(spacing: 15) {
                        ColorPicker("Select Color", selection: $selectedColor)
                        
                        DatePicker("Select Date", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(.compact)
                        
                        DatePicker("Graphical Date", selection: $selectedDate, displayedComponents: [.date])
                            .datePickerStyle(.graphical)
                            .frame(maxHeight: 300)
                    }
                }
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
            
            Text("Interactive controls and input components for user interaction")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    NavigationStack {
        ControlsInputDemoView()
    }
}
