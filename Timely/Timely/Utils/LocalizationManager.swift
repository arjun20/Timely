//
//  LocalizationManager.swift
//  Timely
//
//  Created by Arjun Gautami on 07/09/25.
//

import Foundation

struct LocalizationManager {
    static let shared = LocalizationManager()
    
    private init() {}
    
    // MARK: - Localized Strings
    struct Strings {
        // MARK: - Onboarding
        static let onboardingTitle1 = NSLocalizedString("onboarding.title1", value: "Find Perfect Times", comment: "First onboarding screen title")
        static let onboardingDescription1 = NSLocalizedString("onboarding.description1", value: "Quickly discover when everyone is free to meet up", comment: "First onboarding screen description")
        
        static let onboardingTitle2 = NSLocalizedString("onboarding.title2", value: "Choose Activities", comment: "Second onboarding screen title")
        static let onboardingDescription2 = NSLocalizedString("onboarding.description2", value: "Pick from curated event cards or create your own", comment: "Second onboarding screen description")
        
        static let onboardingTitle3 = NSLocalizedString("onboarding.title3", value: "Confirm & Meet", comment: "Third onboarding screen title")
        static let onboardingDescription3 = NSLocalizedString("onboarding.description3", value: "Send invites and add events to everyone's calendar", comment: "Third onboarding screen description")
        
        // MARK: - Event Selection
        static let eventSelectionTitle = NSLocalizedString("event.selection.title", value: "What would you like to do?", comment: "Event selection screen title")
        static let eventSelectionSubtitle = NSLocalizedString("event.selection.subtitle", value: "Choose an activity and we'll find the perfect time for everyone", comment: "Event selection screen subtitle")
        static let findAvailableTimes = NSLocalizedString("event.find.times", value: "Find Available Times", comment: "Button to find available times")
        
        // MARK: - Time Selection
        static let timeSelectionTitle = NSLocalizedString("time.selection.title", value: "When works best for everyone?", comment: "Time selection screen title")
        static let selectDateRange = NSLocalizedString("time.select.date.range", value: "Select Date Range", comment: "Date range selection label")
        static let availableTimes = NSLocalizedString("time.available", value: "Available Times", comment: "Available times section title")
        static let confirmTime = NSLocalizedString("time.confirm", value: "Confirm Time", comment: "Confirm time button")
        
        // MARK: - Confirmation
        static let confirmEvent = NSLocalizedString("event.confirm", value: "Confirm Your Event", comment: "Event confirmation screen title")
        static let whoJoining = NSLocalizedString("event.who.joining", value: "Who's joining?", comment: "Attendees section title")
        static let createEvent = NSLocalizedString("event.create", value: "Create Event", comment: "Create event button")
        static let creatingEvent = NSLocalizedString("event.creating", value: "Creating Event...", comment: "Creating event button text")
        
        // MARK: - Success
        static let eventCreated = NSLocalizedString("event.created", value: "Event Created!", comment: "Event created success title")
        static let eventCreatedMessage = NSLocalizedString("event.created.message", value: "Your event has been added to everyone's calendar. Check your calendar app to see the details.", comment: "Event created success message")
        
        // MARK: - Empty States
        static let noAvailableTimes = NSLocalizedString("empty.no.times", value: "No Available Times", comment: "No available times title")
        static let noAvailableTimesMessage = NSLocalizedString("empty.no.times.message", value: "We couldn't find any free time slots for the selected date. Try a different day or expand your search range.", comment: "No available times message")
        static let tryTomorrow = NSLocalizedString("empty.try.tomorrow", value: "Try Tomorrow", comment: "Try tomorrow button")
        static let tryNextWeek = NSLocalizedString("empty.try.next.week", value: "Try Next Week", comment: "Try next week button")
        static let searchNext7Days = NSLocalizedString("empty.search.7.days", value: "Search Next 7 Days", comment: "Search next 7 days button")
        static let createCustomTime = NSLocalizedString("empty.create.custom", value: "Create Custom Time (2-3 PM)", comment: "Create custom time button")
        
        // MARK: - Settings
        static let settings = NSLocalizedString("settings.title", value: "Settings", comment: "Settings screen title")
        static let preferences = NSLocalizedString("settings.preferences", value: "Preferences", comment: "Preferences section title")
        static let hapticFeedback = NSLocalizedString("settings.haptic", value: "Haptic Feedback", comment: "Haptic feedback setting")
        static let animations = NSLocalizedString("settings.animations", value: "Animations", comment: "Animations setting")
        static let showEventHistory = NSLocalizedString("settings.event.history", value: "Show Event History", comment: "Show event history setting")
        static let workingHours = NSLocalizedString("settings.working.hours", value: "Working Hours", comment: "Working hours section title")
        static let startTime = NSLocalizedString("settings.start.time", value: "Start Time", comment: "Start time setting")
        static let endTime = NSLocalizedString("settings.end.time", value: "End Time", comment: "End time setting")
        static let defaultDuration = NSLocalizedString("settings.default.duration", value: "Default Event Duration", comment: "Default duration section title")
        static let about = NSLocalizedString("settings.about", value: "About", comment: "About section title")
        static let version = NSLocalizedString("settings.version", value: "Version", comment: "Version label")
        static let build = NSLocalizedString("settings.build", value: "Build", comment: "Build label")
        static let dataManagement = NSLocalizedString("settings.data.management", value: "Data Management", comment: "Data management section title")
        static let resetAllData = NSLocalizedString("settings.reset.data", value: "Reset All Data", comment: "Reset all data button")
        
        // MARK: - Errors
        static let error = NSLocalizedString("error.title", value: "Error", comment: "Error alert title")
        static let calendarAccessDenied = NSLocalizedString("error.calendar.access", value: "Calendar access is required to use Timely. Please enable it in Settings.", comment: "Calendar access denied error")
        static let calendarEventCreationFailed = NSLocalizedString("error.calendar.create", value: "Failed to create calendar event. Please try again.", comment: "Calendar event creation failed error")
        static let networkError = NSLocalizedString("error.network", value: "Network connection error. Please check your internet connection.", comment: "Network error")
        static let dataCorruption = NSLocalizedString("error.data.corruption", value: "Data corruption detected. Please restart the app.", comment: "Data corruption error")
        static let invalidInput = NSLocalizedString("error.invalid.input", value: "Invalid input provided. Please check your data and try again.", comment: "Invalid input error")
        static let unknownError = NSLocalizedString("error.unknown", value: "An unexpected error occurred.", comment: "Unknown error")
        
        // MARK: - Accessibility
        static let accessibilityProgressIndicator = NSLocalizedString("accessibility.progress", value: "Progress indicator", comment: "Progress indicator accessibility label")
        static let accessibilityLoading = NSLocalizedString("accessibility.loading", value: "Loading", comment: "Loading accessibility label")
        static let accessibilityButton = NSLocalizedString("accessibility.button", value: "Button", comment: "Button accessibility label")
        static let accessibilityTimeSlot = NSLocalizedString("accessibility.time.slot", value: "Time slot", comment: "Time slot accessibility label")
        static let accessibilityEventCard = NSLocalizedString("accessibility.event.card", value: "Event card", comment: "Event card accessibility label")
    }
}

// MARK: - Localization Extensions
extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(with arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }
}
