//
//  ViewController.swift
//  Bluetooth Explorer
//
//  Created by Charles Martin Reed on 1/17/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import UIKit
import CoreBluetooth

class MainScreen: UIViewController, Storyboarded {

    //MARK:- Properties
    weak var coordinator: MainCoordinator?
    var centralManager: CBCentralManager? //this is what we'll use to poll for nearby bluetooth devices
    
    //MARK:- IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    func displayAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(ac, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        setupBluetoothManager()
        
        //navbar setup
        title = "Bluetooth Tracker"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshAvailableBTConnections))
        
    }
    
    //MARK:- Bluetooth discovery methods
    func setupBluetoothManager() {
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func startBluetoothScanning() {
        //scanning continues until told to stop
        centralManager?.scanForPeripherals(withServices: nil, options: [:])
    }
    
    //MARK:- Updating UI
    @objc func refreshAvailableBTConnections() {
        print("refresh tapped")
    }

}

//MARK:- Extensions
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

extension MainScreen : CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state {
        case .poweredOn:
            startBluetoothScanning()
            print("Performing scan") //perform a scan for nearby devices
        case .poweredOff:
            displayAlert(title: "Bluetooth is unavailable", message: "Please ensure that your bluetooth is turned on and ready to rock.")
        default:
            break
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        //this contains all the info about the nearby BT devices that we'd want
        if let peripheralName = peripheral.name {
            print("Peripheral name: \(peripheralName)")
        }
        print("UUID: \(peripheral.identifier.uuidString)")
        print("Peripheral RSSI: \(RSSI)")
        print("Ad data: \(advertisementData)")
        print("*******************************")
    }
    
    
}
