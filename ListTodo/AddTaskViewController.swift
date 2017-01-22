//
//  AddTaskViewController.swift
//  ToDoList
//
//  Created by nanthakumar on 26/12/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import AssetsLibrary
import Photos

class AddTaskViewController: UIViewController {
    
  @IBOutlet weak var taskNameTextField: UITextField!
  @IBOutlet weak var dueDateTextField: UITextField!
  @IBOutlet weak var contentTextView: UITextView!
  @IBOutlet weak var remindMeSwitch: UISwitch!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var saveButton: UIButton!
  @IBOutlet weak var imageButton: UIButton!
  @IBOutlet weak var taskImageView: UIImageView!
  
  var group: Group?
  var taskFromTasksVC: Task?
  
  var datePicker: SMDatePicker = SMDatePicker()
  
  let defaults = UserDefaults.standard
  
  let delegate = UIApplication.shared.delegate as? AppDelegate
  
  lazy var formatter: DateFormatter = {
    var tmpFormatter = DateFormatter()
    tmpFormatter.dateFormat = "dd-MM-YYYY hh:mm a"
    return tmpFormatter
  }()
  
  let appdelegate = AppDelegate()
  
  var selfNumber = ""
  
  var selectedDate: Date?
  
  var isForDate = false
  
  var isForAdding = false
  
  let imagePicker = UIImagePickerController()
  
  var selectedImageData: Data?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setNeedsStatusBarAppearanceUpdate()
    initialize()
  }
  
  override var preferredStatusBarStyle : UIStatusBarStyle {
    return .lightContent
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
    datePicker.hidePicker(true)
  }
  
//////////////////////////////////////////////////////////////////////////////////////////
//
// User Defined Functions
//
//////////////////////////////////////////////////////////////////////////////////////////
  
  func initialize() {
    taskNameTextField.delegate = self
    dueDateTextField.isUserInteractionEnabled = false
    let gesture = UITapGestureRecognizer(target: self, action: #selector(showDateWithPicker))
    dueDateTextField.addGestureRecognizer(gesture)
    datePicker.delegate = self
    datePicker.pickerMode = .dateAndTime
    if !isForAdding {
      self.titleLabel.text = taskFromTasksVC?.name
      self.saveButton.setTitle("Save", for: .normal)
      taskNameTextField.text = taskFromTasksVC?.name
      dueDateTextField.text = formatter.string(from: (taskFromTasksVC?.dueDate)! as Date)
      contentTextView.text = taskFromTasksVC?.content
      if (taskFromTasksVC?.remindMe)! == true {
        remindMeSwitch.setOn(true, animated: false)
      } else {
        remindMeSwitch.setOn(false, animated: false)
      }
      if let imGUrl = taskFromTasksVC?.imageData as Data? {
        self.taskImageView.image = UIImage(data: imGUrl as Data)
      }
    }
  }

  func saveTask(name: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
    }
    let managedContext = appDelegate.persistentContainer.viewContext
    let task: Task?
    if isForAdding {
      task = Task(context: managedContext)
      task?.name = taskNameTextField.text!
      task?.isComplete = false
      task?.dueDate = selectedDate as NSDate?
      task?.content = contentTextView.text
      task?.remindMe = getRemindMe()
      task?.group = self.group
      if selectedImageData != nil {
        task?.imageData = selectedImageData as NSData?
      }
    } else {
      task = taskFromTasksVC
      task?.setValue(taskNameTextField.text!, forKey: "name")
      if selectedDate != nil {
        task?.setValue(selectedDate as NSDate?, forKey: "dueDate")
      }
      task?.setValue(contentTextView.text!, forKey: "content")
      task?.setValue(getRemindMe(), forKey: "remindMe")
      if selectedImageData != nil {
        task?.setValue(selectedImageData, forKey: "imageData")
      }
    }
    do {
      try managedContext.save()
      if getRemindMe() == true && selectedDate != nil {
        let userData = ["taskName" : task?.name as AnyObject, "taskGroupName": (task?.group?.name)! as AnyObject] as [String : AnyObject]
        delegate?.scheduleNotification(at: self.getFinalDate(date: selectedDate!), body: "Time to \((task?.name)! ) 🏃🏾", userInfo: userData as [String : AnyObject])
      }
      self.navigationController?.popViewController(animated: true)
    } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
    }
  }
  
  func showDateWithPicker(){
    self.view.endEditing(true)
    self.taskNameTextField.resignFirstResponder()
    self.dueDateTextField.resignFirstResponder()
    self.datePicker.showPickerInView(self.view, animated: true)
  }
  
  func getFinalDate(date: Date) -> Date {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
    return calendar.date(from: components)!
  }
  
  func getRemindMe () -> Bool {
    if self.remindMeSwitch.isOn {
      return true
    } else {
      return false
    }
  }
  
  func openCamera()
  {
    if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
    {
      imagePicker.allowsEditing = true
      imagePicker.sourceType = UIImagePickerControllerSourceType.camera
      self .present(imagePicker, animated: true, completion: nil)
    }
    else
    {
      let ac = UIAlertController(title: "Camera!", message: "Camera not available", preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      present(ac, animated: true, completion: nil)
    }
  }
  
  func openGallary()
  {
    imagePicker.allowsEditing = true
    imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
    if UIDevice.current.userInterfaceIdiom == .phone
    {
      self.present(imagePicker, animated: true, completion: nil)
    }
  }
  
  
//////////////////////////////////////////////////////////////////////////////////////////
//
// Button Actions
//
//////////////////////////////////////////////////////////////////////////////////////////
  
  @IBAction func addButtonAction(_ sender: AnyObject) {
    if taskNameTextField.text != "" {
      if dueDateTextField.text != "" {
        saveTask(name: taskNameTextField.text!)
      } else {
        self.view.makeToast("Please Enter Task Due Date", duration: 2.0, position: .center)
        self.dueDateTextField.becomeFirstResponder()
      }
    } else {
      self.view.makeToast("Please Enter Task Name", duration: 2.0, position: .center)
      self.taskNameTextField.becomeFirstResponder()
    }
  }
  
  @IBAction func backButtonClicked(_ sender: AnyObject) {
    self.navigationController?.popViewController(animated: true)
  }
  
  
  @IBAction func dueDateButtonClicked(_ sender: AnyObject) {
    showDateWithPicker()
  }
  
  @IBAction func remindMeAction(_ sender: AnyObject) {
  }
  
  @IBAction func cameraButtonAction(_ sender: AnyObject) {
    let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
    let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
    {
      UIAlertAction in
      self.openCamera()
      
    }
    let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.default)
    {
      UIAlertAction in
      self.openGallary()
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
    {
      UIAlertAction in
    }
    // Add the actions
    imagePicker.delegate = self
    imagePicker.allowsEditing = true
    alert.addAction(cameraAction)
    alert.addAction(gallaryAction)
    alert.addAction(cancelAction)
    // Present the controller
    if UIDevice.current.userInterfaceIdiom == .phone
    {
      self.present(alert, animated: true, completion: nil)
    }
  }
  

}

