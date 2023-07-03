//
//  ViewController2.swift
//  GSMControl
//
//  Created by Иван Андриянов on 14.04.2023.
//

import UIKit
import MessageUI

extension ViewController2: UITextFieldDelegate {
    
    
    
    func timerOn(time : Double){
        _ = Timer.scheduledTimer(withTimeInterval: time, repeats: false) { timer in
                NotificationCenter.default.post(name: NSNotification.Name("Timer"), object: nil)
        }
    }
    func timerOn2(time : Double){
        _ = Timer.scheduledTimer(withTimeInterval: time, repeats: false) { timer in
                NotificationCenter.default.post(name: NSNotification.Name("Timer2"), object: nil)
        }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        timer2On = true
        switch (textField){
            case phoneGSM : infoLabel2.text = "Наберите номер телефона AGT-GSM3"
            case phoneUser : infoLabel2.text = "Наберите номер телефона пользователя"
            case password :
                infoLabel2.text = "Наберите текущий пароль"
                timerOn2(time: 2.0)
            case passwordNew :
                infoLabel2.text = "Наберите новый пароль"
                timerOn2(time: 2.0)
            case passwordNew2 :
                infoLabel2.text = "Повторите новый пароль"
                timerOn2(time: 2.0)
            default : break
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        timer2On = false
        infoLabel2.text = "Настройка AGT-GSM3"
        

        gsmData.phoneNumb[0] = phoneGSM.text!
        gsmData.phoneNumb[1] = phoneUser.text!
        gsmData.uPass = password.text!
        passNew = passwordNew.text!
        passNew2 = passwordNew2.text!

        if (textField == phoneGSM && phoneGSM.text!.count > 20){
            present(alertPhoneGSMBad, animated: true, completion: nil)
        }
        else if (textField == phoneGSM && phoneGSM.text!.count > 0 && phoneGSM.text!.first?.description != "+"){
            present(alertPhoneGSMBadBegin, animated: true, completion: nil)
        }
        else if (textField == phoneUser && phoneUser.text!.count > 20){
            present(alertPhoneUserBad, animated: true, completion: nil)
        }
        else if (textField == phoneUser && phoneUser.text!.count > 0 && phoneUser.text!.first?.description != "+"){
            present(alertPhoneUserBadBegin, animated: true, completion: nil)
        }
        else if (textField == password && password.text!.count != 4 && password.text!.count != 0){
            present(alertPasswordBad, animated: true, completion: nil)
        }
        else if (textField == passwordNew && passwordNew.text!.count != 4 && passwordNew.text!.count != 0){
            present(alertPasswordBad, animated: true, completion: nil)
        }
        else if (textField == passwordNew2 && passwordNew2.text!.count != 4 && passwordNew2.text!.count != 0){
            present(alertPasswordBad, animated: true, completion: nil)
        }
        if (textField == password || textField == passwordNew || textField == passwordNew2) {
            self.view.frame.origin.y = 0
        }
    }
}
class ViewController2: UIViewController, MFMessageComposeViewControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = UILabel()
        if let v = view as? UILabel { label = v }
        label.font = UIFont (name: "System", size: 17)
        label.textAlignment = .center

        switch (pickerView) {
        case batInt : label.text = "\(row + 5)"
        case bat01 : label.text = "\(row)"
        case tempMin :
            if row >= 40 {label.text = "+ \(row - 40)"}
            else {label.text = "- \(-(row - 40))"}
        case tempMax :
            if row >= 40 {label.text = "+ \(row - 40)"}
            else {label.text = "- \(-(row - 40))"}
        case tempCor : label.text = "- \(row)"
        default:
            break
        }
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch (pickerView) {
        case batInt : return 15
        case bat01 : return 10
        case tempMin : return 121
        case tempMax : return 121
        case tempCor : return 10
        default:
            return 1
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch (pickerView) {
        case batInt :
            gsmData.uBatU = row + 5
            infoLabel2.text = "Установлено мин. напряжение \(gsmData.uBatU),\(gsmData.uBatUD) В"
            timerOn(time: 1.50)
        case bat01 :
            gsmData.uBatUD = row
            infoLabel2.text = "Установлено мин. напряжение \(gsmData.uBatU),\(gsmData.uBatUD) В"
            timerOn(time: 1.50)
        case tempMin :
            gsmData.uTempMin = row - 40
            infoLabel2.text = "Установлена мин. температура \(gsmData.uTempMin) С"
            timerOn(time: 1.50)
        case tempMax :
            gsmData.uTempMax = row - 40
            infoLabel2.text = "Установлена макс. температура \(gsmData.uTempMax) С"
            timerOn(time: 1.50)
        case tempCor :
            gsmData.uTempCorr = row
            infoLabel2.text = "Установлена коррекция температуры -\(gsmData.uTempCorr) С"
            timerOn(time: 1.50)
        default:
            return
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result) {
        case .cancelled:
            infoLabel2.text = "Отправка SMS отменена"
            timerOn(time: 3.0)
        case .failed:
            infoLabel2.text = "Ошибка, невозможно отправить SMS"
            timerOn(time: 3.0)
        case .sent:
            infoLabel2.text = "SMS успешно отправлено"
            timerOn(time: 3.0)
        default:
            return
        }
        
        dismiss(animated: true, completion: nil)
    }

