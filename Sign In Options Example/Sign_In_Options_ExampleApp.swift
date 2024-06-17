//// Import the SwiftUI framework for building the user interface
//import SwiftUI
//// Import the FirebaseCore library for initializing Firebase in the app
//import FirebaseCore
//// Import the FirebaseDatabase library for interacting with Realtime Database
//import FirebaseDatabase
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
//// createMedicalDevice function to create multiple medical device documents in Realtime Database
//func createMedicalDevice() {
//    let db = Database.database(url:"https://firestore-ios-codelab-6b5d5-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
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
//    // Write the thermometer data to Realtime Database
//    db.child("medicalDevices").childByAutoId().setValue(thermometer.toDictionary()) { error, ref in
//        if let error = error {
//            print("Error adding thermometer: \(error.localizedDescription)")
//        } else {
//            print("Thermometer document ID: \(ref.key ?? "Unknown")")
//        }
//    }
//
//    // Write the weight scale data to Realtime Database
//    db.child("medicalDevices").childByAutoId().setValue(weightScale.toDictionary()) { error, ref in
//        if let error = error {
//            print("Error adding weight scale: \(error.localizedDescription)")
//        } else {
//            print("Weight Scale document ID: \(ref.key ?? "Unknown")")
//        }
//    }
//
//    // Write the blood pressure monitor data to Realtime Database
//    db.child("medicalDevices").childByAutoId().setValue(bloodPressureMonitor.toDictionary()) { error, ref in
//        if let error = error {
//            print("Error adding blood pressure monitor: \(error.localizedDescription)")
//        } else {
//            print("Blood Pressure Monitor document ID: \(ref.key ?? "Unknown")")
//        }
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
//
//    func toDictionary() -> [String: Any] {
//        return [
//            "name": name,
//            "type": type,
//            "brand": brand,
//            "model": model,
//            "description": description,
//            "features": features
//        ]
//    }
//}



//// --------------------------------------------
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
