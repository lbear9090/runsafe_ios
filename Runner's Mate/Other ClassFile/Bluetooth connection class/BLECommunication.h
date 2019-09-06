//
//  BLECommunication.h
//  Avalon
//
//  Created by  Nidhi Tanna on 16/12/15.
//  Copyright © 2015 NESS Programmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol BLECommunicationDelegate <NSObject>

@optional
-(void)scanningDevices;

-(void)connectingToDevice;

-(void)didConnectDevice:(NSString*)deviceName;

-(void)didFailToConnectDevice;

-(void)didDisconnectDevice;

-(void)bleNotSupportedOrDisabled;

-(void)didWriteDataWithSuccess;

-(void)didWriteDataWithFailure;

- (void) didReceiveWeight:(NSString *)weight withUnit:(NSString *)unit;

- (void)showActivityIndicator;
- (void)hideActivityIndicator;

@end

@interface BLECommunication : NSObject

@property (nonatomic, strong) id<BLECommunicationDelegate> delegate;

@property (strong, nonatomic) CBCentralManager      *centralManager;
@property (strong, nonatomic) CBPeripheral          *discoveredPeripheral;
@property (strong, nonatomic) CBCharacteristic      *characteristicToWrite;
@property (strong, nonatomic) NSMutableData         *data;

-(void)writeDataOnCharacteristic:(NSString*)messageToWrite;

-(void)disconnectDevice;

-(void)StartScanning;

@end