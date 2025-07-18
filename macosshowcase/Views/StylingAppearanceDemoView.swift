//
//  StylingAppearanceDemoView.swift
//  macosshowcase
//
//  Created by Mengthong on 18/7/25.
//

import SwiftUI

struct StylingAppearanceDemoView: View {
    @State private var animationOffset: CGFloat = 0
    @State private var rotationAngle: Double = 0
    @State private var scaleAmount: CGFloat = 1.0
    @State private var showingTransition = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                headerSection("Styling & Appearance")
                
                modifiersSection
                animationSection
                
                Spacer(minLength: 50)
            }
            .padding()
        }
        .navigationTitle("Styling & Appearance")
    }
    
    private var modifiersSection: some View {
        demoSection("Styling Modifiers") {
            VStack(spacing: 20) {
                GroupBox("Frame & Padding") {
                    VStack(spacing: 15) {
                        HStack(spacing: 15) {
                            Text("Default")
                                .background(Color.blue.opacity(0.3))
                            
                            Text("Padded")
                                .padding()
                                .background(Color.green.opacity(0.3))
                            
                            Text("Framed")
                                .frame(width: 80, height: 40)
                                .background(Color.red.opacity(0.3))
                        }
                        
                        Text("Frame and padding modifiers")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                GroupBox("Colors & Backgrounds") {
                    VStack(spacing: 15) {
                        HStack(spacing: 15) {
                            Text("Primary")
                                .foregroundColor(.primary)
                                .padding()
                                .background(Color.secondary.opacity(0.2))
                                .cornerRadius(8)
                            
                            Text("Accent")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.accentColor)
                                .cornerRadius(8)
                            
                            Text("Custom")
                                .foregroundColor(.white)
                                .padding()
                                .background(LinearGradient(colors: [.purple, .pink], startPoint: .leading, endPoint: .trailing))
                                .cornerRadius(8)
                        }
                        
                        Text("Foreground colors and background styling")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
    
    private var animationSection: some View {
        demoSection("Animations & Transitions") {
            VStack(spacing: 20) {
                GroupBox("Implicit Animations") {
                    VStack(spacing: 20) {
                        HStack(spacing: 30) {
                            // Offset animation
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 40, height: 40)
                                .offset(y: animationOffset)
                                .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: animationOffset)
                            
                            // Rotation animation
                            Rectangle()
                                .fill(Color.green)
                                .frame(width: 40, height: 40)
                                .rotationEffect(.degrees(rotationAngle))
                                .animation(.linear(duration: 2).repeatForever(autoreverses: false), value: rotationAngle)
                            
                            // Scale animation
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.orange)
                                .frame(width: 40, height: 40)
                                .scaleEffect(scaleAmount)
                                .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: scaleAmount)
                        }
                        
                        Button("Start Animations") {
                            animationOffset = -30
                            rotationAngle = 360
                            scaleAmount = 1.5
                        }
                    }
                }
                
                GroupBox("Transitions") {
                    VStack(spacing: 15) {
                        Button("Toggle Transition") {
                            withAnimation(.spring()) {
                                showingTransition.toggle()
                            }
                        }
                        
                        if showingTransition {
                            HStack(spacing: 15) {
                                Rectangle()
                                    .fill(Color.red)
                                    .frame(width: 50, height: 50)
                                    .transition(.slide)
                                
                                Rectangle()
                                    .fill(Color.blue)
                                    .frame(width: 50, height: 50)
                                    .transition(.scale)
                                
                                Rectangle()
                                    .fill(Color.green)
                                    .frame(width: 50, height: 50)
                                    .transition(.opacity)
                            }
                        }
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
            
            Text("Styling modifiers, animations, and visual appearance customization")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    NavigationStack {
        StylingAppearanceDemoView()
    }
}
