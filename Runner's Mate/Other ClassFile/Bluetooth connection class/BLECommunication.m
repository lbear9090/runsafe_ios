//
//  BLECommunication.m
//  Avalon
//
//  Created by  Nidhi Tanna on 16/12/15.
//  Copyright © 2015 NESS Programmer. All rights reserved.
//

#import "BLECommunication.h"
#import <UIKit/UIKit.h>

//#import "Logger.h"

@interface BLECommunication() <CBCentralManagerDelegate, CBPeripheralDelegate>

@end

#define TRANSFER_SERVICE_UUID                   @"FFE0"
#define TRANSFER_CHARACTERISTIC_UUID            @"FFE4"

@implementation BLECommunication

-(instancetype)init {
    if(self == [super init]) {
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
        _data = [[NSMutableData alloc] init];
    }
    
    return self;
}

#pragma mark - Central Methods
-(void)centralManagerDidUpdateState:(CBCentralManager *)central {
    //[Logger writeLogToFile:[NSString stringWithFormat:@"BLE State Changed: %ld", (long)central.state]];
    if (central.state != CBCentralManagerStatePoweredOn) {
        if([self.delegate respondsToSelector:@selector(bleNotSupportedOrDisabled)])
            [self.delegate bleNotSupportedOrDisabled];
        return;
    }
    [self StartScanning];
}

-(void)StartScanning {
    
    if([self.delegate respondsToSelector:@selector(scanningDevices)])
        [self.delegate scanningDevices];
    
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
    [self.centralManager scanForPeripheralsWithServices:nil options:options];
    
}

-(void)disconnectDevice {
    if(_discoveredPeripheral)
        [_centralManager cancelPeripheralConnection:_discoveredPeripheral];
    [_centralManager stopScan];
}

-(void)writeDataOnCharacteristic:(NSString *)messageToWrite {
    //[Logger writeLogToFile:[NSString stringWithFormat:@"Command to Write: %@", messageToWrite]];
    
    NSData *data = [messageToWrite dataUsingEncoding:NSUTF8StringEncoding];
    const unsigned char *dataBuffer = (const unsigned char *)[data bytes];
    NSUInteger          dataLength  = [data length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    for (int i = 0; i < dataLength; ++i)
        [hexString appendString:[NSString stringWithFormat:@"%02lx ", (unsigned long)dataBuffer[i]]];
    
    
    
    if ((self.characteristicToWrite.properties & CBCharacteristicPropertyWrite) == CBCharacteristicPropertyWrite) {
        // Responses are available, so write with response.
        [self.discoveredPeripheral writeValue:data forCharacteristic:self.characteristicToWrite type:CBCharacteristicWriteWithResponse];
    }
    else if ((self.characteristicToWrite.properties & CBCharacteristicPropertyWriteWithoutResponse) == CBCharacteristicPropertyWriteWithoutResponse) {
        // Responses are not available.
        // Write with response is going to fail, so write without response.
        [self.discoveredPeripheral writeValue:data forCharacteristic:self.characteristicToWrite type:CBCharacteristicWriteWithoutResponse];
    }
    //    [self.discoveredPeripheral writeValue:data forCharacteristic:self.characteristicToWrite type:CBCharacteristicWriteWithResponse];
}

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    //[Logger writeLogToFile:[NSString stringWithFormat:@"Discovered device:%@", [peripheral description]]];
    
    if (self.discoveredPeripheral != peripheral && [peripheral.name isEqualToString:@"LactaMed"]) {
        self.discoveredPeripheral = peripheral;
        
        if([self.delegate respondsToSelector:@selector(connectingToDevice)])
            [self.delegate connectingToDevice];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self.centralManager connectPeripheral:peripheral options:nil];
        });
    }
}

