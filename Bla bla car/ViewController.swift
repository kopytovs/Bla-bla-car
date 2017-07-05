//
//  ViewController.swift
//  Bla bla car
//
//  Created by Арсений Дорогин on 01.07.17.
//  Copyright © 2017 AVSI. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet weak var Picker2: UIPickerView!
    
    var array2 = ["Купчино","Хабаровск","Московская","Парк Победы"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return array2[row]
    
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        Picker2.dataSource = self
        Picker2.delegate = self
            return array2.count
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
    }
    //@IBAction func TurnON(_ sender: Any) {
        
    //}
    
}

