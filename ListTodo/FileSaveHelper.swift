//
//  FileSaveHelper.swift
//  SavingFiles
//
//  Created by Jeremiah Jessel on 9/14/15.
//  Copyright © 2015 JCubedApps. All rights reserved.
//

import Foundation
import UIKit

class FileSaveHelper {
   
   // MARK:- Error Types
   
   private enum FileErrors:Error {
      case jsonNotSerialized
      case fileNotSaved
      case imageNotConvertedToData
      case fileNotRead
      case fileNotFound
   }
   
   // MARK:- File Extension Types
   enum FileExtension:String {
      case txt = ".txt"
      case jpg = ".jpg"
      case json = ".json"
   }
   
   // MARK:- Private Properties
   private let directory:FileManager.SearchPathDirectory
   private let directoryPath: String
   private let fileManager = FileManager.default
   private let fileName:String
   private let filePath:String
   private let fullyQualifiedPath:String
   private let subDirectory:String
   
   // MARK:- Public Properties
   var fileExists:Bool {
      get {
         return fileManager.fileExists(atPath: fullyQualifiedPath)
      }
   }
   
   var directoryExists:Bool {
      get {
         var isDir = ObjCBool(true)
         return fileManager.fileExists(atPath: filePath, isDirectory: &isDir )
      }
   }
   
   // MARK:- Initializers
   convenience init(fileName:String, fileExtension:FileExtension){
      self.init(fileName:fileName, fileExtension:fileExtension, subDirectory:"", directory:.documentDirectory)
   }
   
   convenience init(fileName:String, fileExtension:FileExtension, subDirectory:String){
      self.init(fileName:fileName, fileExtension:fileExtension, subDirectory:subDirectory, directory:.documentDirectory)
   }
   
   /**
    Initialize the FileSaveHelper Object with parameters
    
    :param: fileName      The name of the file
    :param: fileExtension The file Extension
    :param: directory     The desired sub directory
    :param: saveDirectory Specify the NSSearchPathDirectory to save the file to
    
    */
   init(fileName:String, fileExtension:FileExtension, subDirectory:String, directory:FileManager.SearchPathDirectory){
      self.fileName = fileName + fileExtension.rawValue
      self.subDirectory = "/\(subDirectory)"
      self.directory = directory
      self.directoryPath = NSSearchPathForDirectoriesInDomains(directory, .userDomainMask, true)[0]
      self.filePath = directoryPath + self.subDirectory
      self.fullyQualifiedPath = "\(filePath)/\(self.fileName)"
      createDirectory()
   }
   
   /**
    If the desired directory does not exist, then create it.
    */
   private func createDirectory(){
      if !directoryExists {
         do {
            try fileManager.createDirectory(atPath: filePath, withIntermediateDirectories: false, attributes: nil)
         }
         catch {
            print("An Error was generated creating directory")
         }
      }
   }
   
   // MARK:- File saving methods
   
   /**
    Save the contents to file
    
    :param: fileContents A String that will be saved in the file
    */
   func saveFileWith(fileContents:String) throws{
      
      do {
         try fileContents.write(toFile: fullyQualifiedPath, atomically: true, encoding: .utf8)
      }
      catch  {
         throw error
      }
   }
   
   /**
    Save the image to file.
    
    :param: image UIImage
    */
   func saveFileWith(image:UIImage) throws {
      guard let data = UIImageJPEGRepresentation(image, 1.0) else {
         throw FileErrors.imageNotConvertedToData
      }
      if !fileManager.createFile(atPath: fullyQualifiedPath, contents: data, attributes: nil){
         throw FileErrors.fileNotSaved
      }
   }
   
   /**
    Save a JSON file
    
    :param: dataForJson NSData
    */
   func saveFileWith(dataForJson:AnyObject) throws{
      do {
         let jsonData = try convertObjectTo(data: dataForJson)
         if !fileManager.createFile(atPath: fullyQualifiedPath, contents: jsonData, attributes: nil){
            throw FileErrors.fileNotSaved
         }
      } catch {
         print(error)
         throw FileErrors.fileNotSaved
      }
      
   }
   
   func getContentsOfFile() throws -> String {
      guard fileExists else {
         throw FileErrors.fileNotFound
      }
      
      var returnString:String
      do {
         returnString = try String(contentsOfFile: fullyQualifiedPath, encoding: .utf8)
      } catch {
         throw FileErrors.fileNotRead
      }
      return returnString
   }
   
