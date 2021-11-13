//
//  EntryViewController.swift
//  Diary
//
//  Created by Tim Bausch on 10/24/21.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift


class EntryViewController: UIViewController {
    
    //MARK: - Local Variables
    
    private let db = Firestore.firestore()
    var entry: Entry?
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var bodyLabel: UITextView!
    
    //MARK: - IBActions
    
    @IBAction private func deleteButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        let entryRef = db.collection("entries").document(entry!.id)
        entryRef.delete()
    }
    
    //MARK: - Lifecyle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bodyLabel?.text = entry?.body
        title = entry?.date
    }
    
    override func viewWillAppear(_ animated: Bool) {
        bodyLabel.text = entry?.body
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let editViewController = segue.destination as! EditEntryViewController
        editViewController.editEntry = entry
        editViewController.delegate = self
    }
}

//MARK: - Extensions

extension EntryViewController: EditEntryViewControllerDelegate {
    func changeEntry(_ editedEntry: Entry) {
        bodyLabel.text = editedEntry.body
    }
}
