//
//  KeyRingTests.swift
//  tw2023_walletTests
//
//  Created by 若葉良介 on 2023/12/27.
//

import XCTest

class KeyRingTests: XCTestCase {

    func testGenerateSeed() {
        if let keyRing = HDKeyRing() {
            let mnemonicWords = keyRing.getMnemonicString()!.split(separator: " ")
            XCTAssertEqual(mnemonicWords.count, 12)

            let keyRing256 = HDKeyRing(entropyLength: 256)
            let mnemonicWords256 = keyRing256?.getMnemonicString()?.split(separator: " ")
            XCTAssertEqual(mnemonicWords256?.count, 24)
        }
    }

    func testRestoreFromSeed() {
        if let keyRing = HDKeyRing() {
            let mnemonicWords = keyRing.getMnemonicString()
            print("mnemonick: \(mnemonicWords!)")
            
            let (x1, _) = keyRing.getPublicKey(index: 0)
            let (x2, _) = keyRing.getPublicKey(index: 1)
            let (x100, _) = keyRing.getPublicKey(index: 99)
            
            if let mnemonicWords = mnemonicWords, let keyRingRecovered = HDKeyRing(mnemonicWords: mnemonicWords) {
                print("mnemonick: \(mnemonicWords)")
                
                let (x1Recovered, _) = keyRingRecovered.getPublicKey(index: 0)
                let (x2Recovered, _) = keyRingRecovered.getPublicKey(index: 1)
                let (x100Recovered, _) = keyRingRecovered.getPublicKey(index: 99)
                XCTAssertEqual(x1, x1Recovered)
                XCTAssertEqual(x2, x2Recovered)
                XCTAssertEqual(x100, x100Recovered)
            }
        }
    }
    
    func testRestoreFromMnemonicGeneratedByKotlinImplementaion() {
        let mnemonicWords = "polar write glimpse live earn ball awake cancel math oil casino lab"
        if let keyRing = HDKeyRing(mnemonicWords: mnemonicWords) {
            let (x, _) = keyRing.getPublicKey(index: 1)
            // value generated by kotlin
            let exptected = "anRguONRC1_xRfcTH8uYF8Xp9ziUvAorE5UnOfJvWtk"
            XCTAssertEqual(x.base64EncodedString().base64ToBase64url(), exptected)
        }
    }
}
