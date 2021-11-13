//
//  NewEntryController.swift
//  Diary
//
//  Created by Tim Bausch on 10/25/21.
//

import UIKit
import Firebase


class NewEntryController: UIViewController {
    
    //MARK: - Local Variables
    
    let db = Firestore.firestore()
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var bodyText: UITextView!
    @IBOutlet private weak var updateButton: UIButton!
    @IBOutlet private weak var moodSlider: UISlider!
    
    //MARK: - IBActions
    
    @IBAction private func moodSliderTouched(_ sender: UISlider) {
        moodSlider.value = moodSlider.value.rounded()
    }
    
    @IBAction func saveEntryPressed(_ sender: UIButton){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        if let entryBody = bodyText.text, let entryUser = Auth.auth().currentUser?.email {
            let ref = db.collection("entries").document()
            let id = ref.documentID
            let entryMood = moodSlider.value
            ref.setData(["user": entryUser,
                         "date": dateFormatter.string(from: Date()),
                         "body": entryBody,
                         "mood": entryMood,
                         "id": id,
                         "timeStamp": Date().timeIntervalSince1970]) { (error) in
                if let e = error {
                    print("There was an issue saving data to firestore, \(e)")
                } else {
                    print("Successfully saved data.")
                }
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bodyText.delegate = self
        bodyText.text = "Tap here to record a new entry."
        bodyText.textColor = UIColor.lightGray
    }
    
}

extension NewEntryController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if bodyText.textColor == .lightGray {
            bodyText.text = nil
            bodyText.textColor = UIColor(named: "textColor")
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if bodyText.text.isEmpty {
            bodyText.text = "Tap here to record a new entry."
            bodyText.textColor = .lightGray
        }
    }
}
