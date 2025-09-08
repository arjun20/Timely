//
//  SettingsView.swift
//  Timely
//
//  Created by Arjun Gautami on 07/09/25.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var userDefaultsManager = UserDefaultsManager.shared
    @State private var preferences = UserPreferences()
    @State private var showingResetAlert = false
    
    var body: some View {
        NavigationView {
            List {
                // MARK: - Preferences Section
                Section("Preferences") {
                    Toggle("Haptic Feedback", isOn: $preferences.enableHapticFeedback)
                        .onChange(of: preferences.enableHapticFeedback) { _, newValue in
                            savePreferences()
                        }
                    
                    Toggle("Animations", isOn: $preferences.enableAnimations)
                        .onChange(of: preferences.enableAnimations) { _, newValue in
                            savePreferences()
                        }
                    
                    Toggle("Show Event History", isOn: $preferences.showEventHistory)
                        .onChange(of: preferences.showEventHistory) { _, newValue in
                            savePreferences()
                        }
                }
                
                // MARK: - Working Hours Section
                Section("Working Hours") {
                    HStack {
                        Text("Start Time")
                        Spacer()
                        Picker("Start Time", selection: Binding(
                            get: { preferences.workingHours.start },
                            set: { preferences.workingHours.start = $0 }
                        )) {
                            ForEach(6...12, id: \.self) { hour in
                                Text("\(hour):00 AM").tag(hour)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    
                    HStack {
                        Text("End Time")
                        Spacer()
                        Picker("End Time", selection: Binding(
                            get: { preferences.workingHours.end },
                            set: { preferences.workingHours.end = $0 }
                        )) {
                            ForEach(13...22, id: \.self) { hour in
                                Text("\(hour - 12):00 PM").tag(hour)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                }
                
                // MARK: - Default Duration Section
                Section("Default Event Duration") {
                    Picker("Duration", selection: $preferences.defaultEventDuration) {
                        Text("30 minutes").tag(30)
                        Text("1 hour").tag(60)
                        Text("1.5 hours").tag(90)
                        Text("2 hours").tag(120)
                        Text("3 hours").tag(180)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                // MARK: - About Section
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Build")
                        Spacer()
                        Text("1")
                            .foregroundColor(.secondary)
                    }
                }
                
                // MARK: - Data Management Section
                Section("Data Management") {
                    Button("Reset All Data") {
                        showingResetAlert = true
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Settings")
            .onAppear {
                loadPreferences()
            }
            .alert("Reset All Data", isPresented: $showingResetAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    resetAllData()
                }
            } message: {
                Text("This will delete all your preferences and event history. This action cannot be undone.")
            }
        }
    }
    
    private func loadPreferences() {
        preferences = userDefaultsManager.getUserPreferences()
    }
    
    private func savePreferences() {
        userDefaultsManager.saveUserPreferences(preferences)
    }
    
    private func resetAllData() {
        userDefaultsManager.resetAllData()
        preferences = UserPreferences()
    }
}

#Preview {
    SettingsView()
}
