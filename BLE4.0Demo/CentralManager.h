//
//  CentralManager.h
//  BLE4.0Demo
//
//  Created by 刘健 on 16/6/30.
//  Copyright © 2016年 刘健. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CBPeripheral;
@class CBUUID;
@class CustomPeripheral;

typedef void(^CentralScanPeripheralCompletion)(CustomPeripheral *peripheral, NSError *error);
typedef void(^CentralconnectPeripheralCompletion)(CustomPeripheral *peripheral, NSError *error);


@interface CentralManager : NSObject


+ (instancetype)sharedInstance;


- (void)scanPeripheralsByServices:(NSArray<CBUUID *> *)serviceUUIDs options:(NSDictionary *)options completion:(CentralScanPeripheralCompletion)scanCompletion;
- (void)stopScan;

- (void)connectPeripheralByCustonPreipheral:(CustomPeripheral *)peripheral option:(NSDictionary *)options completion:(CentralconnectPeripheralCompletion)connectCompletion;
- (void)canclePeripheralConnect:(CustomPeripheral *)peripheral completion:(NSError *)error;

@end
