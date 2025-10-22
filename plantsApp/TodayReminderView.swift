//
//  TodayReminderView.swift
//  plantsApp
//
//  Created by Rana on 30/04/1447 AH.
//

import SwiftUI

// =====================================================
// TodayReminderView.swift
// السلوك:
//  - زر +  ➜ يفتح الشيت بوضع الإضافة (بدون حذف)
//  - الضغط على اسم النبتة ➜ يفتح الشيت بوضع التعديل (مع حذف)
//  - الضغط على الدائرة ➜ تشيك + تحديث progress bar
// الألوان المستخدمة: APP_BG / APP_GREEN / APP_YELLOW / APP_BLUE (موجودة عندك)
// =====================================================

struct PlantItem: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var room: String
    var light: String
    var wateringDays: String = "Every day"   // بيانات للحفظ فقط
    var waterAmount: String
    var isWatered: Bool = false
}

struct TodayReminderView: View {
    // بيانات تجريبية
    @State private var plants: [PlantItem] = [
        .init(name: "Monstera", room: "Kitchen",     light: "Full sun", wateringDays: "Every day", waterAmount: "20-50 ml"),
        .init(name: "Pothos",   room: "Bedroom",     light: "Full sun", wateringDays: "Every day", waterAmount: "20-50 ml"),
        .init(name: "Orchid",   room: "Living Room", light: "Full sun", wateringDays: "Every day", waterAmount: "20-50 ml"),
        .init(name: "Spider",   room: "Kitchen",     light: "Full sun", wateringDays: "Every day", waterAmount: "20-50 ml")
    ]

    // حالات الشيتين + الدرافـت
    @State private var showAddSheet  = false
    @State private var showEditSheet = false
    @State private var editingIndex: Int? = nil

    @State private var draftName = ""
    @State private var draftRoom = "Bedroom"
    @State private var draftLight = "Full sun"
    @State private var draftWatering = "Every day"
    @State private var draftAmount = "20-50 ml"

    // نسبة التقدّم
    private var progress: Double {
        guard !plants.isEmpty else { return 0 }
        let done = plants.filter { $0.isWatered }.count
        return Double(done) / Double(plants.count)
    }

    var body: some View {
        ZStack {
            APP_BG.ignoresSafeArea()

            VStack(spacing: 0) {
                headerView()
                progressHeader()
                listSection()
            }

            addButton()
        }
        // شيت الإضافة (بدون حذف)
        .sheet(isPresented: $showAddSheet) {
            EditReminderView(
                showSheet: $showAddSheet,
                mode: .add,
                onSave: { name, room, light, watering, amount in
                    plants.append(
                        PlantItem(name: name,
                                  room: room,
                                  light: light,
                                  wateringDays: watering,
                                  waterAmount: amount,
                                  isWatered: false)
                    )
                },
                onDelete: nil, // غير مستخدم في وضع الإضافة
                plantName: draftName,
                room:      draftRoom,
                light:     draftLight,
                watering:  draftWatering,
                amount:    draftAmount
            )
            .preferredColorScheme(.dark)
        }
        // شيت التعديل (مع حذف)
        .sheet(isPresented: $showEditSheet) {
            EditReminderView(
                showSheet: $showEditSheet,
                mode: .edit,
                onSave: { name, room, light, watering, amount in
                    if let i = editingIndex {
                        plants[i].name         = name
                        plants[i].room         = room
                        plants[i].light        = light
                        plants[i].wateringDays = watering
                        plants[i].waterAmount  = amount
                    }
                },
                onDelete: {
                    if let i = editingIndex {
                        plants.remove(at: i)
                    }
                },
                plantName: draftName,
                room:      draftRoom,
                light:     draftLight,
                watering:  draftWatering,
                amount:    draftAmount
            )
            .preferredColorScheme(.dark)
        }
    }

    // MARK: - UI Parts

