// 20240613 - no use for this project, it is a realtimedb test code

import UIKit
import FirebaseDatabase

class ViewController: UIViewController {

  var ref: DatabaseReference!

  @IBOutlet weak var userDataTextView: UITextView!

  override func viewDidLoad() {
    super.viewDidLoad()
    ref = Database.database().reference()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    writeUserData(userId: "1", name: "John Doe", email: "john.doe@example.com")
    readUserData(userId: "1")
  }

  func writeUserData(userId: String, name: String, email: String) {
    self.ref.child("users").child(userId).setValue(["username": name, "email": email])
  }

  func readUserData(userId: String) {
    self.ref.child("users").child(userId).observe(.value, with: { snapshot in
      let value = snapshot.value as? NSDictionary
      let username = value?["username"] as? String ?? ""
      let email = value?["email"] as? String ?? ""
      self.userDataTextView.text = "Username: \(username)\nEmail: \(email)"
    }) { error in
      print(error.localizedDescription)
    }
  }
}
