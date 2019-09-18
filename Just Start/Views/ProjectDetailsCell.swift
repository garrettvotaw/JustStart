//
//  ProjectDetailsCell.swift
//  Just Start
//
//  Created by Garrett Votaw on 8/10/18.
//  Copyright © 2018 Garrett Votaw. All rights reserved.
//

import UIKit

class ProjectDetailsCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var percentCompleteLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
