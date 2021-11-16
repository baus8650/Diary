//
//  DiaryListViewController.swift
//  Diary
//
//  Created by Tim Bausch on 10/24/21.
//

import UIKit
import Firebase


class DiaryListViewController: UIViewController {
    
    //MARK: - Local Variables
    
    private let db = Firestore.firestore()
    var entries: [Entry] = [].filter {$0.user == Auth.auth().currentUser?.email}
    private var handle: AuthStateDidChangeListenerHandle?
    private var user: User?
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    //MARK: - IBActions
    
    @IBAction private func logOutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            handle = Auth.auth().addStateDidChangeListener { _, user in
                guard let user = user else { return }
                print(user)
            }
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
    }
    
    @IBAction private func addButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "NewEntry", sender: self)
    }
    
    //MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        title = "Entries"
        navigationItem.hidesBackButton = true
        handle = Auth.auth().addStateDidChangeListener { _, user in
            guard let user = user else { return }
            self.loadEntries(user: user.email!)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        guard let handle = handle else { return }
        Auth.auth().removeStateDidChangeListener(handle)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let entryViewController = segue.destination as? EntryViewController,
              let index = tableView.indexPathForSelectedRow?.row
        else {
            return
        }
        entryViewController.entry = entries[index]
    }
    
}

//MARK: - Extensions

extension DiaryListViewController: UITableViewDataSource {
    private func loadEntries(user: String) {
        db.collection("entries").whereField("user", isEqualTo: user).order(by: "timeStamp", descending: true).addSnapshotListener { querySnapshot, error in
            self.entries = []
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let entryDate = data["date"] as? String, let entryUser = data["user"] as? String, let entryBody = data["body"] as? String, let entryMood = data["mood"] as? Int, let entryID = data["id"] as? String, let entryTimeStamp = data["timeStamp"] {
                            let newEntry = Entry(user: entryUser, date: entryDate, body: entryBody, mood: entryMood, id: entryID, timeStamp: entryTimeStamp as! Double)
                            self.entries.append(newEntry)
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entry = entries[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath)
        cell.textLabel!.text = entry.date
        switch entry.mood {
        case 1:
            cell.backgroundColor = UIColor(red: 201/255, green: 93/255, blue: 89/255, alpha: 0.5)
        case 2:
            cell.backgroundColor = UIColor(red: 217/255, green: 194/255, blue: 191/255, alpha: 0.5)
        case 3:
            cell.backgroundColor = UIColor(red: 136/255, green: 224/255, blue: 239/255, alpha: 0.5)
        case 4:
            cell.backgroundColor = UIColor(red: 194/255, green: 217/255, blue: 191/255, alpha: 0.5)
        case 5:
            cell.backgroundColor = UIColor(red: 115/255, green: 217/255, blue: 87/255, alpha: 0.5)
        default:
            cell.backgroundColor = UIColor(named: "default")
        }
        
        return cell
    }
}

