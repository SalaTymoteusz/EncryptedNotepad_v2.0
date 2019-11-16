//
//  NoteViewController.swift
//  EncryptedNotepad_v2.0
//
//  Created by xxx on 24/10/2019.
//  Copyright © 2019 xxx. All rights reserved.
//

import UIKit
import CommonCrypto
import SwiftKeychainWrapper


class NoteViewController: UIViewController, UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        //saving text
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("saving.txt")
        do{
            try textView.text.write(to: path!, atomically: true, encoding: .utf8)
        }catch{
            //correct this exception?
        }
    }
    
    func setLogoutButton() {
        logout.layer.cornerRadius = 25
        logout.layer.borderWidth = 2
        logout.layer.borderColor = UIColor.black.cgColor
    }
    
    // it change VC
    private func navigatedToCodeVC() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let mainNavigationVC = mainStoryboard.instantiateViewController(withIdentifier: "codeView") as? ViewController else {
            return
        }
        mainNavigationVC.modalPresentationStyle = .fullScreen
        present(mainNavigationVC, animated: true, completion: nil)
        
        hashText()
    }
    
    func hashText() {
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("saving.txt")
        do{
            let text = textView.text
            let encryptedText = text!.aesEncrypt(key: saveKey(), iv: "utf-8")
            try encryptedText!.write(to: path!, atomically: true, encoding: .utf8)
        }catch{
            
        }
    }
    
    func saveKey() -> String{
        let key = UUID().uuidString
        let _: Bool = KeychainWrapper.standard.set(key, forKey: "key")
        
        return key
    }
    
    func loadKey() -> String? {
        let key: String? = KeychainWrapper.standard.string(forKey: "key")
    
        return key!
    }
                
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var logout: UIButton!
    @IBAction func logoutTapped(_ sender: Any) {
        navigatedToCodeVC()
    }
    
    @objc func dismissKeyboard() {
      view.endEditing(true)
    }
    
    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            setLogoutButton()
            
            if loadKey() == nil {
                saveKey()
            }
            
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
            view.addGestureRecognizer(tap)
            
            let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("saving.txt")
                    
                    do{
                    let input = try String(contentsOf: path!)
                        textView.text = input.aesDecrypt(key: loadKey()!, iv: "utf-8")
                    }catch{
                        
                    }
                }

                override func didReceiveMemoryWarning() {
                    super.didReceiveMemoryWarning()
                }


            }

public extension String {

    func aesEncrypt(key:String, iv:String, options:Int = kCCOptionPKCS7Padding) -> String? {
        if let keyData = key.data(using: String.Encoding.utf8),
            let data = self.data(using: String.Encoding.utf8),
            let cryptData    = NSMutableData(length: Int((data.count)) + kCCBlockSizeAES128) {


            let keyLength              = size_t(kCCKeySizeAES128)
            let operation: CCOperation = UInt32(kCCEncrypt)
            let algoritm:  CCAlgorithm = UInt32(kCCAlgorithmAES128)
            let options:   CCOptions   = UInt32(options)



            var numBytesEncrypted :size_t = 0

            let cryptStatus = CCCrypt(operation,
                                      algoritm,
                                      options,
                                      (keyData as NSData).bytes, keyLength,
                                      iv,
                                      (data as NSData).bytes, data.count,
                                      cryptData.mutableBytes, cryptData.length,
                                      &numBytesEncrypted)

            if UInt32(cryptStatus) == UInt32(kCCSuccess) {
                cryptData.length = Int(numBytesEncrypted)
                let base64cryptString = cryptData.base64EncodedString(options: .lineLength64Characters)
                return base64cryptString


            }
            else {
                return nil
            }
        }
        return nil
    }

    func aesDecrypt(key:String, iv:String, options:Int = kCCOptionPKCS7Padding) -> String? {
        if let keyData = key.data(using: String.Encoding.utf8),
            let data = NSData(base64Encoded: self, options: .ignoreUnknownCharacters),
            let cryptData    = NSMutableData(length: Int((data.length)) + kCCBlockSizeAES128) {

            let keyLength              = size_t(kCCKeySizeAES128)
            let operation: CCOperation = UInt32(kCCDecrypt)
            let algoritm:  CCAlgorithm = UInt32(kCCAlgorithmAES128)
            let options:   CCOptions   = UInt32(options)

            var numBytesEncrypted :size_t = 0

            let cryptStatus = CCCrypt(operation,
                                      algoritm,
                                      options,
                                      (keyData as NSData).bytes, keyLength,
                                      iv,
                                      data.bytes, data.length,
                                      cryptData.mutableBytes, cryptData.length,
                                      &numBytesEncrypted)

            if UInt32(cryptStatus) == UInt32(kCCSuccess) {
                cryptData.length = Int(numBytesEncrypted)
                let unencryptedMessage = String(data: cryptData as Data, encoding:String.Encoding.utf8)
                return unencryptedMessage
            }
            else {
                return nil
            }
        }
        return nil
    }


}
