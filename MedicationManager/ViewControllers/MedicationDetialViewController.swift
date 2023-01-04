//
//  MedicationDetialViewController.swift
//  MedicationManager
//
//  Created by Andrew Acton on 12/31/22.
//

import UIKit

class MedicationDetialViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var medication: Medication?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let medication = medication,
           let timeOfDay = medication.timeOfDay {
            title = "Medicaion Details"
            nameTextField.text = medication.name
            datePicker.date = timeOfDay
        } else {
            title = "Add Medicaion"
        }
        
        
    }
    
    //MARK: - Actions
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let name = nameTextField.text,
              !name.isEmpty
        else { return }
        
        let timeOfDay = datePicker.date
        
        if let medication = medication {
            MedicationController.shared.updateMedication(medication: medication, name: name, timeOfDay: timeOfDay)
        } else {
            MedicationController.shared.create(name: name, timeOfDay: timeOfDay)
        }
        
        navigationController?.popViewController(animated: true)
    }


}