    var timer2On = false
    var passNew = ""
    var passNew2 = ""
    
    @IBOutlet var infoLabel2: UILabel!

    @IBOutlet var phoneGSM: UITextField!
    @IBOutlet var phoneUser: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var passwordNew: UITextField!
    @IBOutlet var passwordNew2: UITextField!
    
    @IBOutlet var batInt: UIPickerView!
    @IBOutlet var bat01: UIPickerView!
    @IBOutlet var tempMin: UIPickerView!
    @IBOutlet var tempMax: UIPickerView!
    @IBOutlet var tempCor: UIPickerView!
    
    @IBOutlet var uOnOffButton: [UIButton]!
    @IBOutlet var uOnOffSenButton: [UIButton]!
    @IBOutlet var sendSMSButton: [UIButton]!
    @IBOutlet var infoButton: UIButton!
    @IBOutlet var returnButton: UIButton!
    @IBOutlet var gsmInOutButton: UIButton!
    
    @IBOutlet var smsSensor: [UIButton]!
    
    @IBAction func returnButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func gsmInOutButton(_ sender: UIButton) {
        gsmData.gsmOut = !gsmData.gsmOut
        modButton()
    }
    
    
    @IBAction func uOnOffButton(_ sender: UIButton) {
        let pressedButton = Int(sender.restorationIdentifier!)!
        switch pressedButton {
        case 15: gsmData.uSMSOtvet = !gsmData.uSMSOtvet
        case 16: gsmData.uSMSRetr = !gsmData.uSMSRetr
        case 17: gsmData.uSMSBat = !gsmData.uSMSBat
        case 18: gsmData.uSMSTempMin = !gsmData.uSMSTempMin
        case 19: gsmData.uSMSTempMax = !gsmData.uSMSTempMax
        default: break
        }
        modButton()
    }
    
    @IBAction func uOnOffSenButton(_ sender: UIButton) {
        let pressedButton = Int(sender.restorationIdentifier!)!
  
        gsmData.uSMSSen[pressedButton - 22] += 1
        gsmData.uSMSSen[pressedButton - 22] = (gsmData.uSMSSen[pressedButton - 22] == 4) ? 0 : gsmData.uSMSSen[pressedButton - 22]
        modButton()
    }
    
