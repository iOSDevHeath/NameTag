//
//  Contacts.swift
//  NameTag
//
//  Created by Heath Fashina on 2021-12-27.
//

import UIKit
import SwiftUI

class Contacts: ObservableObject {
    @Published var items: [Contact]
    
    @Published var showAddContact = false
    @Published var showImagePicker = false
    //@Published var selectedImage: UIImage? = nil
    @Published var image: Image? = nil
    
    init() {
        items = []
    }
    
    func loadImage(selectedImage: UIImage?) {
        guard let selectedImage = selectedImage else {
            return
        }

        image = Image(uiImage: selectedImage)
        
    }
    
    func addContact(name: String, image: UIImage) throws {
        let newContact = Contact(name: name)
        do {
            try FileManager().saveImage(newContact.id.uuidString, image: image)
            items.append(newContact)
            try saveContactsJSONFile()
        } catch {
            throw NameTagError.saveError
        }
    }
    
    func saveContactsJSONFile() throws {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(items)
            let jsonString = String(decoding: data, as: UTF8.self)
            do {
                try FileManager().saveDocument(jsonString)
            } catch {
                throw NameTagError.encodingError
            }
        } catch {
            throw NameTagError.encodingError
        }
    }
    
    func loadImagesJSONFile() throws {
        do {
            let data = try FileManager().readDocument()
            let decoder = JSONDecoder()
            do {
                items = try decoder.decode([Contact].self, from: data)
            } catch {
                throw NameTagError.decodingError
            }
        } catch {
            throw NameTagError.decodingError
        }
    }
    
    static let example = Contact(name: "Test")
}