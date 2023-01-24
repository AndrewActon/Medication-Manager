//
//  MedicationListViewController.swift
//  MedicationManager
//
//  Created by Andrew Acton on 12/31/22.
//

import UIKit

class MedicationListViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var moodSurveyButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MedicationController.shared.fetchMedications()
        guard let survey = MoodSurveyController.shared.fetchSurveys() else { return }
        
        moodSurveyButton.setTitle(survey.mentalState, for: .normal)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reminderFired),
                                               name: NSNotification.Name(Strings.medicationReminderReceived),
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    //MARK: - Actions
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
    }
    @IBAction func surveyButtonTapped(_ sender: UIButton) {
        guard let moodSurveyViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Strings.moodSurveyViewControllerIdentifier) as? MoodSurveyViewController else { return }
        
        moodSurveyViewController.delegate = self
        navigationController?.present(moodSurveyViewController, animated: true, completion: nil)
    }

    @objc private func reminderFired() {
        print("\(#file) received the Memo!")
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Strings.medicationDetialsSegueIdentifier,
           let indexPath = tableView.indexPathForSelectedRow,
           let destination = segue.destination as? MedicationDetialViewController {
            let medication = MedicationController.shared.sections[indexPath.section][indexPath.row]
            destination.medication = medication
        } 
    }
    
}

extension MedicationListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return MedicationController.shared.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        MedicationController.shared.sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "medicationCell", for: indexPath) as? MedicationTableViewCell else { return UITableViewCell() }
        
        let medication = MedicationController.shared.sections[indexPath.section][indexPath.row]
        
        cell.configure(medication: medication)
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Not Taken"
        } else if section  == 1 {
            return "Taken"
        } else {
            return nil
        }
    }
    
}

extension MedicationListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let medication = MedicationController.shared.sections[indexPath.section][indexPath.row]
            MedicationController.shared.deleteMedication(medication)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension MedicationListViewController: MedicationTableViewCellDelegate {
        
    func medicationWasTakenButtonTapped(medication: Medication, wasTaken: Bool) {
        MedicationController.shared.markMedicationTaken(medication: medication, wasTaken: wasTaken)
        tableView.reloadData()
    }
    
}

extension MedicationListViewController: MoodSurveyViewControllerDelegate {
    func moodButtonTapped(with emoji: String) {
        MoodSurveyController.shared.didTapMoodEmoji(emoji)
        moodSurveyButton.setTitle(emoji, for: .normal)
    }
}
