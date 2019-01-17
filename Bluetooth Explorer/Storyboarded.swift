//
//  Storyboarded.swift
//  Bluetooth Explorer
//
//  Created by Charles Martin Reed on 1/17/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import UIKit

protocol Storyboarded {
    static func instantiate() -> Self
}

extension Storyboarded where Self : UIViewController {
    static func instantiate() -> Self {
        let className = String(describing: self)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        return storyboard.instantiateViewController(withIdentifier: className) as! Self //this works because we set Storyboard ID in IB to be the same as the classname 
    }
}
