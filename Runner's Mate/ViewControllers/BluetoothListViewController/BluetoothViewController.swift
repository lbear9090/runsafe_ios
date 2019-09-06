//
//  BluetoothViewController.swift
//  Ceres8
//
//  Created by Lucky on 7/6/16.
//  Copyright © 2016 Lucky. All rights reserved.
//

import UIKit
import CoreBluetooth

class BluetoothViewController: UIViewController,UITableViewDelegate,CBCentralManagerDelegate,CBPeripheralDelegate,BLECommunicationDelegate
{
    
    @IBOutlet var BlutoothListTable: UITableView!
    var centralManager: CBCentralManager?
    var peripherals: Array<CBPeripheral> = Array<CBPeripheral>()
    var SelectedUUIDs:AnyObject!

    var ConnectedButton:CBPeripheral!
    var SelectedAdvertismentData: AnyObject!
    var ListofAdvertismentData:NSMutableArray!
    var UUID :CBUUID!
    var scanOptions: [String : AnyObject]?

    let
    centralQueue = DispatchQueue(label: "com.ceres8.RunnerMates")
    
    var TRANSFER_UUID:String=String("FFE0")
    
    var NOTIFY_UUID:String=String("FFE1")
    var RBL_CHAR_TX_UUID:String=String("627427BC-F033-E378-98D7-D8C2529EBCA3")
    var RBL_CHAR_RX_UUID:String=String("627427BC-F033-E378-98D7-D8C2529EBCA3")

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // For background queue :- DISPATCH_QUEUE_PRIORITY_BACKGROUND
        
        // Constant.APPDELEGATE.showLoadingHUD(self.navigationController!, withText: "Wait we are searching for your bluetooth device")
        
