//
//  MainCoordinator.swift
//  Bluetooth Explorer
//
//  Created by Charles Martin Reed on 1/17/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import UIKit

class MainCoordinator : Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        //this is the start point of our app. Further setup for the UIWindow can be seen in AppDelegate.swift
        let vc = MainScreen.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false) //false because this is the initial screen
    }
    
    
}
