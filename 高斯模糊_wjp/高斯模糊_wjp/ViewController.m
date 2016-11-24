//
//  ViewController.m
//  高斯模糊_wjp
//
//  Created by 魏鹏 on 15/10/9.
//  Copyright (c) 2015年 魏鹏. All rights reserved.
//

#import "ViewController.h"
//#import "GPUImage.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define StatusBarHeight 20
#define NavigationHeight 44
#define TabBarHeight 49
#define ToolBarHeight 44
@interface ViewController () <UITextFieldDelegate>
{
    NSData *_imageData;
    NSArray *_blurArray;
}
@property (nonatomic, weak) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *normalImageBtn;
@property (weak, nonatomic) IBOutlet UIButton *coreImageBtn;
@property (weak, nonatomic) IBOutlet UITextField *coreImageText;
@property (weak, nonatomic) IBOutlet UITextField *blurText;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //coreImage效果
    _blurArray = @[@"CIBoxBlur", @"CIDiscBlur", @"CIGaussianBlur", @"CIMaskedVariableBlur", @"CIMedianFilter", @"CIMotionBlur", @"CINoiseReduction", @"CIZoomBlur"];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth, 300)];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"swift.jpeg" ofType:nil];
    _imageData = [NSData dataWithContentsOfFile:imagePath];
    self.imageView = imageView;
    UIImage *image = [[UIImage alloc] initWithData:_imageData];
    imageView.image = image;
    [self.view addSubview:imageView];
    
}

- (IBAction)normalImageBtnClick:(id)sender
{
    UIImage *image = [[UIImage alloc] initWithData:_imageData];
    self.imageView.image = image;
}
- (IBAction)gpuImageBtnClick:(id)sender
{
//    GPUImageGaussianBlurFilter * blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
//    blurFilter.blurRadiusInPixels = 2.0;
//    UIImage * image = [[UIImage alloc] initWithData:_imageData];
//    UIImage *blurredImage = [blurFilter imageByFilteringImage:image];
//    self.imageView.image = blurredImage;
}

- (IBAction)coreImageBtnClick:(id)sender
{
    NSLog(@"%@", self.coreImageText.text);
    float radiusValue = [self.coreImageText.text floatValue];
    radiusValue = radiusValue > 50 ? 50 : radiusValue;
    int blurNum = [self.blurText.text intValue];
    blurNum = blurNum > 7 ? 7 : blurNum;
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *image = [CIImage imageWithData:_imageData];
    CIFilter *filter = [CIFilter filterWithName:_blurArray[blurNum]];
    [filter setValue:image forKey:kCIInputImageKey];
    if (blurNum != 4 && blurNum != 6)
        [filter setValue:@(radiusValue) forKey: @"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage = [context createCGImage: result fromRect:[result extent]];
    UIImage * blurImage = [UIImage imageWithCGImage:outImage];
    self.imageView.image = blurImage;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