//////////////////////////////////////////////////////////////////////////////////////////
//
// Text Field Delegates
//
//////////////////////////////////////////////////////////////////////////////////////////

extension AddTaskViewController: UITextFieldDelegate {
  
//  func textFieldDidBeginEditing(_ textField: UITextField) {
//    datePicker.hidePicker(true)
//    if textField == dueDateTextField {
//      self.showDateWithPicker()
//    }
//  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    if textField == taskNameTextField {
      self.view.endEditing(true)
    }
  }
  
}

//////////////////////////////////////////////////////////////////////////////////////////
//
// Date Picker Delegates
//
//////////////////////////////////////////////////////////////////////////////////////////

extension AddTaskViewController: SMDatePickerDelegate {
  
  func datePicker(_ picker: SMDatePicker, didPickDate date: Date) {
    
    selectedDate = date
    let dateString = formatter.string(from: date)
    dueDateTextField.text = dateString
    print(date)
    print(getFinalDate(date: date))
    
  }
  
}

//////////////////////////////////////////////////////////////////////////////////////////
//
// Image Picker Delegates
//
//////////////////////////////////////////////////////////////////////////////////////////


extension AddTaskViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if imagePicker.sourceType == UIImagePickerControllerSourceType.camera
    {
      let image = info[UIImagePickerControllerOriginalImage] as! UIImage
      DispatchQueue.main.async(execute: {
        self.taskImageView.image = image
      })
      selectedImageData = UIImagePNGRepresentation(image)
    } else {
      if let referenceUrl = info[UIImagePickerControllerReferenceURL] as? URL{
        let image = info[UIImagePickerControllerEditedImage] as? UIImage
        DispatchQueue.main.async(execute: {
          self.taskImageView.image = image
        })
        selectedImageData = UIImagePNGRepresentation(image!)
      }
    }
    dismiss(animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
  
}
