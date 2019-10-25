//
//  ViewController.swift
//  EncryptedNotepad_v2.0
//
//  Created by xxx on 24/10/2019.
//  Copyright © 2019 xxx. All rights reserved.
//

import UIKit

struct passCodeKeyStruct {
    var status : Int
    var title : String
    var value : String
}


class ViewController: UIViewController {
    
    var passCodeKeyData : [passCodeKeyStruct] =
        [passCodeKeyStruct(status: 0, title: "1", value: "1"),
        passCodeKeyStruct(status: 0, title: "2", value: "2"),
        passCodeKeyStruct(status: 0, title: "3", value: "3"),
        passCodeKeyStruct(status: 0, title: "4", value: "4"),
        passCodeKeyStruct(status: 0, title: "5", value: "5"),
        passCodeKeyStruct(status: 0, title: "6", value: "6"),
        passCodeKeyStruct(status: 0, title: "7", value: "7"),
        passCodeKeyStruct(status: 0, title: "8", value: "8"),
        passCodeKeyStruct(status: 0, title: "9", value: "9"),
        passCodeKeyStruct(status: 1, title: "Clear", value: ""),
        passCodeKeyStruct(status: 0, title: "0", value: "0"),
        passCodeKeyStruct(status: 2, title: "Delete", value: "")]
    
    var inputKeycode : [String] = []
    
    @IBOutlet weak var keycode1: UIView!
    @IBOutlet weak var keycode2: UIView!
    @IBOutlet weak var keycode3: UIView!
    @IBOutlet weak var keycode4: UIView!
    
    private func setupKeyCodeView() {
        self.keycode1.layer.cornerRadius = 10
        self.keycode1.layer.borderWidth = 1
        self.keycode1.layer.borderColor = UIColor.black.cgColor
        self.keycode1.backgroundColor = UIColor.clear
        
        self.keycode2.layer.cornerRadius = 10
        self.keycode2.layer.borderWidth = 1
        self.keycode2.layer.borderColor = UIColor.black.cgColor
        self.keycode2.backgroundColor = UIColor.clear
        
        self.keycode3.layer.cornerRadius = 10
        self.keycode3.layer.borderWidth = 1
        self.keycode3.layer.borderColor = UIColor.black.cgColor
        self.keycode3.backgroundColor = UIColor.clear
        
        self.keycode4.layer.cornerRadius = 10
        self.keycode4.layer.borderWidth = 1
        self.keycode4.layer.borderColor = UIColor.black.cgColor
        self.keycode4.backgroundColor = UIColor.clear
        
        
        
        
    }
    

    
    let numberPadCollectionViewCell = "NumberPadCollectionViewCell"
    let textPadCollectionViewCell = "TextPadCollectionViewCell"
    @IBOutlet weak var passCodeCollectionView: UICollectionView!
    private func setupCollectionView() {
        self.passCodeCollectionView.register(UINib(nibName: self.numberPadCollectionViewCell, bundle: nil),  forCellWithReuseIdentifier: self.numberPadCollectionViewCell)
        
        self.passCodeCollectionView.register(UINib(nibName: self.textPadCollectionViewCell, bundle: nil),  forCellWithReuseIdentifier: self.textPadCollectionViewCell)
        
        self.passCodeCollectionView.dataSource = self
        self.passCodeCollectionView.delegate = self
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupCollectionView()
        self.clearInputKeycodeView()

    }
    
    func clearInputKeycodeView() {
        
        self.inputKeycode = []
        self.setupKeyCodeView()
        
    }
    
    func inputKeycodeAction() {
        
        self.setupKeyCodeView()
        
        if self.inputKeycode.count == 1 {
            self.keycode1.backgroundColor = UIColor.lightGray
        }
        
        if self.inputKeycode.count == 2 {
            self.keycode1.backgroundColor = UIColor.lightGray
            self.keycode2.backgroundColor = UIColor.lightGray
        }
        
        if self.inputKeycode.count == 3 {
            self.keycode1.backgroundColor = UIColor.lightGray
            self.keycode2.backgroundColor = UIColor.lightGray
            self.keycode3.backgroundColor = UIColor.lightGray
        }
  
  
  
        if self.inputKeycode.count == 4 {
            self.keycode1.backgroundColor = UIColor.lightGray
            self.keycode2.backgroundColor = UIColor.lightGray
            self.keycode3.backgroundColor = UIColor.lightGray
            self.keycode4.backgroundColor = UIColor.lightGray
        }
        
        if self.inputKeycode.count > 4 {
            self.keycode1.backgroundColor = UIColor.lightGray
            self.keycode2.backgroundColor = UIColor.lightGray
            self.keycode3.backgroundColor = UIColor.lightGray
            self.keycode4.backgroundColor = UIColor.lightGray
        }

    }


}

extension ViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.passCodeKeyData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let data = self.passCodeKeyData[indexPath.row]
        
        if data.status == 0 {
            let numCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.numberPadCollectionViewCell, for: indexPath) as! NumberPadCollectionViewCell
            numCell.setupCell(title: data.title)

            return numCell
        }
        
        
        let textCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.textPadCollectionViewCell, for: indexPath) as! TextPadCollectionViewCell
        textCell.setupCell(title: data.title)
        
        return textCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.width / 3
        let height = width
        
        return CGSize(width: width, height: height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let data = self.passCodeKeyData[indexPath.row]
        
        if data.status == 0 {
            self.inputKeycode.append(data.value)
            self.inputKeycodeAction()
            
        } else {
            if data.status == 1 {
                self.clearInputKeycodeView()
            }
            
            if data.status == 2 {
                if self.inputKeycode.count > 0 {
                    self.inputKeycode.remove(at: self.inputKeycode.count - 1)
                    self.inputKeycodeAction()
                }
            }
        }
        
    }
}
