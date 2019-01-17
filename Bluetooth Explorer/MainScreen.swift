//
//  ViewController.swift
//  Bluetooth Explorer
//
//  Created by Charles Martin Reed on 1/17/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import UIKit

class MainScreen: UIViewController, Storyboarded {

    //MARK:- Properties
    weak var coordinator: MainCoordinator?
    //var tableView: UITableView!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.register(MainCell.self, forCellReuseIdentifier: "MainCell")
        
        //navbar setup
        title = "Bluetooth Tracker"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshAvailableBTConnections))
        
    }
    
    //MARK:- Updating UI
    @objc func refreshAvailableBTConnections() {
        print("refresh tapped")
    }

}

extension MainScreen : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as? MainCell else { fatalError("Could not initalize cell!") }
        
            cell.peripheralLabel.text = "Device #1"
            cell.rssiLabel.text = "RSSI: -85"
            
        return cell
    }
    
    
}
