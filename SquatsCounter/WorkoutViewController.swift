//
//  WorkoutViewController.swift
//  SquatsCounter
//
//  Created by Наташа on 25.10.16.
//  Copyright © 2016 nborzenko. All rights reserved.
//

import UIKit
import CoreData

class WorkoutViewController: UIViewController, InitViewControllerDelegate, TestViewControllerDelegate, MotionRecorderDelegate {

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    var persistentStoreCoordinator = (UIApplication.shared.delegate as! AppDelegate).persistentStoreCoordinator
    var currentType: SquatsType?
    
    var motionRecorder = MotionRecorder()
    var counter: Counter?
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(contextDidChange), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: context)
        
        if Defaults.isAnalyzed {
            startButton.titleLabel?.text = "Начать тренировку"
            counter = Counter(meanValue: Defaults.storedMeanValue, minPeakValue: Defaults.storedMinPeakValue, interval: Defaults.storedInterval)
            
            let objectID = persistentStoreCoordinator.managedObjectID(forURIRepresentation: Defaults.storedSquatsTypeID)!
            currentType = context.object(with: objectID) as? SquatsType
            selectType(type: currentType!)
        } else {
            startButton.titleLabel?.text = "Выбрать тип приседаний"
        }
        
        startButton.isHidden = false
        countLabel.isHidden = true
        stopButton.isHidden = true
        motionRecorder.delegate = self
    }
    
    @IBAction func start(_ sender: AnyObject) {
        if Defaults.isAnalyzed {
            startButton.isHidden = true
            countLabel.isHidden = false
            stopButton.isHidden = false
            
            count = 0
            countLabel.text = "\(count)"
            counter?.clear()
            motionRecorder.start()
        } else {
            performSegue(withIdentifier: "workoutInit", sender: self)
        }
    }
    
    func recordValue(value: Double) {
        if counter!.check(item: value) {
            count += 1
            countLabel.text = "\(count)"
        }
    }
    
    @IBAction func stop(_ sender: AnyObject) {
        motionRecorder.stop()
        counter?.clear()
        
        if count > 0 {
            DayManager.sharedInstance.appendSquats(count: count, type: currentType!)
            NotificationCenter.default.post(name: Notification.Name("needRedrawChart"), object: nil)
        }
        
        count = 0
        countLabel.text = "\(count)"
        startButton.isHidden = false
        countLabel.isHidden = true
        stopButton.isHidden = true
    }
    
    func selectType(type: SquatsType) {
        currentType = type
        typeLabel.text = currentType!.name
        let color = NSKeyedUnarchiver.unarchiveObject(with: currentType!.color as! Data) as! UIColor
        typeLabel.textColor = color
    }
    
    func contextDidChange(notification: Notification) {
        if let _ = currentType, let userInfo = notification.userInfo {
            if let updates = userInfo[NSUpdatedObjectsKey] as? Set<SquatsType>, updates.count > 0 {
                if let newType = updates.first(where: { $0.objectID == currentType!.objectID }) {
                    selectType(type: newType)
                }
            }
        }
    }
    
    func dismissInitAndPresentTest(selectedType: SquatsType) {
        selectType(type: selectedType)
        typeLabel.isHidden = false
        
        dismiss(animated: false, completion: {
            self.performSegue(withIdentifier: "workoutTest", sender: self)
        })
    }
    
    func dismissTest(testCounter: Counter?) {
        if let currentCounter = testCounter {
            counter = currentCounter
            
            Defaults.currentDate = Date()
            Defaults.storedMeanValue = currentCounter.meanValue
            Defaults.storedMinPeakValue = currentCounter.minPeakValue
            Defaults.storedInterval = currentCounter.interval
            Defaults.storedSquatsTypeID = currentType!.objectID.uriRepresentation()
            
            startButton.titleLabel?.text = "Начать тренировку"
        } else {
            currentType = nil
            typeLabel.text = nil
        }
        
        dismiss(animated: false, completion: {
            self.tabBarController?.tabBar.isHidden = false
            self.view.isHidden = false
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "workoutInit":
            let initController = segue.destination as! InitViewController
            initController.delegate = self
            view.isHidden = true
            tabBarController?.tabBar.isHidden = true
        case "workoutTest":
            let testController = segue.destination as! TestViewController
            testController.delegate = self
        default: break;
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
