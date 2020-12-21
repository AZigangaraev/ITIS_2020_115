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
    private var notes: [Note] = []
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
        do {
            notes = try context.fetch(Note.fetchRequest())
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
        cell.textLabel?.text = note.title
        cell.detailTextLabel?.text = note.dateModified.map(dateFormatter.string)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showNoteDetails(note: notes[indexPath.row])
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [unowned self] _, _, completion in
            let note = notes[indexPath.row]
            context.delete(note)
            do {
                try context.save()
                notes.remove(at: indexPath.row)
                tableView.deleteRows(at: [ indexPath ], with: .automatic)
                completion(true)
            } catch {
                completion(false)
            }
        }
        return UISwipeActionsConfiguration(actions: [ deleteAction ])
    }

    @IBAction private func addTap() {
        showNoteDetails()
    }

    private func showNoteDetails(note: Note? = nil) {
        let controller = editNoteViewController { [self] in
            reload()
            navigationController?.popViewController(animated: true)
        }
        controller.note = note
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

