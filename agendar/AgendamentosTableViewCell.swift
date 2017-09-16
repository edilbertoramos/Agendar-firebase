
import UIKit

class AgendamentosTableViewCell: UITableViewCell
{
    @IBOutlet weak var lbServico: UILabel!
    @IBOutlet weak var lbData: UILabel!
    @IBOutlet weak var lbHoraInicial: UILabel!
    @IBOutlet weak var lbHoraFinal: UILabel!
    @IBOutlet weak var lbProfissional: UILabel!
    @IBOutlet weak var lbPreco: UILabel!

    @IBOutlet weak var vwAgendamentos: UIView!
    @IBOutlet weak var btImage: UIButton!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        vwAgendamentos.layer.cornerRadius = 3
        
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }

}
