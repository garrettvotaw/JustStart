//
//  Utils.swift
//  Just Start
//
//  Created by Garrett Votaw on 8/7/18.
//  Copyright © 2018 Garrett Votaw. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func presentAlert(title: String?, message: String?, completion: (()-> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action1)
        
        self.present(alert, animated: true, completion: completion)
    }
}
