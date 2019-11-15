//
//  NoteViewController.swift
//  EncryptedNotepad_v2.0
//
//  Created by xxx on 24/10/2019.
//  Copyright © 2019 xxx. All rights reserved.
//

import UIKit

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
            
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
            view.addGestureRecognizer(tap)
            
            let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("saving.txt")
                    
                    do{
                    let input = try String(contentsOf: path!)
                        textView.text = input
                    }catch{
                        
                    }
                }

                override func didReceiveMemoryWarning() {
                    super.didReceiveMemoryWarning()
                }


            }