    @IBAction func sendSMSButton(_ sender: UIButton) {
        let pressedButton = Int(sender.restorationIdentifier!)!
        if (noCheckData()){ return }
        switch pressedButton {
        case 26:
            smsString = gsmData.uPass + " " + "R"
            sendSMS()
        case 27:
            smsString = gsmData.uPass + " " + "RR"
            sendSMS()
        case 25:
            smsString = gsmData.uPass + " " + "U"
            sendSMS()
        case 31:
            smsString = gsmData.uPass + " " + "F" + gsmData.phoneNumb[1] + "."
            if (gsmData.uSMSOtvet) { smsString += "1" }
            else { smsString += "0" }
            if (gsmData.uSMSRetr) { smsString += "1" }
            else { smsString += "0" }
            if (gsmData.uSMSBat) { smsString += "1" }
            else { smsString += "0" }
            smsString += "\(String(format:"%02D", (gsmData.uBatU)))."
            smsString += "\(String(format:"%1D", (gsmData.uBatUD)))"
            if (gsmData.uSMSTempMin) { smsString += "1" }
            else { smsString += "0" }
            if (gsmData.uTempMin > -1) {
                smsString += "+"
                smsString += "\(String(format:"%02D", (gsmData.uTempMin)))"
            }
            else { smsString += "\(String(format:"%03D", (gsmData.uTempMin)))"
            }
            if (gsmData.uSMSTempMax) { smsString += "1" }
            else { smsString += "0" }
            if (gsmData.uTempMax > -1) {
                smsString += "+"
                smsString += "\(String(format:"%02D", (gsmData.uTempMax)))"
            }
            else { smsString += "\(String(format:"%03D", (gsmData.uTempMax)))"
            }
            smsString += "\(String(format:"%1D", (gsmData.uTempCorr)))"
            smsString += "\(String(format:"%1D", (gsmData.uSMSSen[0])))"
            smsString += "\(String(format:"%1D", (gsmData.uSMSSen[1])))"
            smsString += "\(String(format:"%1D", (gsmData.uSMSSen[2]))) U"
            sendSMS()
        case 28:
            if (passNew.count != 4 || passNew2.count != 4){
              present(alertPasswordBad, animated: true, completion: nil)
            }
            else if (passNew != passNew2){
                present(alertNewPasswordBad, animated: true, completion: nil)
            }
            else {
                smsString = gsmData.uPass + " " + "P-" + passNew + "-" + passNew
                sendSMS()
            }
        default: break
        }
        
    }
    
    func noCheckData() -> Bool {
        if (gsmData.phoneNumb[0].count > 20){
            present(alertPhoneGSMBad, animated: true, completion: nil)
            return true
        }
        else if (gsmData.phoneNumb[0].count > 0 && gsmData.phoneNumb[0].first?.description != "+"){
            present(alertPhoneGSMBadBegin, animated: true, completion: nil)
            return true
        }
        else if (gsmData.phoneNumb[0].count == 0 ){
            present(alertNoPhoneGSM, animated: true, completion: nil)
            return true
        }
        
        else if (gsmData.phoneNumb[1].count > 20){
            present(alertPhoneUserBad, animated: true, completion: nil)
            return true
        }
        else if (gsmData.phoneNumb[1].count > 0 && gsmData.phoneNumb[1].first?.description != "+"){
            present(alertPhoneUserBadBegin, animated: true, completion: nil)
            return true
        }
        else if (gsmData.phoneNumb[1].count == 0 ){
            present(alertNoPhoneUser, animated: true, completion: nil)
            return true
        }
        
        else if (gsmData.uPass.count != 4 && gsmData.uPass.count != 0){
            present(alertPasswordBad, animated: true, completion: nil)
            return true
        }
        return false
    }
    
    func sendSMS() {
        infoLabel2.text = "Отправка SMS."
        let messageVC = MFMessageComposeViewController()
        messageVC.body = smsString
        messageVC.recipients = [gsmData.phoneNumb[0]]
        messageVC.messageComposeDelegate = self
        self.present(messageVC, animated: true, completion: nil)
    }
    
    
    func colorButton(_ on : Bool, _ button : UIButton){
        if (on) {
            button.layer.backgroundColor = UIColor.systemGreen.cgColor
            button.setImage(UIImage(systemName: "checkmark"), for: .normal)
        }
        else {
            button.layer.backgroundColor = UIColor.systemRed.cgColor
            button.setImage(UIImage(systemName: "xmark"), for: .normal)
        }
    }
    
