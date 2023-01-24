//
//  NotificationScheduler.swift
//  MedicationManager
//
//  Created by Andrew Acton on 1/21/23.
//

import UserNotifications

class NotificationScheduler {
    
    func schedueleNotifications(for medication: Medication) {
        //ID
        guard let id = medication.id,
              !id.isEmpty
        else { return }
        //Content
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "It's time to take your \(medication.name ?? "")"
        content.sound = .default
        content.userInfo = [Strings.medicationID : id]
        content.categoryIdentifier = Strings.notificationCategoryIdentifier
        //Date
        let fireDateComponents = Calendar.current.dateComponents([.hour, .minute], from: medication.timeOfDay ?? Date())
        //Trigger
        let trigger = UNCalendarNotificationTrigger(dateMatching: fireDateComponents, repeats: true)
        //Request
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Unable to schedule notifications request: \(error.localizedDescription)")
            }
        }
    }
    
    func cancelNotifications(for medication: Medication) {
        guard let id = medication.id else { return }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
    
}
