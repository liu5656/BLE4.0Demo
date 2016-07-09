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

    CBUUID *serverUUID = [CBUUID UUIDWithString:@"FFF0"];
    CBUUID *characteristicUUID = [CBUUID UUIDWithString:@"FFF1"];
//    [CentralManager sharedInstance].currentConnectedPeripheral = self.peripheralsArray.lastObject;
//    [[CentralManager sharedInstance] connectPeripheralByCustomPreipheral:self.peripheralsArray.lastObject whichServer:serverUUID whichCharacteristic:characteristicUUID option:nil completion:^(CustomPeripheral *peripheral, CBService *server, NSError *error) {
//        if (!error) {
//            NSLog(@"---订阅成功");
//        }
//    }];
    
//    [[CentralManager sharedInstance].currentConnectedPeripheral observerCharacteristicUUID:characteristicUUID whileValueChangedBlock:^(NSError *error, pressButtonType type, CBCharacteristic *characteristic) {
//        if (!error) {
//            NSLog(@"222222值改变:%@",characteristic.value);
//        }
//    }];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.peripheralsArray = [NSMutableArray array];
//    [CentralManager sharedInstance];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    NSArray *uuids = @[[CBUUID UUIDWithString:@"FFF0"]];
//    [[CentralManager sharedInstance] scanPeripheralsByServices:uuids options:nil completion:^(CustomPeripheral *peripheral, NSError *error) {
//        if (!error) {
//            NSLog(@"did discover peripherial %@", peripheral.peripheral.name);
//            [self.peripheralsArray addObject:peripheral];
//        }else{
//            
//        }
//    }];
    
    [[CentralManager sharedInstance].currentConnectedPeripheral observerCharacteristicUUID:nil whileValueChangedBlock:^(NSError *error, pressButtonType type, CBCharacteristic *characteristic) {
        if (!error) {
            NSLog(@"222222值改变:%@",characteristic.value);
        }
    }];
    
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}


@end
