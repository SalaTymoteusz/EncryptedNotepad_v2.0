//
//  ViewController.swift
//  EncryptedNotepad_v2.0
//
//  Created by xxx on 24/10/2019.
//  Copyright © 2019 xxx. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import AVFoundation



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
        passCodeKeyStruct(status: 2, title: "Edit", value: "")]
    
    
    
    
    var inputKeycode : [String] = [] // array for code
    var isEdit : Bool = false   // true when the user tries to change the password and provides the correct current password
    
    var allowToEdit : Bool = false // variable = true when user taped 'Edit' button
    var delayDate : Date = Date() // variable declaration date of login attempt again
    var counterOfWrongAnswer : Int = 0 // variable declaration counter of wrong answer

    
    // UIView of all four password dots
    @IBOutlet weak var keycode1: UIView!
    @IBOutlet weak var keycode2: UIView!
    @IBOutlet weak var keycode3: UIView!
    @IBOutlet weak var keycode4: UIView!
    
    // infoLabel is label above dots, showing actual informations for user
    @IBOutlet weak var infoLabel: UILabel!
    
    
    // function set up view of dots
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
        
        // if code wasn't created, setup delay date and counter value
        if isCode() == false {
            saveNewDelayDate(delayDate: Date(), time: 0)
            saveCounterValue(counterValue: 0)
        }
        
        // setup delay date
        delayDate = loadDelayDate()
        
        // setup counter of wrong answer
        counterOfWrongAnswer = loadCounterValue()
        
        
        // After run, check if the user has blocked the application after too many incorrectly entered codes
        if compareDates(delayDate: delayDate) == false {
            infoLabel.text = "Wait till: \(dateToString(date: delayDate))"
            infoLabel.textColor = UIColor.red
        }else {
            let retrievedString: String? = KeychainWrapper.standard.string(forKey: "code")
    
            if retrievedString != nil {
                infoLabel.text = "Enter code"
                infoLabel.textColor = UIColor.black
            } else {
                saveCounterValue(counterValue: 0)
                infoLabel.text = "Enter new code"
                infoLabel.textColor = UIColor.black
            }
        }
    }
    
    
    func clearInputKeycodeView() {
        self.inputKeycode = []
        self.setupKeyCodeView()
    }
    
    // create code and add it to KeyChain
    private func createCode() {
        let _: Bool = KeychainWrapper.standard.removeObject(forKey: "code")
        let input = inputKeycode.joined(separator: "")
        let _: Bool = KeychainWrapper.standard.set(input, forKey: "code")
        infoLabel.text = "Enter code"
        infoLabel.textColor = UIColor.black
    }
    
    // check if user have a set password
    private func isCode() -> (Bool) {
        let retrievedString: String? = KeychainWrapper.standard.string(forKey: "code")
        if retrievedString == nil {
            return false
        } else {
            return true
        }
    }
    
    // it starts after enter correct password
    private func logIn() {
        infoLabel.text = "Enter code"
        infoLabel.textColor = UIColor.black
        let retrievedString: String? = KeychainWrapper.standard.string(forKey: "code")
        if retrievedString == nil {
            infoLabel.text = "Create code"
            infoLabel.textColor = UIColor.black
        } else {
            let input = inputKeycode.joined(separator: "")
            if input == retrievedString {
                print(inputKeycode)
                navigatedToNote()
                counterOfWrongAnswer = 0
                saveCounterValue(counterValue: counterOfWrongAnswer)
                
            } else {
                let _: Bool = KeychainWrapper.standard.set(counterOfWrongAnswer, forKey: "counter")
                UIDevice.vibrate()
                
                counterOfWrongAnswer = counterOfWrongAnswer + 1
                saveCounterValue(counterValue: counterOfWrongAnswer)
                
                if counterOfWrongAnswer % 5 == 0 {
                    saveNewDelayDate(delayDate: Date(), time: 60)
                    infoLabel.text = "Wait till: \(dateToString(date: loadDelayDate()))"
                    infoLabel.textColor = UIColor.red
                }
            }
        }
    }
    
    // what is going after enter 1-4 code char
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

            if compareDates(delayDate: loadDelayDate()) == true {
                saveCounterValue(counterValue: 0)
                if allowToEdit == true {
                    let input = inputKeycode.joined(separator: "")
                    let _: Bool = KeychainWrapper.standard.set(input, forKey: "code")
                    self.clearInputKeycodeView()
                    infoLabel.text = "Enter code"
                    infoLabel.textColor = UIColor.black
                    allowToEdit = false
                    isEdit = false
                } else {
                    if isCode() == true {
                        if isEdit == false {
                            logIn()
                        } else {
                            let retrievedString: String? = KeychainWrapper.standard.string(forKey: "code")
                            let input = inputKeycode.joined(separator: "")
                            if input == retrievedString {
                                allowToEdit = true
                                self.clearInputKeycodeView()
                                infoLabel.text = "Setup new code"
                                infoLabel.textColor = UIColor.black
                                counterOfWrongAnswer = 0
                                saveCounterValue(counterValue: counterOfWrongAnswer)
                                } else {
                                    UIDevice.vibrate()
                                    counterOfWrongAnswer += 1
                                    saveCounterValue(counterValue: counterOfWrongAnswer)
                                
                                    if counterOfWrongAnswer % 5 == 0 {
                                        saveNewDelayDate(delayDate: Date(), time: 60)
                                        infoLabel.text = "Wait till: \(dateToString(date: loadDelayDate()))"
                                        infoLabel.textColor = UIColor.red
                                    }
                                }
                            }
                        
                    } else {
                        createCode()
                    }
                }
            } else {
                infoLabel.text = "Wait till: \(dateToString(date: loadDelayDate()))"
                infoLabel.textColor = UIColor.red
            }
            
            let seconds = 0.5
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                self.keycode1.backgroundColor = UIColor.clear
                self.keycode2.backgroundColor = UIColor.clear
                self.keycode3.backgroundColor = UIColor.clear
                self.keycode4.backgroundColor = UIColor.clear
            }
            inputKeycode.removeAll()
        }
    }
    
    // it change VC
    private func navigatedToNote() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let mainNavigationVC = mainStoryboard.instantiateViewController(withIdentifier: "noteView") as? NoteViewController else {
            return
        }
        present(mainNavigationVC, animated: true, completion: nil)
    }
    
    // function return date in String
    func dateToString(date : Date) -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let formattedDate : String = format.string(from: date)
        return formattedDate
    }
    
    // load delayDate from KeyChain
    func loadDelayDate() -> Date{
        let retrievedString: String? = KeychainWrapper.standard.string(forKey: "delayDate")
        
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let delayDate = format.date(from: retrievedString!)!

        return delayDate
    }
    
    // save delayDate to KeyChain
    func saveNewDelayDate(delayDate : Date, time : Double){
        let newDate = delayDate.addingTimeInterval(time)
        
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let formattedDate : String = format.string(from: newDate)
        
        let _: Bool = KeychainWrapper.standard.set(formattedDate, forKey: "delayDate")
    }
    
    // Check if user have to wait to enter passwrd
    func compareDates(delayDate : Date) -> Bool {
        let currentDate = Date()
        let delayDate = loadDelayDate()
        
        if currentDate >= delayDate {
            return true
        } else {
            return false
        }
    }
    
    // load counter value from KeyChain
    func loadCounterValue() -> Int {
        let retrievedCounter: Int? = KeychainWrapper.standard.integer(forKey: "counter")
    
        return retrievedCounter!
    }
    
    // save counter value to keyChain
    func saveCounterValue(counterValue: Int) {
        let _: Bool = KeychainWrapper.standard.set(counterValue, forKey: "counter")
    }

}


// added a feature that causes device vibration
extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
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
        
        // last pressed key
        let data = self.passCodeKeyData[indexPath.row]

        // data status = 0 when user tapped one of keys from keyboard
        if data.status == 0 {
            self.inputKeycode.append(data.value)
            self.inputKeycodeAction()
            
        } else {
            // data status = 1 when user tapped Clear button
            if data.status == 1 {
                self.clearInputKeycodeView()
            }
            
            // data status = 2 when user taped Edit button
            if data.status == 2 {
                if compareDates(delayDate: loadDelayDate()) != true {
                    infoLabel.text = "Wait till: \(dateToString(date: loadDelayDate()))"
                    infoLabel.textColor = UIColor.red
                } else {
                    if isCode() == true {
                        isEdit = true
                        infoLabel.text = "Enter the current code"
                        infoLabel.textColor = UIColor.black
                    } else {
                        infoLabel.text = "First create code"
                        infoLabel.textColor = UIColor.black
                    }
                }
            }
        }
    }
}
