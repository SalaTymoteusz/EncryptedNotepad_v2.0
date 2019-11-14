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
                
    @IBOutlet weak var textView: UITextView!
    
        override func viewDidLoad() {
            super.viewDidLoad()
            
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
