//
//  CustomPreipheral.m
//  BLE4.0Demo
//
//  Created by 刘健 on 16/6/30.
//  Copyright © 2016年 刘健. All rights reserved.
//

#import "CustomPeripheral.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface CustomPeripheral()<CBPeripheralDelegate>

@property (nonatomic, copy) PeripheralDiscoverServerCompletion serverCompletion;
@property (nonatomic, copy) PeripheralDiscoverCharacteristicCompletion characteristicCompletion;

@end

@implementation CustomPeripheral


// 扫描
- (void)discoverServices:(NSArray<CBUUID *> *)serviceUUIDs onFinish:(PeripheralDiscoverServerCompletion)completion
{
    self.peripheral.delegate = self;
    [self.peripheral discoverServices:serviceUUIDs];
    _serverCompletion = completion;
}

- (void)discoverCharacteristics:(NSArray *)characteristicUUIDs forService:(CBService *)service onFinish:(PeripheralDiscoverCharacteristicCompletion)completion
{
    [self.peripheral discoverCharacteristics:characteristicUUIDs forService:service];
    _characteristicCompletion = completion;
}

// notify
- (void)setNotifyValue:(BOOL)enabled forCharacteristic:(CBCharacteristic *)characteristic
{
    [self.peripheral setNotifyValue:enabled forCharacteristic:characteristic];
}

#pragma mark CBPeripheralDelegate
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    _serverCompletion(error, peripheral.services);
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    _characteristicCompletion(error, service.characteristics);
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSData *data = characteristic.value;
    NSString *value4 = [self hexStringFromData:data];
    NSInteger num = value4.integerValue;
    switch (num) {
        case 11:
            break;
        case 21:
            break;
        case 31:
            break;
        case 41:
            break;
        default:
            break;
    }
}

- (NSString *)hexStringFromData:(NSData*)data{
    return [[[[NSString stringWithFormat:@"%@",data]
              stringByReplacingOccurrencesOfString: @"<" withString: @""]
             stringByReplacingOccurrencesOfString: @">" withString: @""]
            stringByReplacingOccurrencesOfString: @" " withString: @""];
}

@end
