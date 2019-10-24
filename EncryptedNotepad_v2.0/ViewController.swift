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
    
    let passCodeKeyData : [passCodeKeyStruct] =
        [passCodeKeyStruct(status: 0, title: "1", value: "1"),
        passCodeKeyStruct(status: 0, title: "2", value: "1"),
        passCodeKeyStruct(status: 0, title: "3", value: "1"),
        passCodeKeyStruct(status: 0, title: "4", value: "1"),
        passCodeKeyStruct(status: 0, title: "5", value: "1"),
        passCodeKeyStruct(status: 0, title: "6", value: "1"),
        passCodeKeyStruct(status: 0, title: "7", value: "1"),
        passCodeKeyStruct(status: 0, title: "8", value: "1"),
        passCodeKeyStruct(status: 0, title: "9", value: "1"),
        passCodeKeyStruct(status: 1, title: "Clear", value: "1"),
        passCodeKeyStruct(status: 0, title: "0", value: "1"),
        passCodeKeyStruct(status: 1, title: "Delete", value: "1")]

    
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
}
