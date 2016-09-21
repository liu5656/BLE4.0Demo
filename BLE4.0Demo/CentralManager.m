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


@interface CentralManager()<CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, strong) CBCentralManager *centralManager;

@property (nonatomic, strong) NSMutableArray *peripheralsArray;

@property (nonatomic, copy) CentralScanPeripheralCompletion scanCompletion;


@property (nonatomic, copy) connectPeripheralCompletion connectConpletion;


@property (nonatomic, strong) CBUUID *serverUUID;
@property (nonatomic, strong) CBUUID *characteristicUUID;


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
    [self peripheralsArray];
    _scanCompletion = scanCompletion;
    if (self.centralManager.state != CBCentralManagerStatePoweredOn) {
        NSError *error = [[NSError alloc] initWithDomain:@"请打开蓝牙" code:0 userInfo:nil];
        scanCompletion(nil, error);
        return;
    }
    [self.centralManager scanForPeripheralsWithServices:serviceUUIDs options:options];
    
}

- (void)stopScan
{
    [self.centralManager stopScan];
}

// 连接
- (void)connectPeripheralByCustomPreipheral:(CustomPeripheral *)peripheral whichServer:(CBUUID *)serverUUID whichCharacteristic:(CBUUID *)characteristicUUID option:(NSDictionary *)options completion:(connectPeripheralCompletion)connectCompletion
{
    self.serverUUID = serverUUID;
    self.characteristicUUID = characteristicUUID;
    _connectConpletion = connectCompletion;
    [self.centralManager connectPeripheral:peripheral.peripheral options:options];
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
        {
            NSArray *array = @[[CBUUID UUIDWithString:@"FFF0"]];
            [self scanPeripheralsByServices:array options:nil completion:_scanCompletion];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark CBCentralManagerDelegate
// scan scope
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
//    if ([self.peripheralsArray containsObject:peripheral]) {
//        return;
//    }
    
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

    CustomPeripheral *temp = self.currentConnectedPeripheral;
    temp.peripheral = peripheral;
    self.currentConnectedPeripheral = temp;
    [temp discoverService:self.serverUUID completion:^(NSError *error, CBService *server) {
        if (!error) {
            [temp discoverCharacteristics:self.characteristicUUID forService:server completion:^(NSError *error, CBCharacteristic *characteristic) {
                if (!error) {
                    [temp.peripheral setNotifyValue:YES forCharacteristic:characteristic];
                    NSLog(@"订阅特征完成");
                }
            }];
        }
    }];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"did fail to connect peripheral:%@",error.localizedDescription);
    _connectConpletion(nil, nil, error);
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"已经断开连接,开始尝试恢复连接:did disconnect peripheral :%@",error.localizedDescription);
    [self.centralManager connectPeripheral:peripheral options:nil];
    _connectConpletion(nil, nil, error);
}

    // reconnect scope
- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *,id> *)dict
{
    NSLog(@"will restore state:%@",dict);
}

#pragma mark CBPeripheralDelegate
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (peripheral.services.count == 0) {
        NSError *error = [NSError errorWithDomain:@"没有找到相应server" code:0 userInfo:nil];
        _connectConpletion(nil, nil, error);
        return;
    }
    [peripheral discoverCharacteristics:@[self.characteristicUUID] forService:peripheral.services.firstObject];
}


- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (service.characteristics.count == 0) {
        NSError *error = [NSError errorWithDomain:@"没有找到相应characteristic" code:0 userInfo:nil];
        _connectConpletion(nil, nil, error);
        return;
    }
    
    for (CBCharacteristic *temp in service.characteristics) {
        if ([temp.UUID isEqual:self.characteristicUUID]) {
            [peripheral setNotifyValue:YES forCharacteristic:temp]; // 订阅
        }
    }
    
    CustomPeripheral *temp = [[CustomPeripheral alloc] init];
    temp.peripheral = peripheral;
    _connectConpletion(temp, service, nil);
}


#pragma mark get
- (NSMutableArray *)peripheralsArray
{
    if (!_peripheralsArray) {
        _peripheralsArray = [NSMutableArray array];
    }
    return _peripheralsArray;
}

@end
