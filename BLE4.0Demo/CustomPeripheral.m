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

@property (nonatomic, copy) characteristicValueChangeBlock valueChangeBlock;
@property (nonatomic, copy) discoverServerCompletion serverCompletion;
@property (nonatomic, copy) discoverCharacteristicCompletion characteristicCompletion;


@end

@implementation CustomPeripheral


- (void)discoverService:(CBUUID *)serverUUID completion:(discoverServerCompletion)completion
{
    self.peripheral.delegate = self;
    [self.peripheral discoverServices:@[serverUUID]];
    _serverCompletion = completion;
}

- (void)discoverCharacteristics:(CBUUID *)characteristicUUID forService:(CBService *)service completion:(discoverCharacteristicCompletion)completion
{
    [self.peripheral discoverCharacteristics:@[characteristicUUID] forService:service];
    _characteristicCompletion = completion;
}


// notify
- (void)observerCharacteristicUUID:(CBUUID *)characteristicUUID whileValueChangedBlock:(characteristicValueChangeBlock)valueChangeBlock
{
    _valueChangeBlock = valueChangeBlock;
    
}

#pragma mark CBPeripheralDelegate
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    _serverCompletion(error, peripheral.services.firstObject);
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    _characteristicCompletion(error, service.characteristics.firstObject);
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
    _valueChangeBlock(error, type, characteristic);
    
}


- (NSString *)hexStringFromData:(NSData*)data{
    return [[[[NSString stringWithFormat:@"%@",data]
              stringByReplacingOccurrencesOfString: @"<" withString: @""]
             stringByReplacingOccurrencesOfString: @">" withString: @""]
            stringByReplacingOccurrencesOfString: @" " withString: @""];
}

@end
