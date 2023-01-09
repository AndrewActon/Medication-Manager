//
//  MoodSurveyViewController.swift
//  MedicationManager
//
//  Created by Andrew Acton on 1/7/23.
//

import UIKit

protocol MoodSurveyViewControllerDelegate: AnyObject {
    func moodButtonTapped(with emoji: String)
}

class MoodSurveyViewController: UIViewController {

    //MARK: Properties
    weak var delegate: MoodSurveyViewControllerDelegate?
    
    //MARK: Actions
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func emojiTapped(_ sender: UIButton) {
        guard let emoji = sender.titleLabel?.text
        else { return }
            
        delegate?.moodButtonTapped(with: emoji)
        dismiss(animated: true)
        }
}


