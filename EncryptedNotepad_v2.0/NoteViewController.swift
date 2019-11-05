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
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathExtension("save.txt")
        print(path!)
        do {
             try textView.text.write(to: path!, atomically: true, encoding: .utf8)
        } catch {
            //exception
        }
    }
                
    @IBOutlet weak var textView: UITextView!
    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            if let filepath = Bundle.main.path(forResource: "Documents.save2", ofType: "txt") {
                do {
                    let contents = try String(contentsOfFile: filepath)
                    print(contents)
                } catch {
                    // contents could not be loaded
                }
            } else {
                // example.txt not found!
            }
            
            
            print("start")
            let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathExtension("save2.txt")
            print(path!)
            do {
                let input = try String(contentsOf: path!)
                textView.text = input

            } catch {
                //exception
            }
            
            // Do any additional setup after loading the view.
        }

    }

