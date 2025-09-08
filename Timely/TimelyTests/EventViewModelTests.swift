//
//  EventViewModelTests.swift
//  TimelyTests
//
//  Created by Arjun Gautami on 07/09/25.
//

import XCTest
@testable import Timely

@MainActor
final class EventViewModelTests: XCTestCase {
    var viewModel: EventViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = EventViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertTrue(viewModel.events.isEmpty)
        XCTAssertTrue(viewModel.eventCards.isEmpty)
        XCTAssertNil(viewModel.selectedEventCard)
        XCTAssertTrue(viewModel.availableTimeSlots.isEmpty)
        XCTAssertNil(viewModel.selectedTimeSlot)
        XCTAssertTrue(viewModel.attendees.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testSelectEventCard() {
        let eventCard = EventCard(
            id: "test",
            title: "Test Event",
            description: "Test Description",
            category: "Test",
            estimatedDuration: 60
        )
        
        viewModel.selectEventCard(eventCard)
        
        XCTAssertEqual(viewModel.selectedEventCard?.id, eventCard.id)
        XCTAssertEqual(viewModel.selectedEventCard?.title, eventCard.title)
    }
    
    func testSelectTimeSlot() {
        let timeSlot = TimeSlot(
            startTime: Date(),
            endTime: Date().addingTimeInterval(3600)
        )
        
        viewModel.selectTimeSlot(timeSlot)
        
        XCTAssertEqual(viewModel.selectedTimeSlot?.id, timeSlot.id)
        XCTAssertEqual(viewModel.selectedTimeSlot?.startTime, timeSlot.startTime)
        XCTAssertEqual(viewModel.selectedTimeSlot?.endTime, timeSlot.endTime)
    }
    
    func testWorkingHours() {
        let workingHours = viewModel.getWorkingHours()
        
        XCTAssertEqual(workingHours.start, 9)
        XCTAssertEqual(workingHours.end, 18)
    }
    
    func testTimeSlotGeneration() {
        let startDate = Date()
        let endDate = startDate.addingTimeInterval(24 * 60 * 60) // 1 day
        let dateRange = DateInterval(start: startDate, end: endDate)
        let workingHours = (start: 9, end: 18)
        let duration = 60
        
        let timeSlots = viewModel.generateTimeSlots(
            for: dateRange,
            workingHours: workingHours,
            duration: duration
        )
        
        XCTAssertFalse(timeSlots.isEmpty)
        
        // Check that all time slots are within working hours
        for slot in timeSlots {
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: slot.startTime)
            XCTAssertGreaterThanOrEqual(hour, workingHours.start)
            XCTAssertLessThan(hour, workingHours.end)
        }
    }
}

// MARK: - Helper Methods for Testing
extension EventViewModel {
    func getWorkingHours() -> (start: Int, end: Int) {
        return (start: 9, end: 18)
    }
    
    func generateTimeSlots(
        for dateRange: DateInterval,
        workingHours: (start: Int, end: Int),
        duration: Int
    ) -> [TimeSlot] {
        var slots: [TimeSlot] = []
        let calendar = Calendar.current
        
        var currentDate = dateRange.start
        while currentDate < dateRange.end {
            let startOfDay = calendar.startOfDay(for: currentDate)
            let startHour = calendar.date(byAdding: .hour, value: workingHours.start, to: startOfDay)!
            let endHour = calendar.date(byAdding: .hour, value: workingHours.end, to: startOfDay)!
            
            var slotStart = startHour
            while slotStart < endHour {
                let slotEnd = calendar.date(byAdding: .minute, value: duration, to: slotStart)!
                
                if slotEnd <= endHour {
                    slots.append(TimeSlot(startTime: slotStart, endTime: slotEnd))
                }
                
                slotStart = calendar.date(byAdding: .minute, value: 15, to: slotStart)!
            }
            
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return slots
    }
}
