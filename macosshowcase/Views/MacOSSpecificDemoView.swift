//
//  MacOSSpecificDemoView.swift
//  macosshowcase
//
//  Created by Mengthong on 18/7/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct MacOSSpecificDemoView: View {
    @State private var showingAlert = false
    @State private var showingConfirmation = false
    @State private var showingFileImporter = false
    @State private var showingFileExporter = false
    @State private var importedFileURL: URL?
    @State private var documentContent = "Sample document content to export"
    @State private var alertMessage = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                headerSection("macOS-Specific Components")
                
                windowManagementSection
                toolbarMenuSection
                panelsDialogsSection
                
                Spacer(minLength: 50)
            }
            .padding()
        }
        .navigationTitle("macOS Specific")
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button("New", systemImage: "doc.badge.plus") {
                    alertMessage = "New document created!"
                    showingAlert = true
                }
                
                Button("Save", systemImage: "square.and.arrow.down") {
                    showingFileExporter = true
                }
                
                Button("Open", systemImage: "folder") {
                    showingFileImporter = true
                }
            }
            
            ToolbarItem(placement: .navigation) {
                Button("Settings", systemImage: "gear") {
                    alertMessage = "Settings would open here"
                    showingAlert = true
                }
            }
        }
        .alert("Notification", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
        .confirmationDialog("Are you sure?", isPresented: $showingConfirmation) {
            Button("Delete", role: .destructive) {
                alertMessage = "Item deleted!"
                showingAlert = true
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This action cannot be undone.")
        }
        .fileImporter(
            isPresented: $showingFileImporter,
            allowedContentTypes: [.plainText, .pdf, .image],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let files):
                importedFileURL = files.first
                alertMessage = "Imported: \(files.first?.lastPathComponent ?? "Unknown file")"
                showingAlert = true
            case .failure(let error):
                alertMessage = "Import failed: \(error.localizedDescription)"
                showingAlert = true
            }
        }
        .fileExporter(
            isPresented: $showingFileExporter,
            document: TextDocument(content: documentContent),
            contentType: .plainText,
            defaultFilename: "sample"
        ) { result in
            switch result {
            case .success(let url):
                alertMessage = "Exported to: \(url.lastPathComponent)"
                showingAlert = true
            case .failure(let error):
                alertMessage = "Export failed: \(error.localizedDescription)"
                showingAlert = true
            }
        }
    }
    
    private var windowManagementSection: some View {
        demoSection("Window Management") {
            VStack(spacing: 20) {
                GroupBox("Window Controls") {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Current window features:")
                            .font(.headline)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Label("WindowGroup: Standard app window", systemImage: "macwindow")
                            Label("Toolbar: Integrated window toolbar", systemImage: "slider.horizontal.3")
                            Label("Split View: Navigation sidebar", systemImage: "sidebar.left")
                            Label("Resizable: Window can be resized", systemImage: "arrow.up.left.and.arrow.down.right")
                        }
                        .font(.body)
                        
                        Text("In a real app, you could also implement:")
                            .font(.subheadline)
                            .padding(.top)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("• DocumentGroup for document-based apps")
                            Text("• Settings window with dedicated scene")
                            Text("• MenuBarExtra for menu bar apps")
                            Text("• Multiple window groups")
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
    
    private var toolbarMenuSection: some View {
        demoSection("Toolbars & Menus") {
            VStack(spacing: 20) {
                GroupBox("Toolbar Integration") {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Active toolbar items:")
                            .font(.headline)
                        
                        HStack(spacing: 20) {
                            VStack {
                                Image(systemName: "doc.badge.plus")
                                    .font(.title2)
                                Text("New")
                                    .font(.caption)
                            }
                            
                            VStack {
                                Image(systemName: "square.and.arrow.down")
                                    .font(.title2)
                                Text("Save")
                                    .font(.caption)
                            }
                            
                            VStack {
                                Image(systemName: "folder")
                                    .font(.title2)
                                Text("Open")
                                    .font(.caption)
                            }
                            
                            VStack {
                                Image(systemName: "gear")
                                    .font(.title2)
                                Text("Settings")
                                    .font(.caption)
                            }
                        }
                        .foregroundColor(.blue)
                        
                        Text("Toolbar items are defined in the .toolbar modifier")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                GroupBox("Context Menu") {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Right-click this area for context menu")
                            .padding()
                            .background(Color(.controlBackgroundColor))
                            .cornerRadius(8)
                            .contextMenu {
                                Button("Copy", systemImage: "doc.on.doc") { }
                                Button("Paste", systemImage: "clipboard") { }
                                Divider()
                                Button("Delete", systemImage: "trash", role: .destructive) { }
                            }
                        
                        Text("Context menus provide quick access to relevant actions")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
    
    private var panelsDialogsSection: some View {
        demoSection("Panels & Dialogs") {
            VStack(spacing: 20) {
                GroupBox("Alerts & Confirmations") {
                    VStack(spacing: 15) {
                        HStack(spacing: 15) {
                            Button("Show Alert") {
                                alertMessage = "This is a sample alert message!"
                                showingAlert = true
                            }
                            .buttonStyle(.bordered)
                            
                            Button("Show Confirmation") {
                                showingConfirmation = true
                            }
                            .buttonStyle(.bordered)
                        }
                        
                        Text("Native macOS alert and confirmation dialogs")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                GroupBox("File Operations") {
                    VStack(spacing: 15) {
                        HStack(spacing: 15) {
                            Button("Import File") {
                                showingFileImporter = true
                            }
                            .buttonStyle(.bordered)
                            
                            Button("Export File") {
                                showingFileExporter = true
                            }
                            .buttonStyle(.bordered)
                        }
                        
                        if let url = importedFileURL {
                            HStack {
                                Image(systemName: "doc")
                                Text("Last imported: \(url.lastPathComponent)")
                                    .font(.caption)
                            }
                            .foregroundColor(.green)
                        }
                        
                        Text("Native file picker and save dialogs")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                GroupBox("Drag & Drop") {
                    VStack(alignment: .leading, spacing: 10) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.controlBackgroundColor))
                            .frame(height: 100)
                            .overlay(
                                VStack {
                                    Image(systemName: "arrow.down.doc")
                                        .font(.title)
                                        .foregroundColor(.blue)
                                    Text("Drop files here")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            )
                            .onDrop(of: [.fileURL], isTargeted: nil) { providers in
                                handleDrop(providers: providers)
                                return true
                            }
                        
                        Text("Drag and drop support for file operations")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
    
    private func handleDrop(providers: [NSItemProvider]) {
        for provider in providers {
            provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { (data, error) in
                if let data = data as? Data,
                   let url = URL(dataRepresentation: data, relativeTo: nil) {
                    DispatchQueue.main.async {
                        self.importedFileURL = url
                        self.alertMessage = "Dropped file: \(url.lastPathComponent)"
                        self.showingAlert = true
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
            
            Text("Components and features specific to macOS platform")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

struct TextDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.plainText] }
    
    var content: String
    
    init(content: String = "") {
        self.content = content
    }
    
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        content = string
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = content.data(using: .utf8)!
        return .init(regularFileWithContents: data)
    }
}

#Preview {
    NavigationStack {
        MacOSSpecificDemoView()
    }
}
