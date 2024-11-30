//
//  Event.swift
//  InnovaEventManagement
//
//  Created by Amitesh Mani Tiwari on 30/11/24.
//

struct Event {
    let id: String
    let name: String
    let description: String
    let date: String

    init(id: String, name: String, description: String, date: String) {
        self.id = id
        self.name = name
        self.description = description
        self.date = date
    }

    init(from dictionary: [String: Any], id: String) {
        self.id = id
        self.name = dictionary["name"] as? String ?? ""
        self.description = dictionary["description"] as? String ?? ""
        self.date = dictionary["date"] as? String ?? ""
    }

    func toDictionary() -> [String: Any] {
        return ["name": name, "description": description, "date": date]
    }
}
