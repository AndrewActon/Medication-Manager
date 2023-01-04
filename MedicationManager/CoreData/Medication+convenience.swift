//
//  Medication+convenience.swift
//  MedicationManager
//
//  Created by Andrew Acton on 12/31/22.
//

import CoreData

extension Medication {
    @discardableResult convenience init(name: String, timeOfDay: Date, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.name = name
        self.timeOfDay = timeOfDay
    }
    
    
}
