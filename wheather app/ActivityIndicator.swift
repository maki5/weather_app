//
//  ActivityIndicator.swift
//  wheather app
//
//  Created by maki on 8/28/17.
//  Copyright © 2017 cm_apps. All rights reserved.
//

import Foundation
import UIKit

class ActivityIndicator {
    var view:UIView = UIView()
    var overlay:UIView = UIView()
    
    init(view: UIView) {
        self.view = view
    }
    
    
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    func show() {
        
        overlay = UIView(frame: view.frame)
        overlay.backgroundColor = UIColor.lightGray
        overlay.alpha = 0.5
        
        let container: UIView = UIView()
        container.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        container.center = view.center
        container.backgroundColor = UIColor.black
        container.alpha = 0.5
        container.clipsToBounds = true
        container.layer.cornerRadius = 10
        
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.center = view.center
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.color = UIColor.black
        activityIndicator.alpha = 1
//        container.addSubview(activityIndicator)
        overlay.addSubview(activityIndicator)
        view.addSubview(overlay)
        
        activityIndicator.startAnimating()
        
    }
    
    func hide() {
        overlay.removeFromSuperview()
        activityIndicator.stopAnimating()
    }
}