        centralManager = CBCentralManager(delegate: self, queue: centralQueue)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        centralManager = CBCentralManager(delegate: self, queue: centralQueue)
    }
    
    //MARK:- CoreBluetooth Delegates
    
    func centralManagerDidUpdateState(_ central: CBCentralManager)
    {
        
        
        if #available(iOS 10.0, *)
        {
            switch (central.state) {
                
            case CBManagerState.poweredOff:
                print("CBCentralManagerState.PoweredOff")
                
            case CBManagerState.unauthorized:
                // Indicate to user that the iOS device does not support BLE.
                print("CBCentralManagerState.Unauthorized")
                break
                
            case CBManagerState.unknown:
                // Wait for another event
                print("CBCentralManagerState.Unknown")
                break
                
            case CBManagerState.poweredOn:
                print("CBCentralManagerState.PoweredOn")
                
                self.centralManager!.scanForPeripherals(withServices: [CBUUID(string:TRANSFER_UUID)], options:[CBCentralManagerScanOptionAllowDuplicatesKey: false])
                
            case CBManagerState.resetting:
                print("CBCentralManagerState.Resetting")
                
            case CBManagerState.unsupported:
                print("CBCentralManagerState.Unsupported")
                break
//            case .unknown:
//                <#code#>
//            case .resetting:
//                <#code#>
//            case .unsupported:
//                <#code#>
//            case .unauthorized:
//                <#code#>
//            case .poweredOff:
//                <#code#>
//            case .poweredOn:
//                <#code#>
            }
        }
        else
        {
        
           switch central.state.rawValue
           {
            case 0: // CBCentralManagerState.Unknown
                print("CBCentralManagerState.Unknown")
            break
            
            case 1: // CBCentralManagerState.Resetting
            print("CBCentralManagerState.Resetting")
            
            
            case 2:// CBCentralManagerState.Unsupported
                print("CBCentralManagerState.Unsupported")
            break
            
            case 3: // CBCentralManagerState.unauthorized
                print("This app is not authorised to use Bluetooth low energy")
            break
            
            case 4: // CBCentralManagerState.poweredOff:
                print("Bluetooth is currently powered off.")
            
            case 5: //CBCentralManagerState.poweredOn:
                self.centralManager!.scanForPeripherals(withServices: [CBUUID(string:TRANSFER_UUID)], options:[CBCentralManagerScanOptionAllowDuplicatesKey: false])
                print("Bluetooth is currently powered on and available to use.")
            
            default:break
            }
         
        }
        
        
        
    
        
    }
    
    //MARK:- Discover Peripheral Delegate
    
    private func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber)
    {
        
        if peripherals .contains(peripheral)
        {
            
        }
        else
        {
            ConnectedButton=peripheral
            
            print("Advertisement Data")
            print(advertisementData)
            
            print("Advertisement Values")
            print(advertisementData.values)
            

            peripherals .append(peripheral)
            
            
           //  ListofAdvertismentData.addObject(advertisementData)
            //Constant.APPDELEGATE.hideLoadingHUD()
            
            self.centralManager!.stopScan()
        }
        
        DispatchQueue.main.async(execute: {() -> Void in
             self.BlutoothListTable.reloadData()
            })
        
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//            self.BlutoothListTable.reloadData()
//        })
        
    }
    
    //MARK:- Peripheral connect delegate
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral)
    {
        
        print("Connection to peripheral with UUID successfull\r\n");
        
        DispatchQueue.main.async(execute: {() -> Void in
            self.BlutoothListTable.reloadData()
        })
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//            self.BlutoothListTable.reloadData()
//        })

        peripheral.delegate=self
        
        //--My Code   // ConnectedButton.discoverServices(nil)
        
        peripheral.discoverServices([CBUUID(string:TRANSFER_UUID)])
        
    }
    
    //MARK:- Discover Services for device
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: Error?)
    {
        if error != nil
        {
            NSLog("Error discovering services: %@", error!.localizedDescription)
            return
        }
        
        for service: CBService in peripheral.services!
        {
            
            if service.uuid.isEqual(NOTIFY_UUID)
            {
                peripheral.discoverCharacteristics([CBUUID(string:NOTIFY_UUID)], for: service)
            }
            
            //My Code:--   peripheral.discoverCharacteristics(nil, forService: service)
        }
    }
    
    //MARK:- Discover Characteristics for device
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?)
    {
        
        // Deal with errors (if any)
        if error != nil
        {
            NSLog("Error discovering characteristics: %@", error!.localizedDescription)
            return
        }
        
        // Again, we loop through the array, just in case.
        
        for characteristic: CBCharacteristic in service.characteristics!
        {
            let uu:CBUUID=CBUUID(string:"FFE1")
            
            print(uu)
            print(characteristic.uuid)
            
            if characteristic.uuid.isEqual(uu)
            {
                // If it is, subscribe to it
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    //MARK:- Update Value of characteristic Delegate
    
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        if error != nil
        {
            NSLog("Error reading characteristics: %@", error!.localizedDescription)
            return
        }
        if characteristic.value != nil
        {
            //value here.
            let ReadStr = NSString(data: characteristic.value!, encoding: String.Encoding.utf8.rawValue)
            
            NSLog("%@",ReadStr!)

            peripheral .readValue(for: characteristic)
        }
    }
    
    //MARK:- Notify when characteristic update
    
    func peripheral(peripheral: CBPeripheral, didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic, error: NSError?)
    {
        
        if error != nil
        {
            NSLog("Error changing notification state: %@", error!.localizedDescription)
            
        }
        // Notification has started
        if characteristic.isNotifying
        {
            NSLog("Notification began on: %@", characteristic)
            
            let ReadStr = NSString(data: characteristic.value!, encoding: String.Encoding.utf8.rawValue)
            
            NSLog("%@",ReadStr!)
            
            peripheral .readValue(for: characteristic)
        }
        else
        {
            self.centralManager?.cancelPeripheralConnection(peripheral)
        }
    }
    
    //MARK:- Connection disconnect with device
    
   
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?)
    {
        DispatchQueue.main.async(execute: {() -> Void in
            self.BlutoothListTable.reloadData()
        })
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//            self.BlutoothListTable.reloadData()
//        })

        print("disconnection to peripheral with UUID successfull\r\n");
        
        print(error?.localizedDescription)
        
        //  See if it was our peripheral that disconnected
        
//        if (peripheral == self.ConnectedButton)
//        {
//            centralManager?.connectPeripheral(ConnectedButton, options: nil)
//
//        }
//        else
//        {
            centralManager = CBCentralManager(delegate: self, queue: centralQueue)

//        }
        
        peripherals .removeAll()
        BlutoothListTable.reloadData()
        Constant.AlertViewNew(Title: "Your device disconnected.", Message: "Please try to connect with configurable device", ViewController:self)
    }
    
    //MARK:- Connection fail with device
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: Error?)
    {
        DispatchQueue.main.async(execute: {() -> Void in
            self.BlutoothListTable.reloadData()
        })
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//            self.BlutoothListTable.reloadData()
//        })

        print("Connection to peripheral with UUID Fail,didFailToConnectPeripheral\r\n");
        
        ConnectedButton=nil
        
        Constant.AlertViewNew(Title: "Your connection fail with your device", Message: "Please try to connect with configurable device", ViewController:self)
        
    }
    
    func getResponseFromButton(characteristic:CBCharacteristic, error:NSError)
    {
        //        let data:NSData = characteristic .value!
        //
        //        var string:NSString=NSString(data: data, encoding: NSUTF8StringEncoding)
        
        
        
        //        let reportData:UInt8 = data.bytes
        //
        //        var bpm: UInt16 = 0
        //
        //        if (reportData[0] & 0x01) == 0
        //        {
        //            // 2
        //            // Retrieve the BPM value for the Heart Rate Monitor
        //            bpm = reportData[1]
        //        }
        //        else {
        //            bpm = CFSwapInt16LittleToHost(UInt16(reportData[1]))
        //            // 3
        //        }
        // Display the heart rate value to the UI if no error occurred
        
        if ((characteristic.value) != nil)
        {
            if error.isProxy()==false
            {
                print("Perform some action here...Button connected succesfully..")
                
                // 4
                //                                    self.heartRate = bpm
                //                                    self.heartRateBPM.text = "\(bpm) bpm"
                //                                    self.heartRateBPM.font = UIFont(name: "Futura-CondensedMedium", size: 28)
                //                                    self.doHeartBeat()
                //                                    self.pulseTimer = NSTimer.scheduledTimerWithTimeInterval((60.0 / self.heartRate), target: self, selector: #selector(self.doHeartBeat), userInfo: nil, repeats: false)
                
            }
        }
        return
    }
    
    //MARK:- UITableView Delegates
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell = self.BlutoothListTable.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        let peripheral:CBPeripheral = peripherals[indexPath.row]
        
        var  DeviceNameStr:String=peripheral.name! as String
      
        DeviceNameStr = DeviceNameStr.replacingOccurrences(of: "Optional", with: "")
        DeviceNameStr = DeviceNameStr.replacingOccurrences(of: ")", with: "")
        DeviceNameStr = DeviceNameStr.replacingOccurrences(of: "(", with: "")
        DeviceNameStr = DeviceNameStr.replacingOccurrences(of: "\n", with: "")
        DeviceNameStr = DeviceNameStr.replacingOccurrences(of: "\"", with: "")

        //        DeviceNameStr = DeviceNameStr .stringByReplacingOccurrencesOfString("Optional", withString: "")
