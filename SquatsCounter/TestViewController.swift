//
//  TestViewController.swift
//  SquatsCounter
//
//  Created by Наташа on 25.10.16.
//  Copyright © 2016 nborzenko. All rights reserved.
//

import UIKit

protocol TestViewControllerDelegate : class {
    func dismissTest(testCounter: Counter?)
}

class TestViewController: UIViewController, MotionRecorderDelegate {
    
    weak var delegate: TestViewControllerDelegate?
    
    var motionRecorder = MotionRecorder()
    var counter: Counter?
    var data = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        motionRecorder.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if motionRecorder.isAvailable {
            motionRecorder.start()
        } else {
            let alertController = UIAlertController(title: "Недоступны датчики", message: "К сожалению на вашем устройстве невозможно считать данные движений.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { result in
                self.delegate?.dismissTest(testCounter: nil)
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func recordValue(value: Double) {
        data.append(value)
    }
    
    @IBAction func finish(_ sender: AnyObject) {
        motionRecorder.stop()
        counter = Counter(array: data)
        data.removeAll()
        if counter != nil {
            delegate?.dismissTest(testCounter: counter)
        } else {
            let alertController = UIAlertController(title: "Ошибка анализа", message: "К сожалению не удалось распознать приседания в ваших движениях. Сделайте заново 3 приседания в обычном темпе.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Прервать тестовый подход", style: .destructive) { result in
                self.delegate?.dismissTest(testCounter: self.counter)
            }
            let okAction = UIAlertAction(title: "Сделать 3 приседания", style: .default) { result in
                self.motionRecorder.start()
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
