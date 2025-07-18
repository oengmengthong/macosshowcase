//
//  DemoNavigationView.swift
//  macosshowcase
//
//  Created by Mengthong on 18/7/25.
//

import SwiftUI

enum DemoCategory: String, CaseIterable, Identifiable {
    case layoutNavigation = "Layout & Navigation"
    case controlsInput = "Controls & Input"
    case listsCollections = "Lists & Collections"
    case macosSpecific = "macOS Specific"
    case displayMedia = "Display & Media"
    case stylingAppearance = "Styling & Appearance"
    case dataState = "Data & State"
    case systemIntegration = "System Integration"
    case advanced = "Advanced Features"
    case videoPlayer = "VideoPlayer"
    case charts = "Charts & Visualization"
    case animations = "Advanced Animations"
    case gestures = "Gesture Recognizers"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .layoutNavigation: return "rectangle.3.group"
        case .controlsInput: return "keyboard"
        case .listsCollections: return "list.bullet"
        case .macosSpecific: return "macwindow"
        case .displayMedia: return "photo"
        case .stylingAppearance: return "paintbrush"
        case .dataState: return "cylinder"
        case .systemIntegration: return "gear"
        case .advanced: return "star"
        case .videoPlayer: return "play.rectangle"
        case .charts: return "chart.bar"
        case .animations: return "wand.and.stars"
        case .gestures: return "hand.draw"
        }
    }
}

struct DemoNavigationView: View {
    @State private var selectedCategory: DemoCategory? = .layoutNavigation
    
    var body: some View {
        NavigationSplitView {
            List(DemoCategory.allCases, selection: $selectedCategory) { category in
                Label(category.rawValue, systemImage: category.icon)
                    .tag(category)
            }
            .navigationTitle("macOS Showcase")
            .navigationSplitViewColumnWidth(min: 200, ideal: 250)
        } detail: {
            if let selectedCategory = selectedCategory {
                demoView(for: selectedCategory)
            } else {
                Text("Select a demo category")
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    @ViewBuilder
    private func demoView(for category: DemoCategory) -> some View {
        switch category {
        case .layoutNavigation:
            LayoutNavigationDemoView()
        case .controlsInput:
            ControlsInputDemoView()
        case .listsCollections:
            ListsCollectionsDemoView()
        case .macosSpecific:
            MacOSSpecificDemoView()
        case .displayMedia:
            DisplayMediaDemoView()
        case .stylingAppearance:
            StylingAppearanceDemoView()
        case .dataState:
            DataStateDemoView()
        case .systemIntegration:
            SystemIntegrationDemoView()
        case .advanced:
            AdvancedFeaturesDemoView()
        case .videoPlayer:
            VideoPlayerDemoView()
        case .charts:
            ChartsVisualizationDemoView()
        case .animations:
            AdvancedAnimationsDemoView()
        case .gestures:
            GestureRecognizersDemoView()
        }
    }
}

#Preview {
    DemoNavigationView()
}
