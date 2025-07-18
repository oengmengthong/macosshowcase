//
//  ListsCollectionsDemoView.swift
//  macosshowcase
//
//  Created by Mengthong on 18/7/25.
//

import SwiftUI

struct ListItem: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let description: String
}

struct TreeNode: Identifiable {
    let id = UUID()
    let name: String
    let children: [TreeNode]?
    
    init(name: String, children: [TreeNode]? = nil) {
        self.name = name
        self.children = children
    }
}

struct TableData: Identifiable {
    let id = UUID()
    let name: String
    let type: String
    let size: String
    let modified: Date
}

struct ListsCollectionsDemoView: View {
    @State private var listItems = [
        ListItem(name: "Documents", icon: "folder", description: "Your documents"),
        ListItem(name: "Downloads", icon: "arrow.down.circle", description: "Downloaded files"),
        ListItem(name: "Pictures", icon: "photo", description: "Your photos"),
        ListItem(name: "Music", icon: "music.note", description: "Audio files"),
        ListItem(name: "Videos", icon: "video", description: "Video files")
    ]
    
    @State private var treeData = [
        TreeNode(name: "Root", children: [
            TreeNode(name: "Folder 1", children: [
                TreeNode(name: "File 1.txt"),
                TreeNode(name: "File 2.txt")
            ]),
            TreeNode(name: "Folder 2", children: [
                TreeNode(name: "Subfolder", children: [
                    TreeNode(name: "Deep file.txt")
                ])
            ]),
            TreeNode(name: "Single file.txt")
        ])
    ]
    
    @State private var tableData = [
        TableData(name: "Document.pdf", type: "PDF", size: "2.3 MB", modified: Date()),
        TableData(name: "Image.jpg", type: "JPEG", size: "1.8 MB", modified: Date().addingTimeInterval(-3600)),
        TableData(name: "Spreadsheet.xlsx", type: "Excel", size: "456 KB", modified: Date().addingTimeInterval(-7200)),
        TableData(name: "Presentation.pptx", type: "PowerPoint", size: "5.2 MB", modified: Date().addingTimeInterval(-10800))
    ]
    
    @State private var selection = Set<ListItem.ID>()
    @State private var sortOrder = [KeyPathComparator(\TableData.name)]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                headerSection("Lists & Collections Components")
                
                basicListsSection
                outlineGroupSection
                tableSection
                
                Spacer(minLength: 50)
            }
            .padding()
        }
        .navigationTitle("Lists & Collections")
    }
    
    private var basicListsSection: some View {
        demoSection("List Components") {
            VStack(spacing: 20) {
                GroupBox("Basic List") {
                    VStack {
                        List(listItems) { item in
                            Label {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(item.name)
                                        .font(.headline)
                                    Text(item.description)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            } icon: {
                                Image(systemName: item.icon)
                                    .foregroundColor(.blue)
                            }
                        }
                        .frame(height: 200)
                        .listStyle(.bordered(alternatesRowBackgrounds: true))
                        
                        Text("Basic list with alternating row backgrounds")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                GroupBox("List with Sections") {
                    VStack {
                        List {
                            Section("System Folders") {
                                ForEach(listItems.prefix(3)) { item in
                                    Label(item.name, systemImage: item.icon)
                                }
                            }
                            
                            Section("Media Folders") {
                                ForEach(listItems.suffix(2)) { item in
                                    Label(item.name, systemImage: item.icon)
                                }
                            }
                        }
                        .frame(height: 200)
                        .listStyle(.sidebar)
                        
                        Text("Sectioned list with sidebar style")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                GroupBox("List with Selection & Actions") {
                    VStack {
                        List(listItems, selection: $selection) { item in
                            Label(item.name, systemImage: item.icon)
                        }
                        .frame(height: 150)
                        .onDeleteCommand {
                            deleteSelectedItems()
                        }
                        .contextMenu {
                            Button("Delete", role: .destructive) {
                                deleteSelectedItems()
                            }
                            Button("Duplicate") {
                                duplicateSelectedItems()
                            }
                        }
                        
                        HStack {
                            Text("Selected: \(selection.count) items")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Button("Clear Selection") {
                                selection.removeAll()
                            }
                            .disabled(selection.isEmpty)
                        }
                    }
                }
            }
        }
    }
    
    private var outlineGroupSection: some View {
        demoSection("Hierarchical Data") {
            VStack(spacing: 20) {
                GroupBox("OutlineGroup (Tree View)") {
                    VStack {
                        List(treeData, children: \.children) { node in
                            Label(node.name, systemImage: node.children != nil ? "folder" : "doc")
                        }
                        .frame(height: 200)
                        .listStyle(.sidebar)
                        
                        Text("Hierarchical tree structure with OutlineGroup")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
    
    private var tableSection: some View {
        demoSection("Table Component (macOS)") {
            VStack(spacing: 20) {
                GroupBox("Structured Table") {
                    VStack {
                        Table(tableData, sortOrder: $sortOrder) {
                            TableColumn("Name", value: \.name) { data in
                                HStack {
                                    Image(systemName: iconForFileType(data.type))
                                        .foregroundColor(colorForFileType(data.type))
                                    Text(data.name)
                                }
                            }
                            .width(min: 150, ideal: 200)
                            
                            TableColumn("Type", value: \.type)
                                .width(80)
                            
                            TableColumn("Size", value: \.size)
                                .width(80)
                            
                            TableColumn("Modified") { data in
                                Text(data.modified, style: .relative)
                            }
                            .width(100)
                        }
                        .frame(height: 200)
                        .onChange(of: sortOrder) {
                            tableData.sort(using: sortOrder)
                        }
                        
                        Text("Sortable table with multiple columns")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
    
    private func iconForFileType(_ type: String) -> String {
        switch type {
        case "PDF": return "doc.richtext"
        case "JPEG": return "photo"
        case "Excel": return "tablecells"
        case "PowerPoint": return "rectangle.on.rectangle"
        default: return "doc"
        }
    }
    
    private func colorForFileType(_ type: String) -> Color {
        switch type {
        case "PDF": return .red
        case "JPEG": return .green
        case "Excel": return .blue
        case "PowerPoint": return .orange
        default: return .gray
        }
    }
    
    private func deleteSelectedItems() {
        listItems.removeAll { item in
            selection.contains(item.id)
        }
        selection.removeAll()
    }
    
    private func duplicateSelectedItems() {
        let selectedItems = listItems.filter { selection.contains($0.id) }
        for item in selectedItems {
            let duplicate = ListItem(
                name: "\(item.name) Copy",
                icon: item.icon,
                description: "\(item.description) (Copy)"
            )
            listItems.append(duplicate)
        }
        selection.removeAll()
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
            
            Text("Lists, tables, and collection views for displaying structured data")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    NavigationStack {
        ListsCollectionsDemoView()
    }
}
