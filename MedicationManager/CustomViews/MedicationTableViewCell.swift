//
//  MedicationTableViewCell.swift
//  MedicationManager
//
//  Created by Andrew Acton on 12/31/22.
//

import UIKit

class MedicationTableViewCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var wasTakenButton: UIButton!

    //MARK: - Actions
    @IBAction func wasTakenButtonTapped(_ sender: UIButton) {
        print("Was taken button tapped")
    }
    
    func configure(medication: Medication) {
        nameLabel.text = medication.name
        timeLabel.text = DateFormatter.medicationTime.string(from: medication.timeOfDay ?? Date() )
    }
}
