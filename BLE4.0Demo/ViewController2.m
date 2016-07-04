//
//  ViewController2.m
//  BLE4.0Demo
//
//  Created by 刘健 on 16/7/4.
//  Copyright © 2016年 刘健. All rights reserved.
//

#import "ViewController2.h"
#import "CentralManager.h"
#import "CustomPeripheral.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController2 ()

@property (nonatomic, strong)NSMutableArray *peripheralsArray;

@end

@implementation ViewController2

- (IBAction)connectAction:(UIButton *)sender {
    [[CentralManager sharedInstance] connectPeripheralByCustonPreipheral:self.peripheralsArray.lastObject option:nil completion:^(CustomPeripheral *peripheral, NSError *error) {
        
        NSLog(@"did connect peripherial :%@", peripheral.peripheral.name);
        NSArray *uuids = @[[CBUUID UUIDWithString:@"FFF0"]];
        [peripheral discoverServices:uuids onFinish:^(NSError *error, NSArray *servers) {
            NSLog(@"did discover servers:%@", servers);
            [self startDiscoverCharacteristicInServer:servers.firstObject AndPeripheral:peripheral];
        }];
        
    }];
    
}

- (void)startDiscoverCharacteristicInServer:(CBService *)server AndPeripheral:(CustomPeripheral *)peripheral
{
    NSArray *uuids = @[[CBUUID UUIDWithString:@"FFF1"]];
    [peripheral discoverCharacteristics:uuids forService:server onFinish:^(NSError *error, NSArray *characteristics) {
        
        NSLog(@"did discover characteristic:%@", characteristics);
        [peripheral setNotifyValue:YES forCharacteristic:characteristics.firstObject whileValueChangedBlock:^(NSError *error, pressButtonType type, CBCharacteristic *characteristic) {
            NSLog(@"value has changed:%@",characteristic.value);
        }];
        
    }];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.peripheralsArray = [NSMutableArray array];
    [CentralManager sharedInstance];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSArray *uuids = @[[CBUUID UUIDWithString:@"FFF0"]];
    [[CentralManager sharedInstance] scanPeripheralsByServices:uuids options:nil completion:^(CustomPeripheral *peripheral, NSError *error) {
        if (!error) {
            NSLog(@"did discover peripherial %@", peripheral.peripheral.name);
            [self.peripheralsArray addObject:peripheral];
        }else{
            
        }
    }];
}


@end