    func modButton() {
        infoLabel2.layer.cornerRadius =   infoLabel2.frame.size.height / 4
        infoLabel2.layer.borderColor = UIColor.systemGray2.cgColor
        infoLabel2.layer.borderWidth = 2
        
        for i in 0...4 { uOnOffButton[i].applyBlueBorder() }
        colorButton(gsmData.uSMSOtvet, uOnOffButton[0])
        colorButton(gsmData.uSMSRetr, uOnOffButton[1])
        colorButton(gsmData.uSMSBat, uOnOffButton[2])
        colorButton(gsmData.uSMSTempMin, uOnOffButton[3])
        colorButton(gsmData.uSMSTempMax, uOnOffButton[4])
        for i in 0...2 { uOnOffSenButton[i].applyBlueBorder()
            if (gsmData.uSMSSen[i] == 0){
                uOnOffSenButton[i].layer.backgroundColor = UIColor.systemRed.cgColor
                uOnOffSenButton[i].setImage(UIImage(systemName: "xmark"), for: .normal)
                uOnOffSenButton[i].setTitle("", for: .normal)
            }
            else {
                uOnOffSenButton[i].layer.backgroundColor = UIColor.systemGreen.cgColor
                uOnOffSenButton[i].setImage(UIImage(systemName: "checkmark"), for: .normal)
                if (gsmData.gsmOut){
                    uOnOffSenButton[i].setTitle(gsmData.sensorText[3][gsmData.uSMSSen[i]], for: .normal)

                }
                else {
                    uOnOffSenButton[i].setTitle(gsmData.sensorText[i][gsmData.uSMSSen[i]], for: .normal)
                }
                
     //           gsmData.sensorText[i][gsmData.uSMSSen[i]]
            }
        }
        for i in 0...4 { sendSMSButton[i].applyBlueBorder() }
        infoButton.applyBlueBorder()
        returnButton.applyBlueBorder()
        gsmInOutButton.applyBlueBorder()
        if (gsmData.gsmOut){
            gsmInOutButton.setTitle("AGT-GSM3 отдельный", for: .normal)
            smsSensor[0].setTitle(" SMS сенсор 1 :", for: .normal)
            smsSensor[1].setTitle(" SMS сенсор 2 :", for: .normal)
            smsSensor[2].setTitle(" SMS сенсор 3 :", for: .normal)


        }
        else {
            gsmInOutButton.setTitle("AGT-GSM3 встроенный", for: .normal)
            smsSensor[0].setTitle(" SMS статус АЗ :", for: .normal)
            smsSensor[1].setTitle(" SMS двигатель :", for: .normal)
            smsSensor[2].setTitle(" SMS зажигание :", for: .normal)
        }
        
        phoneGSM.text = gsmData.phoneNumb[0]
        phoneUser.text = gsmData.phoneNumb[1]
        password.text = gsmData.uPass
            
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        modButton()

        phoneGSM.delegate = self
        phoneUser.delegate = self
        password.delegate = self
        passwordNew.delegate = self
        passwordNew2.delegate = self

        batInt.dataSource = self
        bat01.dataSource = self
        tempMin.dataSource = self
        tempMax.dataSource = self
        tempCor.dataSource = self
        batInt.delegate = self
        bat01.delegate = self
        tempMin.delegate = self
        tempMax.delegate = self
        tempCor.delegate = self
        
        batInt.selectRow(gsmData.uBatU - 5, inComponent: 0, animated: true)
        bat01.selectRow(gsmData.uBatUD, inComponent: 0, animated: true)
        tempMin.selectRow(gsmData.uTempMin + 40, inComponent: 0, animated: true)
        tempMax.selectRow(gsmData.uTempMax + 40, inComponent: 0, animated: true)
        tempCor.selectRow(gsmData.uTempCorr, inComponent: 0, animated: true)

        
        // Добавление кнопки Готово на телефонную клавиатуру
        self.addDoneButtonOnKeyboard()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))

        NotificationCenter.default.addObserver(self, selector: #selector(setTimer), name: NSNotification.Name("Timer"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setTimer2), name: NSNotification.Name("Timer2"), object: nil)

        
        timerOn(time: 0.01)

   //     self.view.frame.size.width =  400
        
        
    }
    
    @objc func setTimer(){
        infoLabel2.text = "Настройка AGT-GSM3"
        self.view.frame.size.width =  380
    }
    @objc func setTimer2(){
        if (timer2On){ self.view.frame.origin.y =  -200 }
    }
    
    
    // Добавление кнопки Готово на телефонную клавиатуру
    func addDoneButtonOnKeyboard()
        {
            let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
            doneToolbar.barStyle = UIBarStyle.default
           
            let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let done: UIBarButtonItem = UIBarButtonItem(title: "Готово", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.doneButtonAction))
            
            let items = NSMutableArray()
            items.add(flexSpace)
            items.add(done)
          
            doneToolbar.items = items as? [UIBarButtonItem]
            doneToolbar.sizeToFit()
            
            phoneGSM.inputAccessoryView = doneToolbar
            phoneUser.inputAccessoryView = doneToolbar
            password.inputAccessoryView = doneToolbar
            passwordNew.inputAccessoryView = doneToolbar
            passwordNew2.inputAccessoryView = doneToolbar

        }
    
    @objc func doneButtonAction(){
        phoneGSM.resignFirstResponder()
        phoneUser.resignFirstResponder()
        password.resignFirstResponder()
        passwordNew.resignFirstResponder()
        passwordNew2.resignFirstResponder()

        
    }
  

}
