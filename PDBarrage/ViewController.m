//
//  ViewController.m
//  PDBarrage
//
//  Created by liang on 2018/2/23.
//  Copyright © 2018年 PipeDog. All rights reserved.
//

#import "ViewController.h"
#import "PDBarrage.h"
#import <Masonry/Masonry.h>
#import "UIColor+PDAdd.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *sendBulletButton;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (nonatomic, strong) PDBulletController *bulletController;
@property (nonatomic, strong) NSArray<NSString *> *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"Bullet Test Page";
    [self layoutUI];
    [self observeTouchBulletEvent];
}

- (void)layoutUI {
    CGFloat const bulletControllerHeight = PDBulletControllerTrajectoryViewHeight * self.bulletController.trajectoryCount;
    
    [self.bulletController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.left.equalTo(self.view);
        make.bottom.equalTo(self.textLabel.mas_top);
        make.height.mas_equalTo(bulletControllerHeight);
    }];
}

- (void)observeTouchBulletEvent {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchInsideBulletNotification:) name:PDBulletControllerTouchBulletNotification object:nil];
}

- (void)touchInsideBulletNotification:(NSNotification *)notification {
    PDBulletEntity *entity = notification.object;
    self.textLabel.text = entity.text;
}

- (IBAction)didClickButton:(id)sender {
    PDBulletEntity *entity = [[PDBulletEntity alloc] init];
    entity.text = self.dataArray[rand() % 10];
    entity.textColorValue = @"0xFFFFFF";
    entity.backgroundColorValue = @"#5566FF99";
    [self.bulletController receiveMessage:entity];
}

#pragma mark - Getter Methods
- (PDBulletController *)bulletController {
    if (!_bulletController) {
        _bulletController = [[PDBulletController alloc] init];
        _bulletController.trajectoryCount = 3;
        _bulletController.view.backgroundColor = UIColorHex(0xFFDD00);
        [self.view addSubview:_bulletController.view];
    }
    return _bulletController;
}

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

@end
