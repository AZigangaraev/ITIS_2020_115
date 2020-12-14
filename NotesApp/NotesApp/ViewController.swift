//
//  ViewController.swift
//  NotesApp
//
//  Created by Teacher on 14.12.2020.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let cellIdentifier = "Cell"
    private var notes: [NSManagedObject] = []
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        return dateFormatter
    }()
    @IBOutlet private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        reload()
    }

    private func reload() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Note")
        do {
            notes = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print(error)
        }
    }

    private lazy var context: NSManagedObjectContext = {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            fatalError()
        }

        return context
    }()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let note = notes[indexPath.row]
        cell.textLabel?.text = note.value(forKeyPath: "title") as? String
        cell.detailTextLabel?.text = (note.value(forKey: "dateModified") as? Date).map { dateFormatter.string(from: $0) }
        return cell
    }

    @IBAction private func addTap() {
        let controller = editNoteViewController { [self] in
            reload()
            navigationController?.popViewController(animated: true)
        }
        navigationController?.pushViewController(controller, animated: true)
    }

    private func editNoteViewController(completion: @escaping () -> Void) -> EditNoteViewController {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "EditNoteViewController") as? EditNoteViewController else {
            fatalError()
        }

        controller.context = context
        controller.didFinish = completion
        return controller
    }
}

