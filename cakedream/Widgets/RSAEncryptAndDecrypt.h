#import <UIKit/UIKit.h> 
#import <Security/Security.h> 
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@interface RSAEncryptAndDecrypt : NSObject 
{ 
    NSData *publicTag; 
    NSData *privateTag; 
    NSData *passTag;
} 

@property (nonatomic, retain) NSData * symmetricKey;

+ (RSAEncryptAndDecrypt *)sharedRSAEncryptAndDecrypt;
- (NSString *)getPublicKeyModExp;
- (void)testAsymmetricEncryptionAndDecryption; 
- (void)generateKeyPair; 
- (NSData *) decryptWithPrivateKeyByRSA:(NSString *)cipherString;
- (NSString *)doCipher:(NSString *)sTextIn context:(CCOperation)encryptOrDecrypt;
@end 
