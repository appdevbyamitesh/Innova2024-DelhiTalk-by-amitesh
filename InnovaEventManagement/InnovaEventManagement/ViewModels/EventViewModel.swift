//
//  EventViewModel.swift
//  InnovaEventManagement
//
//  Created by Amitesh Mani Tiwari on 30/11/24.
//

import FirebaseFirestore

class EventViewModel {
    private let db = Firestore.firestore()
    var events: [Event] = []
    var onEventsUpdated: (() -> Void)?

    func fetchEvents() {
        db.collection("events").addSnapshotListener { [weak self] snapshot, error in
            if let error = error {
                print("Error fetching events: \(error)")
                return
            }
            self?.events = snapshot?.documents.compactMap {
                Event(from: $0.data(), id: $0.documentID)
            } ?? []
            self?.onEventsUpdated?()
        }
    }

    func addEvent(name: String, description: String, date: String) {
        let newEvent = Event(id: UUID().uuidString, name: name, description: description, date: date)
        db.collection("events").addDocument(data: newEvent.toDictionary())
    }
    
}
