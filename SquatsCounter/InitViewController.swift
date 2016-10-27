//
//  InitViewController.swift
//  SquatsCounter
//
//  Created by Наташа on 25.10.16.
//  Copyright © 2016 nborzenko. All rights reserved.
//

import UIKit
import CoreData

protocol InitViewControllerDelegate : class {
    func dismissInitAndPresentTest(selectedType: SquatsType)
}

class InitViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    var context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext

    @IBOutlet weak var startTestButton: UIButton!
    @IBOutlet weak var typePickerView: UIPickerView!
    @IBOutlet weak var typeTextField: UITextField!
    
    weak var delegate: InitViewControllerDelegate?
    var typesData = [SquatsType]()
    
    var selectedTypeIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        typePickerView.isHidden = true
        typePickerView.delegate = self
        typeTextField.delegate = self
        startTestButton.isEnabled = false
        startTestButton.setTitleColor(startTestButton.titleLabel?.textColor.withAlphaComponent(0.5), for: .disabled)
        
        let fetchRequest = SquatsType.sortedfetchRequest()
        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest, completionBlock: { result in
            DispatchQueue.global().async {
                if let types = result.finalResult {
                    self.typesData.append(contentsOf: types)
                }
                
                DispatchQueue.main.async {
                    self.selectType(index: self.selectedTypeIndex)
                    self.typePickerView.reloadComponent(0)
                }
            }
        })
        
        do {
            try context.execute(asyncFetchRequest)
        } catch {
            
        }

    }
    
    @IBAction func startTest(_ sender: AnyObject) {
        delegate?.dismissInitAndPresentTest(selectedType: typesData[selectedTypeIndex])
    }
    
    // MARK: - TextField
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        typePickerView.isHidden = false
        typePickerView.selectRow(selectedTypeIndex, inComponent: 0, animated: false)
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        typePickerView.isHidden = true
    }
    
    // MARK: - PickerView
    
    func selectType(index: Int) {
        typeTextField.text = typesData[index].name
        let color = NSKeyedUnarchiver.unarchiveObject(with: typesData[index].color as! Data) as! UIColor
        typeTextField.textColor = color
        selectedTypeIndex = index
        startTestButton.isEnabled = true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typesData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectType(index: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
        if component == 0 {
            label.textAlignment = .center
            label.backgroundColor = UIColor.clear
            label.text = typesData[row].name
            let color = NSKeyedUnarchiver.unarchiveObject(with: typesData[row].color as! Data) as! UIColor
            label.textColor = color
            label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
        }
        return label
    }
}
