//
//  MedicationTableViewCell.swift
//  MedicationManager
//
//  Created by Andrew Acton on 12/31/22.
//

import UIKit

protocol MedicationTableViewCellDelegate: AnyObject {
    func medicationWasTakenButtonTapped(medication: Medication, wasTaken: Bool)
}

class MedicationTableViewCell: UITableViewCell {

    //MARK: Properties
    weak var delegate: MedicationTableViewCellDelegate?
    private var medication: Medication?
    private var wasTakenToday: Bool = false
    
    //MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var wasTakenButton: UIButton!

    //MARK: - Actions
    @IBAction func wasTakenButtonTapped(_ sender: UIButton) {
        guard let medication = medication
        else { return }
        
        wasTakenToday.toggle()
        delegate?.medicationWasTakenButtonTapped(medication: medication, wasTaken: wasTakenToday)
    }
    
    func configure(medication: Medication) {
        self.medication = medication
        wasTakenToday = medication.wasTakenToday()
        nameLabel.text = medication.name
        timeLabel.text = DateFormatter.medicationTime.string(from: medication.timeOfDay ?? Date() )
        let image = wasTakenToday ? UIImage(systemName: "checkmark.square") : UIImage(systemName: "square")
        wasTakenButton.setImage(image, for: .normal)
    }
}
