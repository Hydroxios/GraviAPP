import UIKit

class ViewController: UIViewController {

    @IBOutlet var percentLabel: UILabel!
    @IBOutlet var levelLabel: UILabel!
    
    @IBOutlet var progress: UIProgressView!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchClanXP()
    }
    
    @IBAction func fetchClanXP() {
        activityIndicator.startAnimating()
        guard let url = URL(string: "https://gravityclan.fr/api/bot/clanxp.php") else {
            print("URL invalide.")
            return
        }
        let session = URLSession.shared
        // 3. Créer une tâche de données pour la requête
        let task = session.dataTask(with: url) { (data, response, error) in
            // Vérifier s'il y a des erreurs
            if let error = error {
                print("Erreur de requête : \(error.localizedDescription)")
                return
            }
            
            // Vérifier si des données ont été reçues
            guard let data = data else {
                print("Aucune donnée reçue.")
                return
            }
            
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            if let dict = json as? [String: Any] {
                DispatchQueue.main.async {
                    if let number = dict["percent"] as? Double, let xp = dict["xp"] as? Int {
                        self.percentLabel.text = "\(number)% (\(xp) / 125000)"
                        UIView.animate(withDuration: 0.5, delay: 0.0, animations: {
                            self.progress.setProgress(Float(number)/100.0, animated: true)
                        })
                    }
                    if let level = dict["level"] as? Int {
                        self.levelLabel.text = "Level \(String(level))"
                    }
                    self.activityIndicator.stopAnimating()
                }
                
            }
        }
        
        // 4. Lancer la tâche de données pour effectuer la requête
        task.resume()
    }
    
}
