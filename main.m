#import <Foundation/Foundation.h>

@class PaymentGateway;

@protocol PaymentDelegate <NSObject>

- (void)processPaymentAmount:(NSInteger)amount;
- (BOOL)canProcessPayment;

@end

@interface PaymentGateway : NSObject{
  id<PaymentDelegate> paymentDelegate;
}

@property (nonatomic, assign) id<PaymentDelegate> paymentDelegate;

- (void)processPaymentAmount:(NSInteger)amount;

@end

@implementation PaymentGateway

@synthesize paymentDelegate;

- (void)processPaymentAmount:(NSInteger)amount {
    if([self.paymentDelegate canProcessPayment] == YES) {
        [self.paymentDelegate processPaymentAmount:amount];
    }
}

@end

@interface PaypalPaymentService : NSObject<PaymentDelegate>

@end

@implementation PaypalPaymentService

- (void)processPaymentAmount:(NSInteger)amount {
    NSLog(@"Paypal processed amount: %lf", (int)amount * 1.5);
}

- (BOOL)canProcessPayment {
    srand((unsigned)time(NULL));
    if (rand()%2 == 0) {
        return NO;
    }else {
        return YES;
    }
}


@end

@interface StripePaymentService : NSObject<PaymentDelegate>

@end

@implementation StripePaymentService

- (void)processPaymentAmount:(NSInteger)amount {
    NSLog(@"Stripe processed amount: %lf", (int)amount * 1.2);
}

- (BOOL)canProcessPayment {
    srand((unsigned)time(NULL));
    if (rand()%2 == 0) {
        return NO;
    }else {
        return YES;
    }
}


@end

@interface AmazonPaymentService : NSObject<PaymentDelegate>

@end

@implementation AmazonPaymentService

- (void)processPaymentAmount:(NSInteger)amount {
    NSLog(@"Amazon processed amount: %lf", (int)amount * 0.9);
}

- (BOOL)canProcessPayment {
    srand((unsigned)time(NULL));
    if (rand()%2 == 0) {
        return NO;
    }else {
        return YES;
    }
}


@end

int main(int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

    PaymentGateway *paymentGateway = [[PaymentGateway alloc] init];
    PaypalPaymentService *paypal = [[PaypalPaymentService alloc] init];
    StripePaymentService *stripe = [[StripePaymentService alloc] init];
    AmazonPaymentService *amazon = [[AmazonPaymentService alloc] init];


    srand((unsigned)time(NULL));
    NSInteger doller = rand()%901 + 100;

    NSLog(@"Thank you for shopping at Acme.com Your total today is $%ld Please select your payment method: 1: Paypal, 2: Stripe, 3: Amazon", (long)doller);
    char buf[100];
    fgets (buf, 100, stdin);

    NSString *input = [[NSString alloc] initWithUTF8String:buf];
    input = [input stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSLog(@"input %d", [input intValue]);

    switch ([input intValue]) {
        case 1:
            paymentGateway.paymentDelegate = paypal;
            break;
        case 2:
            paymentGateway.paymentDelegate = stripe;
            break;
        case 3:
            paymentGateway.paymentDelegate = amazon;
            break;

        default:
            break;
    }

    [paymentGateway processPaymentAmount:doller];

    [pool drain];

    return 0;
}