   func getImage() throws -> UIImage {
      guard fileExists else {
         throw FileErrors.fileNotFound
      }
      
      guard let image = UIImage(contentsOfFile: fullyQualifiedPath) else {
         throw FileErrors.fileNotRead
      }
      
      return image
      
   }
   
   func getJSONData() throws -> Dictionary<String, Any> {
      guard fileExists else {
         throw FileErrors.fileNotFound
      }
      do {
         let url = URL(fileURLWithPath: fullyQualifiedPath)
         let data = try Data(contentsOf: url)
         let jsonData = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as! Dictionary<String, Any>
         return jsonData
      } catch {
         throw FileErrors.fileNotRead
      }
      
   }
   
   // MARK:- Json Converting
   
   /**
    Convert the NSData to Json Data
    
    :param: data NSData
    
    :returns: Json Serialized NSData
    */
   private func convertObjectTo(data:AnyObject) throws -> Data {
      
      do {
         let newData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
         return newData
      }
      catch {
         print("Error writing data: \(error)")
      }
      throw FileErrors.jsonNotSerialized
   }
   
   
}



import Photos



class CustomPhotoAlbum: NSObject {
  static let albumName = "TodoList"
  static let sharedInstance = CustomPhotoAlbum()
  
  var assetCollection: PHAssetCollection!
  
  override init() {
    super.init()
    
    if let assetCollection = fetchAssetCollectionForAlbum() {
      self.assetCollection = assetCollection
      return
    }
    
    if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
      PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in
        status
      })
    }
    
    if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
      self.createAlbum()
    } else {
      PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler)
    }
  }
  
  func requestAuthorizationHandler(status: PHAuthorizationStatus) {
    if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
      // ideally this ensures the creation of the photo album even if authorization wasn't prompted till after init was done
      print("trying again to create the album")
      self.createAlbum()
    } else {
      print("should really prompt the user to let them know it's failed")
    }
  }
  
  func createAlbum() {
    if let assetCollection = fetchAssetCollectionForAlbum()
    {
      print("already have")
      self.assetCollection = assetCollection
    } else {
      PHPhotoLibrary.shared().performChanges({
        PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: CustomPhotoAlbum.albumName)   // create an asset collection with the album name
      }) { success, error in
        if success {
          self.assetCollection = self.fetchAssetCollectionForAlbum()
        } else {
          print("error \(error)")
        }
      }
    }
  }
  
  func fetchAssetCollectionForAlbum() -> PHAssetCollection! {
    let fetchOptions = PHFetchOptions()
    fetchOptions.predicate = NSPredicate(format: "title = %@", CustomPhotoAlbum.albumName)
    let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
    
    if let _: AnyObject = collection.firstObject {
      return collection.firstObject!
    }
    return nil
  }
  
  func saveImage(image: UIImage, completionBlock: @escaping (_ succeeded: Bool, _ localID: String) -> Void) {
    var localId = ""
    createAlbum()
    if assetCollection == nil {
      return completionBlock(false, "")                         // if there was an error upstream, skip the save
    }
    PHPhotoLibrary.shared().performChanges({
      let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
      let assetPlaceHolder = assetChangeRequest.placeholderForCreatedAsset
      let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection)
      albumChangeRequest!.addAssets([assetPlaceHolder!] as NSFastEnumeration)
      localId = (assetPlaceHolder?.localIdentifier)!
    }, completionHandler: {(success,error) in
      if success {
        completionBlock(true, localId)
        print("Success")
      }
      else {
        completionBlock(false, "")
        print("write error : \(error)")
      }
    })
  }
  
  func getImagePath(asset : PHAsset,image : UIImage, completionBlock: @escaping (_ filetype : String,_ fileurl: URL) -> Void)
  {
    PHImageManager.default().requestImageData(for: asset, options: nil, resultHandler: { _, _, _, info in
      
      if let fileName = (info?["PHImageFileURLKey"] as? NSURL)?.lastPathComponent {
        //do sth with file name
        print(fileName)
        Utils.sharedInstance.selectedImageName = fileName
        let filetype = fileName.components(separatedBy: ".").last
        let writePath = (NSTemporaryDirectory() as NSString).appendingPathComponent(fileName)
        let data  = UIImageJPEGRepresentation(image, 0.5)
        try? data!.write(to: URL(fileURLWithPath: writePath as String), options: [.atomic])
        _ = try! Data(contentsOf: URL(fileURLWithPath: writePath))
        let photoURL = URL(fileURLWithPath: writePath)
        completionBlock(filetype!,photoURL)
      }
    })
  }
  
  
  
}



