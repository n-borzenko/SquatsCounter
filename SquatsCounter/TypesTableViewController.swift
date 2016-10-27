//
//  TypesTableViewController.swift
//  SquatsCounter
//
//  Created by Наташа on 17.10.16.
//  Copyright © 2016 nborzenko. All rights reserved.
//

import UIKit
import CoreData

class TypesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("error")
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections[section].numberOfObjects
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TypeCellReuseId", for: indexPath) as! TypeTableViewCell
        
        fillCell(cell: cell, at: indexPath)

        return cell
    }
    
    func fillCell(cell: TypeTableViewCell, at indexPath: IndexPath)  {
        let type = fetchedResultsController.object(at: indexPath)
        
        let color = NSKeyedUnarchiver.unarchiveObject(with: type.color! as Data) as! UIColor
        cell.name.textColor = color
        cell.name.text = type.name
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let path = newIndexPath {
                tableView.insertRows(at: [path], with: .fade)
            }
        case .delete:
            if let path = indexPath {
                tableView.deleteRows(at: [path], with: .fade)
            }
        case .update:
            if let path = indexPath {
                let cell = tableView.cellForRow(at: path) as! TypeTableViewCell
                fillCell(cell: cell, at: path)
            }
        case .move:
            if let path = indexPath {
                tableView.deleteRows(at: [path], with: .fade)
            }
            if let newPath = newIndexPath {
                tableView.insertRows(at: [newPath], with: .fade)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueId = segue.identifier {
            var selectedType : SquatsType? = nil
            switch segueId {
            case "EditType":
                let indexPath = tableView.indexPathForSelectedRow!
                selectedType = fetchedResultsController.object(at: indexPath)
                fallthrough
            case "AddType":
                let navigationController = segue.destination as! UINavigationController
                let destinationController = navigationController.viewControllers[0] as! TypeViewController
                destinationController.context = context
                destinationController.type = selectedType
            default: break
            }
        }
    }
    
    lazy var fetchedResultsController : NSFetchedResultsController<SquatsType> = {
        let typesRequest = SquatsType.sortedfetchRequest()
        let controller = NSFetchedResultsController(fetchRequest: typesRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        return controller
    }()
}
