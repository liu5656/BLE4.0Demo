//
//  ViewController.m
//  BLE4.0Demo
//
//  Created by 刘健 on 16/5/23.
//  Copyright © 2016年 刘健. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>


//@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, CBCentralManagerDelegate, CBPeripheralDelegate>
//
//@property (weak, nonatomic) IBOutlet UITableView *peripherTableView;
//@property (nonatomic, strong) CBCentralManager *centralManager;
//
//@property (nonatomic, strong) NSMutableArray *periphersArray;
//
//@property (nonatomic, strong) CBPeripheral *currentPeripheral;
//
//@property (nonatomic, strong) UIView *redView;
//
//@property (nonatomic, strong) NSUUID *currentPeripheralUUID;
//
//@end
//
//@implementation ViewController
//- (IBAction)searchPeripheralsAction:(UIButton *)sender {
//    NSLog(@"开始扫描");
//    NSArray *uuids = @[[CBUUID UUIDWithString:@"FFF0"]];
//    [self.centralManager scanForPeripheralsWithServices:uuids options:nil];
//    
//}
//
//#pragma marak cbperipheral delegate
//- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
//{
////    NSLog(@"peripheral did discover services\n%@",peripheral.services);
//    for (CBService *service in peripheral.services) {
//        NSLog(@"service :%@",service);
//        [peripheral discoverCharacteristics:nil forService:service];
//    }
//}
//
//- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
//{
////    NSLog(@"perupheral did discover characteristics:\n%@",service.characteristics);
//    
//    CBUUID *uuid = [CBUUID UUIDWithString:@"FFF1"];
//    for (CBCharacteristic *characteristic in service.characteristics) {
//        NSLog(@"%@'s characteristic is %@",service ,characteristic);
//        if ([characteristic.UUID isEqual:uuid]) {
//            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
//        }
//    
//    }
//}
//
//- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
//{
//    NSData *data = characteristic.value;
//    NSString *value4 = [self hexStringFromData:data];
//    NSInteger num = value4.integerValue;
//    switch (num) {
//        case 11:
//            
//            _redView.frame = CGRectMake(_redView.frame.origin.x, _redView.frame.origin.y - 10, 100, 100);
//            
//            break;
//        case 21:
//            _redView.frame = CGRectMake(_redView.frame.origin.x, _redView.frame.origin.y + 10, 100, 100);
//            break;
//        case 31:
//            _redView.frame = CGRectMake(_redView.frame.origin.x - 10, _redView.frame.origin.y, 100, 100);
//            break;
//        case 41:
//            _redView.frame = CGRectMake(_redView.frame.origin.x + 10, _redView.frame.origin.y, 100, 100);
//            break;
//            
//        default:
//            _redView.center = self.view.center;
//            break;
//    }
//    
//}
//
//- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
//{
//    NSLog(@"收到信息:%@",descriptor);
//}
//
//
//#pragma mark cbcentralmanager delegate
//- (void)centralManagerDidUpdateState:(CBCentralManager *)central
//{
//    
//    switch (central.state) {
//        case CBCentralManagerStateUnknown:
//            NSLog(@"CBCentralManagerStateUnknown");
//            break;
//        case CBCentralManagerStateResetting:
//            NSLog(@"CBCentralManagerStateResetting");
//            break;
//        case CBCentralManagerStateUnsupported:
//            NSLog(@"CBCentralManagerStateUnsupported");
//            break;
//        case CBCentralManagerStateUnauthorized:
//            NSLog(@"CBCentralManagerStateUnauthorized");
//            break;
//        case CBCentralManagerStatePoweredOff:
//            NSLog(@"蓝牙关闭状态--- CBCentralManagerStatePoweredOff");
//            break;
//        case CBCentralManagerStatePoweredOn:
//            NSLog(@"开始扫描---CBCentralManagerStatePoweredOn");
//            
//        {
//            NSArray *uuids = @[[CBUUID UUIDWithString:@"FFF0"]];
//            [self.centralManager scanForPeripheralsWithServices:uuids options:nil];
//        }
//            
//            break;
//            
//        default:
//            break;
//    }
//}
//
//#pragma mark CBCentralManagerDelegate
//- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
//{
//    NSData *data = [advertisementData objectForKey:@"kCBAdvDataManufacturerData"];
//    const char *cstring = [[data description] cStringUsingEncoding:NSUTF8StringEncoding];
////    NSLog(@"name:%@---功率:%@--广播内容:%@\n%s",peripheral.name, RSSI,advertisementData, cstring);
//    NSLog(@"name:%@",peripheral.name);
//    if (![self.periphersArray containsObject:peripheral]) {
//        peripheral.delegate = self;
//        [self.periphersArray addObject:peripheral];
//    }
//    [self.peripherTableView reloadData];
//}
//
//- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
//{
//    
//    NSLog(@"did connect peripheral uuid:\n%@",peripheral.identifier);
//    self.currentPeripheralUUID = peripheral.identifier;
//    [self.centralManager stopScan];
//    [peripheral discoverServices:nil];
//    
//}
//
//- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
//{
//    NSLog(@"did fail to connect peripheral:%@",error.localizedDescription);
//}
//
//- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
//{
//    NSLog(@"已经断开连接,开始尝试恢复连接:did disconnect peripheral :%@",error.localizedDescription);
//
//    
//    [self.centralManager connectPeripheral:self.currentPeripheral options:nil];
//
//}
//
//
//- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *,id> *)dict
//{
//    NSLog(@"will restore state:%@",dict);
//}
//
//#pragma mark uitableview datasource
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return self.periphersArray.count;
//}
//
//static NSString *IDENTIFY = @"identif";
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFY];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:IDENTIFY];
//    }
//    CBPeripheral *peripheral = self.periphersArray[indexPath.row];
//    cell.textLabel.text = peripheral.name;
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld",peripheral.services.count];
//    return cell;
//}
//
//#pragma mark uitableview delegate
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [self.centralManager stopScan];
//    CBPeripheral *peripheral = self.periphersArray[indexPath.row];
//    NSLog(@"did select peripheral:\n%@",peripheral.name);
//    self.currentPeripheral = peripheral;
//    NSLog(@"开始连接");
//    
//    [self.centralManager connectPeripheral:peripheral options:nil];
//}
//
//#pragma life circle
//- (void)initializeView
//{
//    _redView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//    _redView.center = self.view.center;
//    _redView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:_redView];
//}
//
//- (void)initializeDatasource
//{
//    [self centralManager];
//    
//}
//
////- (void)viewDidLoad {
////    [super viewDidLoad];
//////    [self initializeView];
//////    [self initializeDatasource];
////}
//
//
//#pragma mark get
//
//- (NSMutableArray *)periphersArray
//{
//    if (!_periphersArray) {
//        _periphersArray = [NSMutableArray array];
//    }
//    return _periphersArray;
//}
//
//- (CBCentralManager *)centralManager
//{
//    if (!_centralManager) {
//        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:@{CBCentralManagerOptionRestoreIdentifierKey:@"centamlManagerIdentify"}];
//    }
//    return _centralManager;
//}
//
//
//
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//
//
//- (NSString *)hexStringFromData:(NSData*)data{
//    return [[[[NSString stringWithFormat:@"%@",data]
//              stringByReplacingOccurrencesOfString: @"<" withString: @""]
//             stringByReplacingOccurrencesOfString: @">" withString: @""]
//            stringByReplacingOccurrencesOfString: @" " withString: @""];
//}

