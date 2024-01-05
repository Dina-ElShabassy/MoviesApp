//
//  Alert.swift
//  MoviesApp
//
//  Created by Dina ElShabassy on 06/01/2024.
//

import Foundation
import UIKit

struct Alert{
    
    func showAlert(title : String, message: String,vc : UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        vc.present(alert, animated: true)
    }
    
}