//
//        DeviceNameStr = DeviceNameStr .stringByReplacingOccurrencesOfString(")", withString: "")
//
//        DeviceNameStr = DeviceNameStr .stringByReplacingOccurrencesOfString("(", withString: "")
//
//        DeviceNameStr = DeviceNameStr .stringByReplacingOccurrencesOfString("\n", withString:"")
//
//        DeviceNameStr = DeviceNameStr .stringByReplacingOccurrencesOfString("\"", withString:"")
        
        cell.textLabel?.text = DeviceNameStr
        
        let  DeviceState:String = GetCurrentstate(rawValue: peripheral.state.rawValue)
        
        print(peripheral.state.rawValue)
        
        cell.detailTextLabel?.text = DeviceState
        
        return cell
    }
    
    //MARK:- Get Current state of device
    func GetCurrentstate(rawValue:Int)-> (String)
    {
        var State:String=String()
        print(State)
        
        if rawValue==0
        {
            State="Disconnected"
        }
        else if rawValue==1
        {
            State="Connecting"
        }
        else if rawValue==2
        {
            State="Connected"
        }
        else
        {
            State="Disconnecting"
        }
        
        return State
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        // SelectedAdvertismentData=nil
        //SelectedAdvertismentData=ListofAdvertismentData.objectAtIndex(indexPath.row)
        
        //  let SeletedDevice:CBPeripheral=peripherals[indexPath.row]
        
        //-- My Code //   centralManager?.connectPeripheral(peripherals[indexPath.row], options: [CBCentralManagerScanOptionAllowDuplicatesKey:true])
      
        DispatchQueue.main.async(execute: {() -> Void in
             self.centralManager?.connect(self.ConnectedButton, options: [CBConnectPeripheralOptionNotifyOnConnectionKey: true,CBConnectPeripheralOptionNotifyOnDisconnectionKey:true,CBConnectPeripheralOptionNotifyOnNotificationKey:true])
            
            self.BlutoothListTable.reloadData()
        })
        
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//            self.centralManager?.connect(self.ConnectedButton, options: [CBConnectPeripheralOptionNotifyOnConnectionKey: true,CBConnectPeripheralOptionNotifyOnDisconnectionKey:true,CBConnectPeripheralOptionNotifyOnNotificationKey:true])
//
//            self.BlutoothListTable.reloadData()
//        })

        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 1
    }
    
    //MARK:- Back Click
    @IBAction func BackClick(sender: UIBarButtonItem)
    {
        self.navigationController?.popViewController(animated: true)
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return peripherals.count
    }
    
    func tableView(tableView: UITableView, numberOfSections section: Int) -> Int
    {
        return 1
    }
    
    
    //MARK:- BLECommunication Delegates
    /*
    func scanningDevices()
    {
        
    }
    func connectingToDevice() {
        
    }
    func didDisconnectDevice() {
        
    }
    func didConnectDevice(deviceName: String!)
    {
        
    }
    func didFailToConnectDevice() {
        
    }
    func bleNotSupportedOrDisabled() {
        
    }
    func didWriteDataWithFailure() {
        
    }
    func didWriteDataWithSuccess()
    {
        
    }
    func didReceiveWeight(weight: String!, withUnit unit: String!)
    {
        
    }*/

}
