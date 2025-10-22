//
//  ContentView.swift
//  plantsApp
//
//  Created by Rana on 24/04/1447 AH.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        PlantOnboardingView()
    }
}

struct PlantOnboardingView: View {
    // ⬅️ إضافة: حالة لإظهار الشيت
    @State private var showSetReminder = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header Section
                HeaderView()
                
                Spacer(minLength: 10)
                
                // Content Section
                ContentSection()
                
                Spacer()
            }
            .safeAreaInset(edge: .bottom) {
                // ⬅️ تعديل بسيط: نمرّر أكشن لفتح الشيت
                ReminderButton {
                    showSetReminder = true
                }
            }
        }
        // ⬅️ الشيت نفسه (بإنحناء، مو شاشة كاملة)
        .sheet(isPresented: $showSetReminder) {
            SetReminderView(showSheet: $showSetReminder)
                .preferredColorScheme(.dark)
                .presentationDetents([.fraction(0.99)]) // ارتفاع قريب من الصورة
                .presentationCornerRadius(28)           // الانحناء العلوي
                .presentationDragIndicator(.visible)
        }
    }
}

// MARK: - Header View
struct HeaderView: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                Text("My Plants")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(.white)
                
                Text("🌱")
                    .font(.system(size: 28))
                
                Spacer()
            }
            .padding(.top, 16)
            .padding(.horizontal, 24)
            
            // Divider Line
            Rectangle()
                .fill(Color.white.opacity(0.20))
                .frame(height: 1)
                .padding(.top, 12)
                .padding(.horizontal, 24)
        }
    }
}

// MARK: - Content Section
struct ContentSection: View {
    var body: some View {
        VStack(spacing: 18) {
            // Plant Image
            Image("plant_image")
                .resizable()
                .scaledToFit()
                .frame(width: 210, height: 210)
                .clipped()
                .padding(.top, 30)
            
            // Title
            Text("Start your plant journey!")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
            
            // Description
            Text("Now all your plants will be in one place and we will help you take care of them :) 🪴")
                .font(.system(size: 16))
                .foregroundStyle(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .lineSpacing(6)
                .frame(width: 315)
        }
        .padding(.bottom, 70)
    }
}

// MARK: - Reminder Button
struct ReminderButton: View {
    // ⬅️ إضافة بسيطة: نخلي الزر يستقبل أكشن من برّا (افتراضيًا لا شيء)
    var onTap: () -> Void = {}

    var body: some View {
        Button(action: onTap) { // ⬅️ بدل "Action here"
            Text("Set Plant Reminder")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 280, height: 44)
                .background(
                    LinearGradient(
                        colors: [
                            Color(red: 0.34, green: 0.82, blue: 0.54),
                            Color(red: 0.22, green: 0.79, blue: 0.54)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 4)
        }
        .glassEffect(.clear) // لو ما عندك هذا الموديڤاير، احذفي السطر
        .padding(.bottom, 100)
    }
}

#Preview {
    ContentView()
}

