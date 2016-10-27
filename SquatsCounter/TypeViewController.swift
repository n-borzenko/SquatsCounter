//
//  TypesViewController.swift
//  SquatsCounter
//
//  Created by Наташа on 17.10.16.
//  Copyright © 2016 nborzenko. All rights reserved.
//

import UIKit
import CoreData

class TypeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var colorTextField: UITextField!
    @IBOutlet weak var colorPickerView: UIPickerView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var type : SquatsType?
    var context : NSManagedObjectContext!
    var selectedColorIndex = -1
    
    var colorsData : [(name: String, color: UIColor)] = [
        (name: "Желтый", color: UIColor.yellow),
        (name: "Оранжевый", color: UIColor.orange),
        (name: "Коричневый", color: UIColor.brown),
        (name: "Красный", color: UIColor.red),
        (name: "Фуксия", color: UIColor.magenta),
        (name: "Пурпурный", color: UIColor.purple),
        (name: "Синий", color: UIColor.blue),
        (name: "Бирюзовый", color: UIColor.cyan),
        (name: "Зеленый", color: UIColor.green),
        (name: "Серый", color: UIColor.gray)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let existingType = type  {
            navigationItem.title = existingType.name
            nameTextField.text = existingType.name
            
            let color = NSKeyedUnarchiver.unarchiveObject(with: existingType.color! as Data) as! UIColor
            selectedColorIndex = colorsData.index{ $0.color == color }!
            
            colorTextField.textColor = color
            colorTextField.text = colorsData[selectedColorIndex].name
        } else {
            saveButton.isEnabled = false
        }

        colorPickerView.isHidden = true
        nameTextField.delegate = self
        colorTextField.delegate = self
        colorPickerView.delegate = self
        colorPickerView.dataSource = self
    }
    
    // MARK: - TextFields
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case colorTextField:
            nameTextField.endEditing(true)
            colorPickerView.isHidden = false
            colorPickerView.selectRow(selectedColorIndex, inComponent: 0, animated: false)
            return false
        case nameTextField:
            colorPickerView.isHidden = true
            return true
        default: return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        validateFields()
    }
    
    func validateFields() {
        if let name = nameTextField.text, !name.isEmpty, selectedColorIndex >= 0 {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameTextField.endEditing(true)
        colorPickerView.isHidden = true
    }

    // MARK: - PickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colorsData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedColorIndex = row
        colorTextField.text = colorsData[row].name
        colorTextField.textColor = colorsData[row].color
        if !saveButton.isEnabled {
            validateFields()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
        if component == 0 {
            label.textAlignment = .center
            label.backgroundColor = UIColor.clear
            label.text = colorsData[row].name
            label.textColor = colorsData[row].color
            label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
        }
        return label
    }
    
    // MARK: - Navigation & Saving
    
    @IBAction func exit(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveType(_ sender: AnyObject) {
        if type == nil {
            type = SquatsType.insertNewObjectIntoContext(context)
        }
        
        let name = nameTextField.text ?? ""
        let color = colorsData[selectedColorIndex].color
        
        type!.name = name
        type!.color = NSKeyedArchiver.archivedData(withRootObject: color) as NSData

        do {
            try context.save()
             NotificationCenter.default.post(name: Notification.Name("needRedrawChart"), object: nil)
        } catch {
            print("error")
        }
        
        dismiss(animated: true, completion: nil)
    }
}
