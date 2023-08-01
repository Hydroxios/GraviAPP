import UIKit

class ViewController: UIViewController {

    var isMenuVisible = false
        
    @IBOutlet var label: UILabel!
    @IBOutlet var slider: UISlider!
    @IBOutlet var progress: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progress.progress = (slider.value/100.0)
        label.text = "\(String(Int(progress.progress*100)))%"
    }
    
    @IBAction func changeLabel(_ sender: UISlider){
        progress.progress = (slider.value/100.0)
        label.text = "\(String(Int(progress.progress*100)))%"
    }
    
    @IBAction func makeHTTPRequest(_ sender: UIButton) {
        // 1. Créer une URL pour la requête
        guard let url = URL(string: "https://gravityclan.fr/api/bot/clanxp.php") else {
            print("URL invalide.")
            return
        }
        
        // 2. Créer une URLSession
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
            
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                print(jsonObject)
            } catch {
                print("Erreur lors du traitement des données JSON : \(error.localizedDescription)")
            }
        }
        
        // 4. Lancer la tâche de données pour effectuer la requête
        task.resume()
    }
}
