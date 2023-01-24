//
//  MedicationController.swift
//  MedicationManager
//
//  Created by Andrew Acton on 12/31/22.
//

import CoreData

class MedicationController {
    
    //Shared Instance
    static let shared = MedicationController()
    let notificationScheduler = NotificationScheduler()
    
    private init() {}
    
    private lazy var fetchRequest: NSFetchRequest<Medication> = {
        let request = NSFetchRequest<Medication>(entityName: Strings.medicationEntityType)
        request.predicate = NSPredicate(value: true)
        return request
    }()
    
    private var takenMeds: [Medication] = []
    private var notTakenMeds: [Medication] = []
    var sections: [[Medication]] { [notTakenMeds, takenMeds] }
    
    //CRUD
    
    func create(name: String, timeOfDay: Date) {
        //Create Medication
        let medication = Medication(name: name, timeOfDay: timeOfDay)
        notTakenMeds.append(medication)
        CoreDataStack.saveContext()
        
        //Create Notification
        notificationScheduler.schedueleNotifications(for: medication)
    }
    
    func fetchMedications() {
        let medications = (try? CoreDataStack.context.fetch(self.fetchRequest)) ?? []
        
        takenMeds = medications.filter { $0.wasTakenToday() }
        notTakenMeds = medications.filter { !$0.wasTakenToday() }
    }
    
    func updateMedication(medication: Medication, name: String, timeOfDay: Date) {
        //Update Notification
        medication.name = name
        medication.timeOfDay = timeOfDay
        CoreDataStack.saveContext()
        //Clear Old Notifications
        notificationScheduler.cancelNotifications(for: medication)
        //Add New Notifications
        notificationScheduler.schedueleNotifications(for: medication)
    }
    
    func markMedicationTaken(medication: Medication, wasTaken: Bool) {
        if wasTaken {
            TakenDate(date: Date(), medication: medication)
            if let index = notTakenMeds.firstIndex(of: medication) {
                notTakenMeds.remove(at: index)
                takenMeds.append(medication)
            }
        } else {
            let mutableTakenDates = medication.mutableSetValue(forKey: Strings.takenDatesKey)
            
            if let takenDate = (mutableTakenDates as? Set<TakenDate>)?.first(where: { takenDate in guard let date = takenDate.date else { return false }
                return Calendar.current.isDate(date, inSameDayAs: Date())
            }) {
                mutableTakenDates.remove(takenDate)
                if let index = takenMeds.firstIndex(of: medication) {
                    takenMeds.remove(at: index)
                    notTakenMeds.append(medication)
                }
            }
        }
        CoreDataStack.saveContext()
    }
    
    func markMedicationTaken(withID id: String) {
        guard let medication = notTakenMeds.first(where: { $0.id == id }) else { return }
        markMedicationTaken(medication: medication, wasTaken: true)
    }
    
    func deleteMedication(_ medication: Medication) {
        //Delete Medication
        if let index = notTakenMeds.firstIndex(of: medication) {
            notTakenMeds.remove(at: index)
        } else if let index = takenMeds.firstIndex(of: medication) {
            takenMeds.remove(at: index)
        }
        
        CoreDataStack.context.delete(medication)
        CoreDataStack.saveContext()
        //Remove Notifications
        notificationScheduler.cancelNotifications(for: medication)
    }
    
}
