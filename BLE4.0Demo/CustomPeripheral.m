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
@property (nonatomic, copy) characteristicValueChangeBlock valueChangeBlock;

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
- (void)setNotifyValue:(BOOL)enabled forCharacteristic:(CBCharacteristic *)characteristic whileValueChangedBlock:(characteristicValueChangeBlock)valueChangeBlock
{
    _valueChangeBlock = valueChangeBlock;
    [self.peripheral setNotifyValue:enabled forCharacteristic:characteristic];
}

#pragma mark CBPeripheralDelegate
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
//    NSLog(@"did diddiscover servers");
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
    pressButtonType type = pressButtonTypeUnknown;
    switch (num) {
        case 11:
            type = pressButtonTypeSingleUp;
            break;
        case 21:
            type = pressButtonTypeSingleLeft;
            break;
        case 31:
            type = pressButtonTypeSingleDown;
            break;
        case 41:
            type = pressButtonTypeSingleRight;
            break;
        default:
            break;
    }
    _valueChangeBlock(error,type , characteristic);
    
}


- (NSString *)hexStringFromData:(NSData*)data{
    return [[[[NSString stringWithFormat:@"%@",data]
              stringByReplacingOccurrencesOfString: @"<" withString: @""]
             stringByReplacingOccurrencesOfString: @">" withString: @""]
            stringByReplacingOccurrencesOfString: @" " withString: @""];
}

@end
