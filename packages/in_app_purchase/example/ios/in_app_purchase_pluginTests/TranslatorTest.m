// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <XCTest/XCTest.h>
#import "FIAObjectTranslator.h"
#import "Stubs.h"

@interface TranslatorTest : XCTestCase

@property(strong, nonatomic) NSDictionary *periodMap;
@property(strong, nonatomic) NSDictionary *discountMap;
@property(strong, nonatomic) NSDictionary *productMap;
@property(strong, nonatomic) NSDictionary *productResponseMap;
@property(strong, nonatomic) NSDictionary *downloadMap;
@property(strong, nonatomic) NSDictionary *paymentMap;
@property(strong, nonatomic) NSDictionary *transactionMap;
@property(strong, nonatomic) NSDictionary *errorMap;
@property(strong, nonatomic) NSDictionary *localeMap;

@end

@implementation TranslatorTest

- (void)setUp {
  self.periodMap = @{@"numberOfUnits" : @(0), @"unit" : @(0)};
  self.discountMap = @{
    @"price" : @1.0,
    @"priceLocale" : [NSLocale.systemLocale toMap],
    @"numberOfPeriods" : @1,
    @"subscriptionPeriod" : self.periodMap,
    @"paymentMode" : @1
  };
  self.productMap = @{
    @"price" : @1.0,
    @"priceLocale" : [NSLocale.systemLocale toMap],
    @"productIdentifier" : @"123",
    @"localizedTitle" : @"title",
    @"localizedDescription" : @"des",
    @"downloadable" : @YES,
    @"downloadContentLengths" : @1,
    @"downloadContentVersion" : [NSNull null],  // not mockable
    @"subscriptionPeriod" : self.periodMap,
    @"introductoryPrice" : self.discountMap,
    @"subscriptionGroupIdentifier" : @"com.group"
  };
  self.productResponseMap =
      @{@"products" : @[ self.productMap ], @"invalidProductIdentifiers" : @[]};
  self.downloadMap = @{
    @"state" : @(0),
    @"contentIdentifier" : [NSNull null],
    @"contentLength" : @(2),
    @"contentURL" : @"https://flutter.io",
    @"contentVersion" : [NSNull null],
    @"error" : [[NSError errorWithDomain:@"test_stub" code:123 userInfo:@{}] toMap],
    @"progress" : @(0.5),
    @"timeRemaining" : @(100),
    @"downloadTimeUnKnown" : @(NO),
    @"transactionID" : [NSNull null],
  };
  self.paymentMap = @{
    @"productIdentifier" : @"123",
    @"requestData" : @"abcdefghabcdefghabcdefghabcdefghabcdefghabcdefghabcdefghabcdefgh",
    @"quantity" : @(2),
    @"applicationUsername" : @"app user name",
    @"simulatesAskToBuyInSandbox" : @(NO)
  };
  NSDictionary *originalTransactionMap = @{
    @"transactionIdentifier" : @"567",
    @"transactionState" : @(SKPaymentTransactionStatePurchasing),
    @"payment" : [NSNull null],
    @"error" : [[NSError errorWithDomain:@"test_stub" code:123 userInfo:@{}] toMap],
    @"transactionTimeStamp" : @([NSDate date].timeIntervalSince1970),
    @"originalTransaction" : [NSNull null],
    @"downloads" : @[ @{
      @"state" : @(0),
      @"contentIdentifier" : [NSNull null],
      @"contentLength" : @(2),
      @"contentURL" : @"https://flutter.io",
      @"contentVersion" : [NSNull null],
      @"error" : [[NSError errorWithDomain:@"test_stub" code:123 userInfo:@{}] toMap],
      @"progress" : @(0.5),
      @"timeRemaining" : @(100),
      @"downloadTimeUnKnown" : @(NO),
      @"transactionID" : @"567",
    } ]
  };
  self.transactionMap = @{
    @"transactionIdentifier" : @"567",
    @"transactionState" : @(SKPaymentTransactionStatePurchasing),
    @"payment" : [NSNull null],
    @"error" : [[NSError errorWithDomain:@"test_stub" code:123 userInfo:@{}] toMap],
    @"transactionTimeStamp" : @([NSDate date].timeIntervalSince1970),
    @"originalTransaction" : originalTransactionMap,
    @"downloads" : @[ @{
      @"state" : @(0),
      @"contentIdentifier" : [NSNull null],
      @"contentLength" : @(2),
      @"contentURL" : @"https://flutter.io",
      @"contentVersion" : [NSNull null],
      @"error" : [[NSError errorWithDomain:@"test_stub" code:123 userInfo:@{}] toMap],
      @"progress" : @(0.5),
      @"timeRemaining" : @(100),
      @"downloadTimeUnKnown" : @(NO),
      @"transactionID" : @"567",
    } ]
  };
  self.errorMap = @{
    @"code" : @(123),
    @"domain" : @"test_domain",
    @"userInfo" : @{
      @"key" : @"value",
    }
  };
}

- (void)testSKProductSubscriptionPeriodStubToMap {
  SKProductSubscriptionPeriodStub *period =
      [[SKProductSubscriptionPeriodStub alloc] initWithMap:self.periodMap];
  NSDictionary *map = [period toMap];
  XCTAssertEqualObjects(map, self.periodMap);
}

- (void)testSKProductDiscountStubToMap {
  SKProductDiscountStub *discount = [[SKProductDiscountStub alloc] initWithMap:self.discountMap];
  NSDictionary *map = [discount toMap];
  XCTAssertEqualObjects(map, self.discountMap);
}

- (void)testProductToMap {
  SKProductStub *product = [[SKProductStub alloc] initWithMap:self.productMap];
  NSDictionary *map = [product toMap];
  XCTAssertEqualObjects(map, self.productMap);
}

- (void)testProductResponseToMap {
  SKProductsResponseStub *response =
      [[SKProductsResponseStub alloc] initWithMap:self.productResponseMap];
  NSDictionary *map = [response toMap];
  XCTAssertEqualObjects(map, self.productResponseMap);
}

- (void)testDownloadToMap {
  // bug with state, downloadTimeUnKnown, transaction and contentIdentifer in KVC, cannot test these
  // fields.
  SKDownloadStub *download = [[SKDownloadStub alloc] initWithMap:self.downloadMap];
  NSDictionary *map = [download toMap];
  XCTAssertEqualObjects(map, self.downloadMap);
}

- (void)testPaymentToMap {
  SKMutablePayment *payment = [[SKMutablePayment alloc] initWithMap:self.paymentMap];
  NSDictionary *map = [payment toMap];
  XCTAssertEqualObjects(map, self.paymentMap);
}

- (void)testPaymentTransactionToMap {
  // payment is not KVC, cannot test payment field.
  SKPaymentTransactionStub *paymentTransaction =
      [[SKPaymentTransactionStub alloc] initWithMap:self.transactionMap];
  NSDictionary *map = [paymentTransaction toMap];
  XCTAssertEqualObjects(map, self.transactionMap);
}

- (void)testError {
  NSErrorStub *error = [[NSErrorStub alloc] initWithMap:self.errorMap];
  NSDictionary *map = [error toMap];
  XCTAssertEqualObjects(map, self.errorMap);
}

- (void)testLocaleToMap {
  NSLocale *system = NSLocale.systemLocale;
  NSDictionary *map = [system toMap];
  XCTAssertEqualObjects(map[@"currencySymbol"], system.currencySymbol);
}

@end
