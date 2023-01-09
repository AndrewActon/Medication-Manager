//
//  MoodSurvey + convenience.swift
//  MedicationManager
//
//  Created by Andrew Acton on 1/7/23.
//

import CoreData

extension MoodSurvey {
    @discardableResult convenience init(mentalState: String, date: Date, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.mentalState = mentalState
        self.date = date
    }
}
