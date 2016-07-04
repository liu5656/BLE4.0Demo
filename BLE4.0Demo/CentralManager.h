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
@class CBService;

typedef void(^CentralScanPeripheralCompletion)(CustomPeripheral *peripheral, NSError *error);
typedef void(^CentralconnectPeripheralCompletion)(CustomPeripheral *peripheral, NSError *error);

typedef void(^connectPeripheralCompletion)(CustomPeripheral *peripheral, CBService *server, NSError *error);


@interface CentralManager : NSObject

@property (nonatomic, strong) CustomPeripheral *currentConnectedPeripheral;


+ (instancetype)sharedInstance;


- (void)scanPeripheralsByServices:(NSArray<CBUUID *> *)serviceUUIDs options:(NSDictionary *)options completion:(CentralScanPeripheralCompletion)scanCompletion;
- (void)stopScan;

- (void)canclePeripheralConnect:(CustomPeripheral *)peripheral completion:(NSError *)error;
- (void)connectPeripheralByCustomPreipheral:(CustomPeripheral *)peripheral whichServer:(CBUUID *)serverUUID whichCharacteristic:(CBUUID *)characteristicUUID option:(NSDictionary *)options completion:(connectPeripheralCompletion)connectCompletion;

@end