-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    if([self.delegate respondsToSelector:@selector(didFailToConnectDevice)])
        [self.delegate didFailToConnectDevice];
    
    [self cleanup];
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    [self.centralManager stopScan];
    [self.data setLength:0];
    peripheral.delegate = self;
    
    if([self.delegate respondsToSelector:@selector(didConnectDevice:)])
        [self.delegate didConnectDevice:peripheral.name];
    [peripheral discoverServices:nil];
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if (error) {
        [self cleanup];
        return;
    }
    for (CBService *service in peripheral.services) {
        if([service.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]]) {
            NSLog(@"Got the Service UUID =%@",service.UUID);
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if (error) {
        [self cleanup];
        return;
    }
    
    for (CBCharacteristic *characteristic in service.characteristics) {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]]) {
            self.characteristicToWrite = characteristic;
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
    if([self.discoveredPeripheral.services lastObject] == service) {
        if([self.delegate respondsToSelector:@selector(didConnectDevice:)])
            [self.delegate didConnectDevice:self.discoveredPeripheral.name];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
    }
    
    if (![characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]])
        return;
    if (characteristic.isNotifying)
        [peripheral readValueForCharacteristic:characteristic];
}

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        // [Logger writeLogToFile:[NSString stringWithFormat:@"didWriteValueForCharacteristic Failed: %@,  Error:%@", [characteristic description], [error localizedDescription]]];
        return;
    }
    //[Logger writeLogToFile:[NSString stringWithFormat:@"didWriteValueForCharacteristic Success: %@", [characteristic description]]];
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error)
        return;
    
    NSData *data = [characteristic value];
    const uint8_t *reportData = [data bytes];
    
    if(reportData[0] == 0xf5) {
        // *********** Get Unit ************* //
        NSString *unit = @"g";
        
        if(reportData[5] == 0x00)
            unit = @"g";
        if(reportData[5] == 0x01)
            unit = @"c";
        if(reportData[5] == 0x02)
            unit = @"dwt";
        if(reportData[5] == 0x03)
            unit = @"oz";
        if(reportData[5] == 0x04)
            unit = @"ozt";
        if(reportData[5] == 0x05)
            unit = @"gn";

        // *********** Get Weight ************* //
        int count = 0;
        Byte weightbytes [2];
        short weightValue = 0;
        for (int i = 10; i>8; i--) {
            weightbytes [count] = reportData[i];
            count++;
        }
        NSData *weightData = [NSData dataWithBytes:weightbytes length:sizeof(weightbytes)];
        [weightData getBytes:&weightValue length:sizeof(short)];
        
        float weight = 0;
        if([unit isEqualToString:@"dwt"] || [unit isEqualToString:@"g"])
            weight = (float)((float)weightValue/20);
        else if([unit isEqualToString:@"c"])
            weight = (float)((float)weightValue/2);
        else if([unit isEqualToString:@"oz"] || [unit isEqualToString:@"ozt"])
            weight = (float)((float)(weightValue * 2)/1000);
        else if ([unit isEqualToString:@"gn"])
            weight = weightValue;
        NSLog(@"%@ ---- %f %@", data, weight, unit);
        
        NSString *StrWeight = [NSString stringWithFormat:@"%.2f",weight];
        
       // NSString *result = [NSString stringWithFormat:@"Weight=%@,Unit=%@",StrWeight,unit];
        if ([self.delegate respondsToSelector:@selector(didReceiveWeight:withUnit:)])
        {
            [self.delegate didReceiveWeight:StrWeight withUnit:unit];
        }
//        if ([self.delegate respondsToSelector:@selector(hideActivityIndicator)])
//        {
//            [self.delegate hideActivityIndicator];
//        }
        
//        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"" message:result delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        [al show];
        
    }
}

-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    self.discoveredPeripheral = nil;
    
    // [Logger writeLogToFile:[NSString stringWithFormat:@"disconnected: %@ with error:%@", peripheral, [error localizedDescription]]];
    
    if([self.delegate respondsToSelector:@selector(didDisconnectDevice)])
        [self.delegate didDisconnectDevice];
}

-(void)cleanup {
    if (self.discoveredPeripheral.state != CBPeripheralStateConnected) {
        return;
    }
    
    if (self.discoveredPeripheral.services != nil) {
        for (CBService *service in self.discoveredPeripheral.services) {
            if (service.characteristics != nil) {
                for (CBCharacteristic *characteristic in service.characteristics) {
                    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]]) {
                        if (characteristic.isNotifying) {
                            [self.discoveredPeripheral setNotifyValue:NO forCharacteristic:characteristic];
                            return;
                        }
                    }
                }
            }
        }
    }
    
    [self.centralManager cancelPeripheralConnection:self.discoveredPeripheral];
}
@end