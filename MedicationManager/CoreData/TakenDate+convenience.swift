//
//  TakenDate+convenience.swift
//  MedicationManager
//
//  Created by Andrew Acton on 1/7/23.
//

import CoreData

extension TakenDate {
    @discardableResult convenience init(date: Date, medication: Medication, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.date = date
        self.medication = medication
    }
}
