//
//  DisplayMediaDemoView.swift
//  macosshowcase
//
//  Created by Mengthong on 18/7/25.
//

import SwiftUI

struct DisplayMediaDemoView: View {
    @State private var asyncImageURL = "https://picsum.photos/200/150"
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                headerSection("Display & Media Components")
                
                textTypographySection
                visualEffectsSection
                shapesSection
                
                Spacer(minLength: 50)
            }
            .padding()
        }
        .navigationTitle("Display & Media")
    }
    
    private var textTypographySection: some View {
        demoSection("Text & Typography") {
            VStack(spacing: 20) {
                GroupBox("Text Styles") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Large Title")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Title")
                            .font(.title)
                            .fontWeight(.semibold)
                        
                        Text("Title 2")
                            .font(.title2)
                            .fontWeight(.medium)
                        
                        Text("Headline")
                            .font(.headline)
                        
                        Text("Body text with regular weight")
                            .font(.body)
                        
                        Text("Callout text")
                            .font(.callout)
                        
                        Text("Subheadline")
                            .font(.subheadline)
                        
                        Text("Caption text")
                            .font(.caption)
                        
                        Text("Caption 2 - smallest")
                            .font(.caption2)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                GroupBox("Text Formatting") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("**Bold text** and *italic text*")
                        
                        Text("Text with `monospace` font")
                            .font(.system(.body, design: .monospaced))
                        
                        Text("Colored text")
                            .foregroundColor(.blue)
                        
                        Text("Underlined text")
                            .underline()
                        
                        Text("Strikethrough text")
                            .strikethrough()
                        
                        Text("Multiple")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.purple)
                            .underline()
                        + Text(" combined")
                            .font(.body)
                            .foregroundColor(.green)
                        + Text(" styles")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                GroupBox("Labels & Images") {
                    VStack(spacing: 15) {
                        Label("System Image Label", systemImage: "star.fill")
                            .foregroundColor(.yellow)
                        
                        Label("Custom Styled Label", systemImage: "heart.fill")
                            .font(.headline)
                            .foregroundColor(.red)
                        
                        HStack(spacing: 20) {
                            Image(systemName: "swift")
                                .font(.system(size: 40))
                                .foregroundColor(.orange)
                            
                            Image(systemName: "apple.logo")
                                .font(.system(size: 40))
                                .foregroundColor(.black)
                        }
                        
                        AsyncImage(url: URL(string: asyncImageURL)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            ProgressView()
                                .frame(width: 50, height: 50)
                        }
                        .frame(width: 200, height: 150)
                        .background(Color(.controlBackgroundColor))
                        .cornerRadius(8)
                        
                        Text("AsyncImage loads remote images")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
    
    private var visualEffectsSection: some View {
        demoSection("Visual Effects") {
            VStack(spacing: 20) {
                GroupBox("Gradients") {
                    VStack(spacing: 15) {
                        HStack(spacing: 15) {
                            Rectangle()
                                .fill(LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .frame(width: 80, height: 80)
                                .cornerRadius(8)
                            
                            Circle()
                                .fill(RadialGradient(
                                    colors: [.yellow, .orange, .red],
                                    center: .center,
                                    startRadius: 10,
                                    endRadius: 40
                                ))
                                .frame(width: 80, height: 80)
                            
                            Rectangle()
                                .fill(AngularGradient(
                                    colors: [.red, .yellow, .green, .blue, .purple, .red],
                                    center: .center
                                ))
                                .frame(width: 80, height: 80)
                                .cornerRadius(8)
                        }
                        
                        Text("Linear, Radial, and Angular gradients")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                GroupBox("Shadows & Effects") {
                    VStack(spacing: 20) {
                        HStack(spacing: 20) {
                            Rectangle()
                                .fill(Color.blue)
                                .frame(width: 60, height: 60)
                                .cornerRadius(8)
                                .shadow(radius: 5)
                            
                            Rectangle()
                                .fill(Color.green)
                                .frame(width: 60, height: 60)
                                .cornerRadius(8)
                                .shadow(color: .green, radius: 10, x: 5, y: 5)
                            
                            Rectangle()
                                .fill(Color.purple)
                                .frame(width: 60, height: 60)
                                .cornerRadius(8)
                                .blur(radius: 2)
                        }
                        
                        Text("Basic shadow, colored shadow, and blur effect")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                GroupBox("Overlays & Backgrounds") {
                    VStack(spacing: 15) {
                        Rectangle()
                            .fill(Color.blue.opacity(0.3))
                            .frame(height: 80)
                            .background(
                                LinearGradient(
                                    colors: [.pink, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .overlay(
                                Text("Overlay Text")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            )
                            .cornerRadius(8)
                        
                        Text("Background and overlay combinations")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
    
    private var shapesSection: some View {
        demoSection("Shapes & Paths") {
            VStack(spacing: 20) {
                GroupBox("Basic Shapes") {
                    VStack(spacing: 15) {
                        HStack(spacing: 20) {
                            Rectangle()
                                .fill(Color.red)
                                .frame(width: 60, height: 60)
                            
                            Circle()
                                .fill(Color.green)
                                .frame(width: 60, height: 60)
                            
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.blue)
                                .frame(width: 60, height: 60)
                            
                            Capsule()
                                .fill(Color.orange)
                                .frame(width: 80, height: 40)
                            
                            Ellipse()
                                .fill(Color.purple)
                                .frame(width: 80, height: 60)
                        }
                        
                        Text("Rectangle, Circle, RoundedRectangle, Capsule, Ellipse")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                GroupBox("Custom Paths") {
                    VStack(spacing: 15) {
                        HStack(spacing: 20) {
                            // Triangle
                            Path { path in
                                path.move(to: CGPoint(x: 30, y: 0))
                                path.addLine(to: CGPoint(x: 60, y: 60))
                                path.addLine(to: CGPoint(x: 0, y: 60))
                                path.closeSubpath()
                            }
                            .fill(Color.red)
                            .frame(width: 60, height: 60)
                            
                            // Star
                            Path { path in
                                let center = CGPoint(x: 30, y: 30)
                                let outerRadius: CGFloat = 25
                                let innerRadius: CGFloat = 12
                                let points = 5
                                
                                for i in 0..<points * 2 {
                                    let angle = Double(i) * .pi / Double(points)
                                    let radius = i.isMultiple(of: 2) ? outerRadius : innerRadius
                                    let x = center.x + cos(angle - .pi/2) * radius
                                    let y = center.y + sin(angle - .pi/2) * radius
                                    
                                    if i == 0 {
                                        path.move(to: CGPoint(x: x, y: y))
                                    } else {
                                        path.addLine(to: CGPoint(x: x, y: y))
                                    }
                                }
                                path.closeSubpath()
                            }
                            .fill(Color.yellow)
                            .frame(width: 60, height: 60)
                            
                            // Heart
                            Path { path in
                                let width: CGFloat = 60
                                let height: CGFloat = 60
                                
                                path.move(to: CGPoint(x: width/2, y: height))
                                
                                path.addCurve(
                                    to: CGPoint(x: 0, y: height/4),
                                    control1: CGPoint(x: width/2, y: height*3/4),
                                    control2: CGPoint(x: 0, y: height/2)
                                )
                                
                                path.addArc(
                                    center: CGPoint(x: width/4, y: height/4),
                                    radius: width/4,
                                    startAngle: .radians(.pi),
                                    endAngle: .radians(0),
                                    clockwise: false
                                )
                                
                                path.addArc(
                                    center: CGPoint(x: width*3/4, y: height/4),
                                    radius: width/4,
                                    startAngle: .radians(.pi),
                                    endAngle: .radians(0),
                                    clockwise: false
                                )
                                
                                path.addCurve(
                                    to: CGPoint(x: width/2, y: height),
                                    control1: CGPoint(x: width, y: height/2),
                                    control2: CGPoint(x: width/2, y: height*3/4)
                                )
                            }
                            .fill(Color.pink)
                            .frame(width: 60, height: 60)
                        }
                        
                        Text("Custom paths: Triangle, Star, Heart")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                GroupBox("Strokes & Fills") {
                    VStack(spacing: 15) {
                        HStack(spacing: 20) {
                            Circle()
                                .stroke(Color.blue, lineWidth: 3)
                                .frame(width: 60, height: 60)
                            
                            Rectangle()
                                .stroke(Color.red, style: StrokeStyle(lineWidth: 2, dash: [5, 3]))
                                .frame(width: 60, height: 60)
                            
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(Color.green, lineWidth: 4)
                                .frame(width: 60, height: 60)
                        }
                        
                        Text("Stroke, dashed stroke, and stroke border")
                            .font(.caption)
                            .foregroundColor(.secondary)
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
            
            Text("Text, images, shapes, and visual effects for rich content display")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    NavigationStack {
        DisplayMediaDemoView()
    }
}
