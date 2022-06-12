//
//  ShowEventTableViewCell.swift
//  CalendarView
//
//  Created by Coditas on 08/06/22.
//

import UIKit

class ShowEventTableViewCell: UITableViewCell {

    @IBOutlet weak var EventLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    static let identifier = String(describing: ShowEventTableViewCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    func setUpCell(){
        
    }
    
}
