//
//  InfoViewController.swift
//  MyHabits
//
//  Created by Дмитрий Дудник on 19.06.2025.
//

import UIKit

class InfoViewController: UIViewController {

    @IBOutlet weak var infoLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(named: "GrayBackground")
        navigationItem.title = "Информация"
        
        title = "Информация"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.hidesBackButton = true

        let fullText = """
        Привычка за 21 день

        Прохождение этапов, за которые за 21 день вырабатывается привычка, подчиняется следующему алгоритму:

        1. Провести 1 день без обращения к старым привычкам, стараться вести себя так, как будто цель, загаданная в перспективу, находится на расстоянии шага.

        2. Выдержать 2 дня в прежнем состоянии самоконтроля.

        3. Отметить в дневнике первую неделю изменений и подвести первые итоги — что оказалось тяжело, что — легче, с чем еще предстоит серьезно бороться.

        4. Поздравить себя с прохождением первого серьезного порога в 21 день.  
        За это время отказ от дурных наклонностей уже примет форму осознанного преодоления и человек сможет больше работать в сторону принятия положительных качеств.

        5. Держать планку 40 дней.  
        Практикующий методику уже чувствует себя освободившимся от прошлого негатива и двигается в нужном направлении с хорошей динамикой.

        6. На 90-й день соблюдения техники все лишнее из «прошлой жизни» перестает напоминать о себе, и человек, оглянувшись назад, осознает себя полностью обновившимся.

        Источник: psychbook.ru
        """

        let attributedText = NSMutableAttributedString(string: fullText)

        if let range = fullText.range(of: "Привычка за 21 день") {
            let nsRange = NSRange(range, in: fullText)
            attributedText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 20), range: nsRange)
        }

        infoLabel.attributedText = attributedText
        
        infoLabel.numberOfLines = 0
        infoLabel.textAlignment = .left
    }
}
