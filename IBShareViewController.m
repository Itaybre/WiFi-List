#import "IBShareViewController.h"
#import "IBWiFiNetwork.h"

#define PADING 50

@interface IBShareViewController ()
@property (nonatomic, strong) IBWiFiNetwork *network;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *qrImage;
@end

@implementation IBShareViewController

- (instancetype) initWithNetwork:(IBWiFiNetwork *)network {
    if (self = [super init]) {
        self.network = network;
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];

    self.title = @"Share WiFi Network";

    [self addImageView];
    NSString *qrMessage = [self buildQrMessage];
    [self createQr:qrMessage];

    self.view.backgroundColor = [UIColor whiteColor];
    self.imageView.backgroundColor = [UIColor redColor];
}

- (NSString *) buildQrMessage {
    NSString *SSID = [self encodeString:self.network.name];
    NSString *password = [self encodeString:self.network.password];
    NSString *encryption = self.network.encryption == WEP ? @"WEP" : self.network.encryption == WPA ? @"WPA" : self.network.encryption == EAP ? @"WPA2-EAP" : @"nopass";
    NSString *hidden = self.network.isHidden ? @"true" : @"false";

    return [NSString stringWithFormat:@"WIFI:S:%@;T:%@;P:%@;H:%@;;", SSID, encryption, password, hidden];
}

- (NSString *) encodeString: (NSString *) string {
    string = [string stringByReplacingOccurrencesOfString: @"\\" withString:@"\\\\"];
    string = [string stringByReplacingOccurrencesOfString: @";" withString:@"\\;"];
    string = [string stringByReplacingOccurrencesOfString: @"," withString:@"\\,"];
    return [string stringByReplacingOccurrencesOfString: @":" withString:@"\\:"];
}

- (void) createQr:(NSString *) message {
    NSData *stringData = [message dataUsingEncoding: NSISOLatin1StringEncoding];

    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];

    CIImage *qrImage = qrFilter.outputImage;
    float scaleX = self.view.frame.size.width / qrImage.extent.size.width;
    float scaleY = self.view.frame.size.width / qrImage.extent.size.height;

    qrImage = [qrImage imageByApplyingTransform:CGAffineTransformMakeScale(scaleX, scaleY)];

    self.imageView.image = [UIImage imageWithCIImage:qrImage
                                            scale:[UIScreen mainScreen].scale
                                       orientation:UIImageOrientationUp];
}

- (void) addImageView {
    self.imageView = [[UIImageView alloc] init];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.imageView];

    NSLayoutConstraint *centerX = [NSLayoutConstraint
                                constraintWithItem:self.imageView
                                attribute:NSLayoutAttributeCenterX
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.view   
                                attribute:NSLayoutAttributeCenterX
                                multiplier:1.0f
                                constant:0.f];
    
    NSLayoutConstraint *centerY = [NSLayoutConstraint
                                constraintWithItem:self.imageView
                                attribute:NSLayoutAttributeCenterY
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.view   
                                attribute:NSLayoutAttributeCenterY
                                multiplier:1.0f
                                constant:0.f];

    NSLayoutConstraint *width = [NSLayoutConstraint
                               constraintWithItem:self.imageView
                               attribute:NSLayoutAttributeWidth
                               relatedBy:NSLayoutRelationEqual
                               toItem:self.view
                               attribute:NSLayoutAttributeWidth
                               multiplier:1
                               constant:-PADING];

    NSLayoutConstraint *height = [NSLayoutConstraint
                               constraintWithItem:self.imageView
                               attribute:NSLayoutAttributeWidth
                               relatedBy:NSLayoutRelationEqual
                               toItem:self.imageView
                               attribute:NSLayoutAttributeHeight
                               multiplier:1
                               constant:0.f];

    [self.view addConstraints:@[centerX, centerY, width, height]];
}

@end