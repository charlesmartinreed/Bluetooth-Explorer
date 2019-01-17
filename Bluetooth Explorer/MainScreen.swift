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
    var names = [String]()
    var rssis = [NSNumber]()
    var refreshTimer: Timer!
    
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
        
        //navbar setup
        title = "Bluetooth Tracker"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshAvailableBTConnections))
        
        setupBluetoothManager()
    }
    
    //MARK:- Bluetooth discovery methods
    func initializeRefreshTimer() {
        refreshTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(refreshAvailableBTConnections), userInfo: nil, repeats: true)
    }
    
    func setupBluetoothManager() {
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func startBluetoothScanning() {
        names = []
        rssis = []
        
        tableView.reloadData()
        centralManager?.scanForPeripherals(withServices: nil, options: [:])
    }
    
    //MARK:- Updating UI
    @objc func refreshAvailableBTConnections() {
        //reset the arrays, reload tableView, stop old scan and start new scan
        centralManager?.stopScan()
        refreshTimer.invalidate()
        
        startBluetoothScanning()
        initializeRefreshTimer()
    }

}

//MARK:- Extensions
extension MainScreen : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as? MainCell else { fatalError("Could not initalize cell!") }
        
            cell.peripheralLabel.text = names[indexPath.row]
            cell.rssiLabel.text = "RSSI: \(rssis[indexPath.row])"
            
        return cell
    }
}

extension MainScreen : CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state {
        case .poweredOn:
            startBluetoothScanning()
            initializeRefreshTimer()
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
            names.append(peripheralName)
        } else {
            let uuidString = peripheral.identifier.uuidString
            names.append(uuidString)
        }
        
        rssis.append(RSSI)
        tableView.reloadData()
    }
    
    
}
