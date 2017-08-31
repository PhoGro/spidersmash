//
//  Alerts.swift
//  PEMDAS
//
//  Created by John Davenport on 8/19/17.
//  Copyright © 2017 John Davenport. All rights reserved.
//

import SpriteKit

protocol Alerts { }
extension Alerts where Self: SKScene {
    
    func showAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in }
        alertController.addAction(okAction)
        
        self.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertWithSettings(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in }
        alertController.addAction(okAction)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            
            if NSURL(string: UIApplicationOpenSettingsURLString) != nil {
//                UIApplication.shared.openURL(url as URL)
            }
        }
        alertController.addAction(settingsAction)
        
        self.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
