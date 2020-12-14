//
//  EditNoteViewController.swift
//  NotesApp
//
//  Created by Teacher on 07.12.2020.
//

import UIKit
import CoreData

class EditNoteViewController: UIViewController {
    var context: NSManagedObjectContext?
    var didFinish: (() -> Void)?

    @IBOutlet private var modifiedDateLabel: UILabel!
    @IBOutlet private var titleTextField: UITextField!
    @IBOutlet private var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTap))
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 8
    }

    @objc private func saveTap(_ sender: Any) {
        guard
            let context = context,
            let entityDescription = NSEntityDescription.entity(forEntityName: "Note", in: context)
        else { return }

        let note = NSManagedObject(entity: entityDescription, insertInto: context)
        note.setValue(titleTextField.text ?? "", forKeyPath: "title")
        note.setValue(textView.text, forKeyPath: "text")
        note.setValue(Date(), forKeyPath: "dateModified")
        do {
            try context.save()
        } catch {
            print(error)
        }
        didFinish?()
    }
}
