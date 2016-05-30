//
//  ViewController.m
//  BLE4.0Demo
//
//  Created by 刘健 on 16/5/23.
//  Copyright © 2016年 刘健. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>


@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, CBCentralManagerDelegate, CBPeripheralDelegate>

@property (weak, nonatomic) IBOutlet UITableView *peripherTableView;
@property (nonatomic, strong) CBCentralManager *centralManager;

@property (nonatomic, strong) NSMutableArray *periphersArray;

@property (nonatomic, strong) CBPeripheral *currentPeripheral;


@end

@implementation ViewController
- (IBAction)searchPeripheralsAction:(UIButton *)sender {
    NSLog(@"开始扫描");
    [self.centralManager scanForPeripheralsWithServices:nil options:nil];
}

#pragma marak cbperipheral delegate
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
//    NSLog(@"peripheral did discover services\n%@",peripheral.services);
    for (CBService *service in peripheral.services) {
        NSLog(@"service :%@",service);
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
//    NSLog(@"perupheral did discover characteristics:\n%@",service.characteristics);
    
    CBUUID *uuid = [CBUUID UUIDWithString:@"FFF1"];
    for (CBCharacteristic *characteristic in service.characteristics) {
        NSLog(@"%@'s characteristic is %@",service ,characteristic);
        if ([characteristic.UUID isEqual:uuid]) {
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
        
        
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"receive message:\n%@",characteristic);
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    NSLog(@"收到信息:%@",descriptor);
}


#pragma mark cbcentralmanager delegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"peripheral ---- %@",central);
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSData *data = [advertisementData objectForKey:@"kCBAdvDataManufacturerData"];
    const char *cstring = [[data description] cStringUsingEncoding:NSUTF8StringEncoding];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"name:%@-----广播内容:%@\n%s",peripheral.name, advertisementData, cstring);
    if (![self.periphersArray containsObject:peripheral]) {
        peripheral.delegate = self;
        [self.periphersArray addObject:peripheral];
    }
    [self.peripherTableView reloadData];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"did connect peripheral:\n%@",peripheral);
    [self.centralManager stopScan];
    [peripheral discoverServices:nil];
    
}

#pragma mark uitableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.periphersArray.count;
}

static NSString *IDENTIFY = @"identif";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFY];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:IDENTIFY];
    }
    CBPeripheral *peripheral = self.periphersArray[indexPath.row];
    cell.textLabel.text = peripheral.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld",peripheral.services.count];
    return cell;
}

#pragma mark uitableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBPeripheral *peripheral = self.periphersArray[indexPath.row];
    NSLog(@"did select peripheral:\n%@",peripheral.name);
    self.currentPeripheral = peripheral;
    NSLog(@"开始连接");
    [self.centralManager connectPeripheral:peripheral options:nil];
}

#pragma life circle
- (void)initializeView
{
    
}

- (void)initializeDatasource
{
    [self centralManager];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeView];
    [self initializeDatasource];
}


#pragma mark get
- (NSMutableArray *)periphersArray
{
    if (!_periphersArray) {
        _periphersArray = [NSMutableArray array];
    }
    return _periphersArray;
}

- (CBCentralManager *)centralManager
{
    if (!_centralManager) {
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
    }
    return _centralManager;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
