//
//  TaskCell.swift
//  Just Start
//
//  Created by Garrett Votaw on 8/9/18.
//  Copyright © 2018 Garrett Votaw. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {

    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    weak var delegate: TaskCellDelegate?
    var index: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func checkPressed(_ sender: UIButton) {
        if checkButton.image(for: .normal) == #imageLiteral(resourceName: "checkMark") {
            checkButton.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            delegate?.getCompletedState(state: false, indexPath: index)
        } else {
            checkButton.shrinkGrowBounce()
            checkButton.setImage(#imageLiteral(resourceName: "checkMark"), for: .normal)
            delegate?.getCompletedState(state: true, indexPath: index)
        }
    }
    
    
    
}

extension UIView {
    func shrinkGrowBounce() {
        let springAnimation = CASpringAnimation(keyPath: "transform.scale")
        
        springAnimation.duration = 1
        springAnimation.fromValue = 0.0
        springAnimation.toValue = 1.0
        springAnimation.mass = 0.55                  //default 1
        springAnimation.initialVelocity = 20       //default 0
        springAnimation.stiffness = 70            //default 100
        springAnimation.damping = 8               //default 10
        layer.add(springAnimation, forKey: "springAnimation")
    }
}