    private func headerView() -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                Text("My Plants")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(.white)
                Text("🌱").font(.system(size: 28))
                Spacer()
            }
            .padding(.top, 16)
            .padding(.horizontal, 24)

            Rectangle()
                .fill(.white.opacity(0.2))
                .frame(height: 1)
                .padding(.top, 12)
                .padding(.horizontal, 24)
        }
    }

    private func progressHeader() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            if progress == 0 {
                Text("Your plants are waiting for a sip 💦")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.9))
                customProgressBar(progress: 0)
            } else {
                let doneCount = Int(progress * Double(plants.count))
                Text("\(doneCount) of your plants feel loved today✨")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.9))
                customProgressBar(progress: progress)
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 14)
    }

    private func customProgressBar(progress: Double) -> some View {
        GeometryReader { proxy in
            let barWidth = proxy.size.width * 0.85
            ZStack(alignment: .leading) {
                Capsule().fill(Color.white.opacity(0.15)).frame(height: 6)
                if progress > 0 {
                    Capsule()
                        .fill(APP_GREEN)
                        .frame(width: barWidth * progress, height: 6)
                        .animation(.easeInOut(duration: 0.35), value: progress)
                }
            }
            .frame(width: barWidth, alignment: .leading)
            .padding(.top, 2)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: 10)
    }

    private func listSection() -> some View {
        List {
            Section(header:
                Text("Today")
                    .foregroundStyle(.white)
                    .font(.system(size: 16, weight: .semibold))
            ) {
                ForEach(Array(plants.enumerated()), id: \.element.id) { index, plant in
                    plantRow(plant, index: index)
                        .listRowBackground(APP_BG)
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    private func plantRow(_ plant: PlantItem, index: Int) -> some View {
        HStack(alignment: .top, spacing: 12) {
            // دائرة التشيك
            Button {
                plants[index].isWatered.toggle() // يحدّث progress تلقائيًا
            } label: {
                Image(systemName: plant.isWatered ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(plant.isWatered ? APP_GREEN : .white.opacity(0.9))
            }

            VStack(alignment: .leading, spacing: 6) {
                // المكان
                HStack(spacing: 6) {
                    Image(systemName: "location")
                        .font(.system(size: 11, weight: .semibold))
                    Text("in \(plant.room)")
                }
                .font(.system(size: 12))
                .foregroundStyle(.white.opacity(0.55))

                // اسم النبتة ➜ يفتح التعديل
                Button {
                    editingIndex  = index
                    draftName     = plant.name
                    draftRoom     = plant.room
                    draftLight    = plant.light
                    draftWatering = plant.wateringDays
                    draftAmount   = plant.waterAmount
                    showEditSheet = true
                } label: {
                    Text(plant.name)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(.white)
                }
                .buttonStyle(.plain)

                // البادجز (خلفية داكنة والنص/الأيقونة ملوّنة)
                HStack(spacing: 8) {
                    badge(icon: "sun.max", text: plant.light, tint: APP_YELLOW)
                    badge(icon: "drop",    text: plant.waterAmount, tint: APP_BLUE)
                }
            }
            Spacer()
        }
        .padding(.vertical, 12)
    }

    private func badge(icon: String, text: String, tint: Color) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .semibold))
            Text(text)
                .font(.system(size: 12, weight: .medium))
        }
        .foregroundStyle(tint) // يلوّن النص والأيقونة
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.white.opacity(0.12)) // خلفية داكنة ثابتة
        )
    }

    private func addButton() -> some View {
        VStack { Spacer()
            HStack { Spacer()
                Button {
                    // وضع إضافة
                    editingIndex  = nil
                    draftName     = ""
                    draftRoom     = "Bedroom"
                    draftLight    = "Full sun"
                    draftWatering = "Every day"
                    draftAmount   = "20-50 ml"
                    showAddSheet  = true
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 25, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 54, height: 54)
                        .background(Circle().fill(APP_GREEN))
                        .overlay(Circle().stroke(.white.opacity(0.50), lineWidth: 1))
                        .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 6)
                }
                .glassEffect(.clear)
                .padding(.trailing, 20)
                .padding(.bottom, 28)
            }
        }
    }
}

// معاينة
#Preview {
    TodayReminderView()
        .preferredColorScheme(.dark)
}
