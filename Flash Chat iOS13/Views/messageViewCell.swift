//
//  messageViewCell.swift
//  Flash Chat iOS13
//
//  Created by Jhojan Sobrino on 4/11/23.
//  Copyright © 2023 Angela Yu. All rights reserved.
//

import UIKit

class messageViewCell: UITableViewCell {

    @IBOutlet weak var messageBundle: UIView!
    @IBOutlet weak var mssg: UILabel!
    @IBOutlet weak var photouser: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        messageBundle.layer.cornerRadius = messageBundle.frame.size.height / 5
        // Initialization code
    }

    @IBOutlet weak var leftphotouser: UIImageView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