#import "CentralManager.h"
#import "CustomPeripheral.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, strong)NSMutableArray *peripheralsArray;

@end

@implementation ViewController
- (IBAction)connectAction:(UIButton *)sender {
    
    CBUUID *serverUUID = [CBUUID UUIDWithString:@"FFF0"];
    CBUUID *characteristicUUID = [CBUUID UUIDWithString:@"FFF1"];
    [CentralManager sharedInstance].currentConnectedPeripheral = self.peripheralsArray.lastObject;
    [[CentralManager sharedInstance] connectPeripheralByCustomPreipheral:self.peripheralsArray.lastObject whichServer:serverUUID whichCharacteristic:characteristicUUID option:nil completion:^(CustomPeripheral *peripheral, CBService *server, NSError *error) {
        if (!error) {
            NSLog(@"---订阅成功");
        }
    }];
    
    [[CentralManager sharedInstance].currentConnectedPeripheral observerCharacteristicUUID:characteristicUUID whileValueChangedBlock:^(NSError *error, pressButtonType type, CBCharacteristic *characteristic) {
        if (!error) {
            NSLog(@"111111值改变:%@",characteristic.value);
        }
    }];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.peripheralsArray = [NSMutableArray array];
//    [CentralManager sharedInstance];
    
    NSArray *uuids = @[[CBUUID UUIDWithString:@"FFF0"]];
    [[CentralManager sharedInstance] scanPeripheralsByServices:uuids options:nil completion:^(CustomPeripheral *peripheral, NSError *error) {
        if (!error) {
            NSLog(@"did discover peripherial %@", peripheral.peripheral.name);
            [self.peripheralsArray addObject:peripheral];
        }else{
            
        }
    }];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    
    [[CentralManager sharedInstance].currentConnectedPeripheral observerCharacteristicUUID:nil whileValueChangedBlock:^(NSError *error, pressButtonType type, CBCharacteristic *characteristic) {
        if (!error) {
            NSLog(@"111111值改变:%@",characteristic.value);
        }
    }];
}



@end
