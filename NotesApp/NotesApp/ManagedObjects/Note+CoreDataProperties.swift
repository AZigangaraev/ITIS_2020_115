//
//  Note+CoreDataProperties.swift
//  NotesApp
//
//  Created by Teacher on 14.12.2020.
//
//

import Foundation
import CoreData


extension Note {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Note> {
        let fetchRequest = NSFetchRequest<Note>(entityName: "Note")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \Note.dateModified, ascending: true)
        ]
        return fetchRequest
    }

    @NSManaged public var title: String?
    @NSManaged public var text: String?
    @NSManaged public var dateModified: Date?
}

extension Note : Identifiable {
}
