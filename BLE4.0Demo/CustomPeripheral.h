//
//  CustomPreipheral.h
//  BLE4.0Demo
//
//  Created by 刘健 on 16/6/30.
//  Copyright © 2016年 刘健. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CBPeripheral;
@class CBUUID;
@class CBService;
@class CBCharacteristic;

typedef void(^PeripheralDiscoverServerCompletion)(NSError *error, NSArray *servers);
typedef void(^PeripheralDiscoverCharacteristicCompletion)(NSError *error, NSArray *characteristics);

@interface CustomPeripheral : NSObject

@property (nonatomic, strong) NSNumber *RSSI;
@property (nonatomic, strong) NSDictionary *advertisementData;
@property (nonatomic, strong) CBPeripheral *peripheral;

// 扫描
- (void)discoverServices:(NSArray<CBUUID *> *)serviceUUIDs onFinish:(PeripheralDiscoverServerCompletion)completion;
- (void)discoverCharacteristics:(NSArray *)characteristicUUIDs forService:(CBService *)service onFinish:(PeripheralDiscoverCharacteristicCompletion)completion;

// notify
- (void)setNotifyValue:(BOOL)enabled forCharacteristic:(CBCharacteristic *)characteristic;

@end
