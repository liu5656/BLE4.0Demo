//
//  CentralManager.m
//  BLE4.0Demo
//
//  Created by 刘健 on 16/6/30.
//  Copyright © 2016年 刘健. All rights reserved.
//

#import "CentralManager.h"
#import "CustomPeripheral.h"
#import <CoreBluetooth/CoreBluetooth.h>


@interface CentralManager()<CBCentralManagerDelegate>

@property (nonatomic, strong) CBCentralManager *centralManager;

@property (nonatomic, strong) NSMutableArray *peripheralsArray;

@property (nonatomic, copy) CentralScanPeripheralCompletion scanCompletion;
@property (nonatomic, copy) CentralconnectPeripheralCompletion connectCompletion;


@end

@implementation CentralManager

+ (instancetype)sharedInstance {
    static CentralManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CentralManager alloc] init];
        sharedInstance.centralManager = [[CBCentralManager alloc] initWithDelegate:sharedInstance queue:nil options:@{CBCentralManagerOptionRestoreIdentifierKey:@"centralManagerIdentify"}];
    });
    return sharedInstance;
}

// 扫描
- (void)scanPeripheralsByServices:(NSArray<CBUUID *> *)serviceUUIDs options:(NSDictionary *)options completion:(CentralScanPeripheralCompletion)scanCompletion
{
    [self.centralManager state];
    [self peripheralsArray];
    if (self.centralManager.state != CBCentralManagerStatePoweredOn) {
        NSError *error = [[NSError alloc] initWithDomain:@"请打开蓝牙" code:0 userInfo:nil];
        scanCompletion(nil, error);
        return;
    }
    [self.centralManager scanForPeripheralsWithServices:serviceUUIDs options:options];
    _scanCompletion = scanCompletion;
}


- (void)stopScan
{
    [self.centralManager stopScan];
}

// 连接
- (void)connectPeripheralByCustonPreipheral:(CustomPeripheral *)peripheral option:(NSDictionary *)options completion:(CentralconnectPeripheralCompletion)connectCompletion
{
    [self.centralManager connectPeripheral:peripheral.peripheral options:options];
    _connectCompletion = connectCompletion;
}

- (void)canclePeripheralConnect:(CustomPeripheral *)peripheral completion:(NSError *)error
{
    [self.centralManager cancelPeripheralConnection:peripheral.peripheral];
}


#pragma mark cbcentralmanager delegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    
    switch (central.state) {
        case CBCentralManagerStateUnknown:
            NSLog(@"CBCentralManagerStateUnknown");
            break;
        case CBCentralManagerStateResetting:
            NSLog(@"CBCentralManagerStateResetting");
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@"CBCentralManagerStateUnsupported");
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@"CBCentralManagerStateUnauthorized");
            break;
        case CBCentralManagerStatePoweredOff:
            NSLog(@"蓝牙关闭状态--- CBCentralManagerStatePoweredOff");
            break;
        case CBCentralManagerStatePoweredOn:
            NSLog(@"开始扫描---CBCentralManagerStatePoweredOn");
            break;
            
        default:
            break;
    }
}

#pragma mark CBCentralManagerDelegate
// scan scope
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    if ([self.peripheralsArray containsObject:peripheral]) {
        return;
    }
    
    CustomPeripheral *customPeripheral = [[CustomPeripheral alloc] init];
    customPeripheral.peripheral = peripheral;
    customPeripheral.RSSI = RSSI;
    customPeripheral.advertisementData = advertisementData;
    [self.peripheralsArray addObject:customPeripheral];
    _scanCompletion(customPeripheral, nil);
    
}

// connect scope
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    CustomPeripheral *tempPeripheral = [[CustomPeripheral alloc] init];
    tempPeripheral.peripheral = peripheral;
    _connectCompletion(tempPeripheral, nil);
    
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"did fail to connect peripheral:%@",error.localizedDescription);
    _connectCompletion(nil, error);
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"已经断开连接,开始尝试恢复连接:did disconnect peripheral :%@",error.localizedDescription);
    [self.centralManager connectPeripheral:peripheral options:nil];
    _connectCompletion(nil, error);
}

    // reconnect scope
- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *,id> *)dict
{
    NSLog(@"will restore state:%@",dict);
}

#pragma mark get
//- (NSMutableArray *)peripheralArray
//{
//    if (!_peripheralsArray) {
//        _peripheralsArray = [NSMutableArray array];
//    }
//    return _peripheralsArray;
//}

- (NSMutableArray *)peripheralsArray
{
    if (!_peripheralsArray) {
        _peripheralsArray = [NSMutableArray array];
    }
    return _peripheralsArray;
}

@end
