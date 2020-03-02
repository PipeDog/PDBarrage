//
//  ViewController.m
//  PDBarrage
//
//  Created by liang on 2018/2/23.
//  Copyright © 2018年 PipeDog. All rights reserved.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>
#import "PDDanmakuController.h"

@interface ViewController () <PDDanmakuControllerDelegate, PDDanmakuControllerDataSource>

@property (weak, nonatomic) IBOutlet UIButton *sendBulletButton;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (nonatomic, strong) NSArray<NSString *> *dataArray;
@property (nonatomic, strong) PDDanmakuController *danmakuController;

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // Call resume to enter active status.
    [self.danmakuController resume];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self commitInit];
    [self createViewHierarchy];
    [self layoutContentViews];
}

- (void)commitInit {
    self.title = @"Bullet Test Page";
}

- (void)createViewHierarchy {
    [self addChildViewController:self.danmakuController];
    [self.view addSubview:self.danmakuController.view];
}

- (void)layoutContentViews {
    [self.danmakuController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100.f);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(200.f);
    }];
}

- (IBAction)didClickButton:(id)sender {
    NSString *text = self.dataArray[rand() % 10];
    [self.danmakuController receive:text];
}

#pragma mark - PDDanmakuControllerDelegate && PDDanmakuControllerDataSource
- (NSInteger)numberOfBeltsInDanmakuController:(PDDanmakuController *)danmakuController {
    return 4;
}

- (PDDanmakuItemCell *)cellForDataSource:(PDDanmakuDataSource)dataSource inDanmakuController:(PDDanmakuController *)danmakuController {
    PDDanmakuItemCell *cell = [[PDDanmakuItemCell alloc] init];
    cell.dataSource = dataSource;
    cell.velocity = 200.f;

    PDDanmakuItemCellPosition position = rand() % 3;
    cell.position = position;
    cell.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3f];
    return cell;
}

- (CGSize)sizeForCell:(PDDanmakuItemCell *)cell inDanmakuController:(PDDanmakuController *)danmakuController {
    return CGSizeMake(80.f, 30.f);
}

- (CGFloat)heightForBeltInDanmakuController:(PDDanmakuController *)danmakuController {
    return 40.f;
}

- (CGFloat)beltSpacingInDanmakuController:(PDDanmakuController *)danmakuController {
    return 10.f;
}

- (CGFloat)itemSpacingInDanmakuController:(PDDanmakuController *)danmakuController {
    return 30.f;
}

- (void)didClickCell:(__kindof PDDanmakuItemCell *)cell inDanmakuController:(PDDanmakuController *)danmakuController {
    self.textLabel.text = cell.dataSource;
}

#pragma mark - Getter Methods
- (NSArray<NSString *> *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@"将进酒",
                       @"君不见，黄河之水天上来",
                       @"奔流到海不复回",
                       @"君不见，高堂明镜悲白发，朝如青丝暮成雪",
                       @"人生得意须尽欢",
                       @"莫使金樽空对月",
                       @"天生我材必有用，千金散尽还复来",
                       @"烹羊宰牛且为乐，会须一饮三百杯",
                       @"岑夫子，丹丘生，将进酒，杯莫停",
                       @"与君歌一曲",
                       @"请君为我倾耳听"];
    }
    return _dataArray;
}

- (PDDanmakuController *)danmakuController {
    if (!_danmakuController) {
        _danmakuController = [[PDDanmakuController alloc] init];
        _danmakuController.delegate = self;
        _danmakuController.dataSource = self;
    }
    return _danmakuController;
}

@end
