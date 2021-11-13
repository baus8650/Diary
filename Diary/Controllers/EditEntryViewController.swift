//
//  EditEntryViewController.swift
//  Diary
//
//  Created by Tim Bausch on 10/25/21.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

protocol EditEntryViewControllerDelegate {
    func changeEntry(_ editedEntry: Entry)
}

class EditEntryViewController: UIViewController {
    
    //MARK: - Local Variables
    
    var delegate: EditEntryViewControllerDelegate?
    private let db = Firestore.firestore()
    private var bodyText: String = ""
    var editEntry: Entry?
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var bodyLabel: UITextView!
    @IBOutlet private weak var moodSlider: UISlider!
    
    //MARK: - IBActions
    
    @IBAction private func moodSliderTouched(_ sender: UISlider) {
        moodSlider.value = moodSlider.value.rounded()
    }
    
    @IBAction private func updateButtonPressed(_ sender: UIButton) {
        let entryRef = db.collection("entries").document(editEntry!.id)
        entryRef.updateData([
            "body": bodyLabel.text!,
            "mood": moodSlider.value
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                self.delegate?.changeEntry(Entry(user: self.editEntry!.user, date: self.editEntry!.date, body: self.bodyLabel.text, mood: self.editEntry!.mood, id: self.editEntry!.id, timeStamp: self.editEntry!.timeStamp))
                print("Document successfully updated")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bodyLabel.text = editEntry?.body
        moodSlider.value = Float(editEntry!.mood)
    }
    
}

