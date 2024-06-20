//// Import the SwiftUI framework for building the user interface
//import SwiftUI
//// Import the FirebaseCore library for initializing Firebase in the app
//import FirebaseCore
//// Import the FirebaseFirestore library for interacting with Firestore database
//import FirebaseFirestore
//// Import the FirebaseFirestoreSwift library for using Swift-friendly Firestore features
//import FirebaseFirestoreSwift
//
//// AppDelegate class to initialize Firebase and create medical device data on app launch
//class AppDelegate: NSObject, UIApplicationDelegate {
//    func application(_ application: UIApplication,
//                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        // Initialize Firebase
//        FirebaseApp.configure()
//        // Create medical device data
//        createMedicalDevice()
//        return true
//    }
//}
//
//// --------------------------------------------
//// DO ONLY FIRESTORE UPDATE @main
//// --------------------------------------------
//// FirestoreExampleApp class to launch the app and initialize Firebase and medical device data
////@main
////class FirestoreExampleApp: UIResponder, UIApplicationDelegate {
////    var window: UIWindow?
////
////    func application(_ application: UIApplication,
////                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
////        // Initialize Firebase
////        FirebaseApp.configure()
////        // Create medical device data
////        createMedicalDevice()
////        return true
////    }
////}
//
//// --------------------------------------------
//// DO AUTHSERVICE @main
//// --------------------------------------------
//@main
//struct Sign_In_Options_ExampleApp: App {
//    // Register app delegate for Firebase setup
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
//
//    @StateObject var authService = AuthService()
//
//    var body: some Scene {
//        WindowGroup {
//            StartView()
//                .environmentObject(authService)
//        }
//    }
//}
//// --------------------------------------------
//
//// createMedicalDevice function to create multiple medical device documents in Firestore
//func createMedicalDevice() {
//    let db = Firestore.firestore()
//
//    // Create a non-contact infrared thermometer object
//    let thermometer = MedicalDevice(
//        name: "Non-Contact Infrared Thermometer",
//        type: "Thermometer",
//        brand: "AccuTemp",
//        model: "AT-101",
//        description: "Measures body temperature using infrared technology.",
//        features: ["Non-contact", "Fever alarm", "Memory recall"]
//    )
//
//    // Create a digital body weight scale object
//    let weightScale = MedicalDevice(
//        name: "Digital Body Weight Scale",
//        type: "Weight Scale",
//        brand: "HealthSense",
//        model: "HS-32",
//        description: "Accurately measures body weight up to 400 lbs.",
//        features: ["Large LCD display", "Step-on technology", "Tempered glass platform"]
//    )
//
//    // Create an automatic blood pressure monitor object
//    let bloodPressureMonitor = MedicalDevice(
//        name: "Automatic Blood Pressure Monitor",
//        type: "Blood Pressure Monitor",
//        brand: "Omron",
//        model: "BP785N",
//        description: "Measures blood pressure and pulse rate with advanced accuracy.",
//        features: ["Easy one-touch operation", "Irregular heartbeat detection", "Two user memory"]
//    )
//
//    do {
//        // Write the thermometer data to Firestore database
//        let thermometerRef = try db.collection("medicalDevices").addDocument(from: thermometer)
//        // Write the weight scale data to Firestore database
//        let weightScaleRef = try db.collection("medicalDevices").addDocument(from: weightScale)
//        // Write the blood pressure monitor data to Firestore database
//        let bloodPressureMonitorRef = try db.collection("medicalDevices").addDocument(from: bloodPressureMonitor)
//
//        // Print each document's ID
//        print("Thermometer document ID: \(thermometerRef.documentID)")
//        print("Weight Scale document ID: \(weightScaleRef.documentID)")
//        print("Blood Pressure Monitor document ID: \(bloodPressureMonitorRef.documentID)")
//    } catch {
//        // Catch and print any errors
//        print(error)
//    }
//}
//
//// MedicalDevice struct to define the properties of a medical device
//struct MedicalDevice: Codable {
//    let name: String
//    let type: String
//    let brand: String
//    let model: String
//    let description: String
//    let features: [String]
//}

//
//  Sign_In_Options_ExampleApp.swift
//  Sign In Options Example
//
//  Created by Lucian Lu by 2024/05/09
//

//import SwiftUI
//import FirebaseCore
//
//class AppDelegate: NSObject, UIApplicationDelegate {
//  func application(_ application: UIApplication,
//                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//    FirebaseApp.configure()
//    return true
//  }
//}
//
//@main
//struct Sign_In_Options_ExampleApp: App {
//    // register app delegate for Firebase setup
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
//
//    @StateObject var authService = AuthService()
//
//    var body: some Scene {
//        WindowGroup {
//            StartView()
//                .environmentObject(authService)
//        }
//    }
//}
//


//struct Song: Codable, Identifiable {
//    @DocumentID var id: String?
//    let name: String
//    let singer: String
//    let rate: Int
//}

//func createSong() {
//    let db = Firestore.firestore()
//    let song = Song(name: "陪你很久很久", singer: "小球", rate: 5)
//    do {
//        let documentReference = try db.collection("songs").addDocument(from: song)
//        print(documentReference.documentID)
//    } catch {
//        print(error)
//    }
//}

// Fail Code as following ---

//import Firebase
//import FirebaseDatabase
//
//class DatabaseService: ObservableObject {
//    private let dbRef = Database.database().reference()
//    
//    func saveStringToDatabase(string: String) {
//        let messagesRef = dbRef.child("messages").childByAutoId()
//        messagesRef.setValue(string) { (error, reference) in
//            if let error = error {
//                print("Failed to save data: \(error.localizedDescription)")
//            } else {
//                print("Data saved successfully: \(reference.key ?? "")")
//            }
//        }
//    }
//}
//
//struct ContentView: View {
//    @StateObject private var databaseService = DatabaseService()
//    @State private var textFieldValue = ""
//    
//    var body: some View {
//        VStack {
//            TextField("Enter text", text: $textFieldValue)
//            Button("Save to Firebase") {
//                databaseService.saveStringToDatabase(string: textFieldValue)
//            }
//        }
//        .padding()
//    }
//}
