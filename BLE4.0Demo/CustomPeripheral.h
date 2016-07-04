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

typedef NS_ENUM(NSInteger, pressButtonType) {
    pressButtonTypeUnknown = -1,
    pressButtonTypeSingleUp = 0,
    pressButtonTypeSingleLeft,
    pressButtonTypeSingleDown,
    pressButtonTypeSingleRight
};

typedef void(^characteristicValueChangeBlock)(NSError *error, pressButtonType type,CBCharacteristic *characteristic);
typedef void(^discoverServerCompletion)(NSError *error, CBService *server);
typedef void(^discoverCharacteristicCompletion)(NSError *error, CBCharacteristic *characteristic);

@interface CustomPeripheral : NSObject

@property (nonatomic, strong) NSNumber *RSSI;
@property (nonatomic, strong) NSDictionary *advertisementData;
@property (nonatomic, strong) CBPeripheral *peripheral;


// 扫描
- (void)discoverService:(CBUUID *)serverUUID completion:(discoverServerCompletion)completion;
- (void)discoverCharacteristics:(CBUUID *)characteristicUUID forService:(CBService *)service completion:(discoverCharacteristicCompletion)completion;

// 监听
- (void)observerCharacteristicUUID:(CBUUID *)characteristicUUID whileValueChangedBlock:(characteristicValueChangeBlock)valueChangeBlock;

@end
