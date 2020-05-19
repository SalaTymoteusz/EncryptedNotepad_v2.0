//
//  NoteViewController.swift
//  EncryptedNotepad_v2.0
//
//  Created by xxx on 24/10/2019.
//  Copyright © 2019 xxx. All rights reserved.
//

import UIKit

import CryptoKit



class NoteViewController: UIViewController, UITextViewDelegate {
    

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var logOut: UINavigationItem!

    @objc func dismissKeyboard() {
      view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("NoteViewControler")
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        decrypt()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent {
            print("parent")
            encrypt(text: textView.text ?? "")
            
        }
    }

    //getting text
    func textViewDidEndEditing(_ textView: UITextView) {
        print("saving to file text: \(textView.text!)")
        encrypt(text: textView.text ?? "")
    }
    


    func encrypt(text: String) {
        let key = SymmetricKey(size: .bits256)
        let message = text.data(using: .utf8)!
        let sealedBox = try! ChaChaPoly.seal(message, using: key)

        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "sealedBox")
        defaults.set(sealedBox.combined, forKey: "sealedBox")
        
        let savedKey = key.withUnsafeBytes {Data(Array($0)).base64EncodedString()}
        Services.saveKey(key: savedKey)
        
        
    }
    
    func decrypt() {
        let savedKey = Services.getKey()
            
        if let keyData = Data(base64Encoded: savedKey) {
            let retrievedKey = SymmetricKey(data: keyData)
                
            let defaults = UserDefaults.standard
            let data = defaults.object(forKey: "sealedBox") as? Data

            let sealedBox = try! ChaChaPoly.SealedBox(combined: data!)
            let decryptedMessage = try! ChaChaPoly.open(sealedBox, using: retrievedKey)
        
            textView.text = String(data: decryptedMessage, encoding: .utf8)!
        }
    }
    
}
