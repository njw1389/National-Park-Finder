//
//  AboutPage.swift
//  NPF-4
//
//  Created by Nolan Wira on 11/5/24.
//

import SwiftUI

struct AboutPage: View {
    @State private var animate = false
    @State private var mountainOffset: CGFloat = 800
    @State private var sunPosition = false
    @State private var cloudOffset1: CGFloat = -200
    @State private var cloudOffset2: CGFloat = 400
    @State private var treeScale: CGFloat = 0.5
    
    var body: some View {
        ZStack {
            // Sky gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.4, green: 0.6, blue: 0.9),
                    Color(red: 0.6, green: 0.8, blue: 1.0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Sun
            Circle()
                .fill(Color.yellow)
                .frame(width: 100, height: 100)
                .offset(y: sunPosition ? -200 : 200)
                .opacity(0.8)
                .blur(radius: 20)
                .animation(.easeInOut(duration: 4).repeatForever(autoreverses: true), value: sunPosition)
            
            // Clouds
            Group {
                Cloud()
                    .offset(x: cloudOffset1)
                    .animation(.linear(duration: 15).repeatForever(autoreverses: false), value: cloudOffset1)
                
                Cloud()
                    .offset(x: cloudOffset2, y: 100)
                    .animation(.linear(duration: 20).repeatForever(autoreverses: false), value: cloudOffset2)
            }
            
            // Mountains
            Group {
                // Back mountain
                Triangle()
                    .fill(Color.gray.opacity(0.8))
                    .frame(width: 300, height: 200)
                    .offset(y: mountainOffset + 100)
                
                // Front mountain
                Triangle()
                    .fill(Color.gray.opacity(0.9))
                    .frame(width: 250, height: 180)
                    .offset(x: 50, y: mountainOffset + 120)
            }
            .animation(.spring(dampingFraction: 0.6).delay(0.3), value: mountainOffset)
            
            // Content
            VStack(spacing: 20) {
                Text("National Park Finder")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(radius: 2)
                
                Text("BY: Nolan Wira")
                    .font(.title2)
                    .foregroundColor(.white)
                    .shadow(radius: 2)
                
                Text("A Class Project For\nMobile Application Development I")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .shadow(radius: 2)
            }
            .scaleEffect(animate ? 1 : 0.5)
            .opacity(animate ? 1 : 0)
            .animation(.spring(dampingFraction: 0.6).delay(0.5), value: animate)
        }
        .onAppear {
            // Start animations
            sunPosition.toggle()
            mountainOffset = 200
            cloudOffset1 = 400
            cloudOffset2 = -400
            animate = true
        }
    }
}

// Helper shapes
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct Cloud: View {
    var body: some View {
        HStack(spacing: -15) {
            Circle()
                .fill(.white.opacity(0.8))
                .frame(width: 40, height: 40)
            Circle()
                .fill(.white.opacity(0.8))
                .frame(width: 50, height: 50)
            Circle()
                .fill(.white.opacity(0.8))
                .frame(width: 40, height: 40)
        }
    }
}

#Preview {
    AboutPage()
}
