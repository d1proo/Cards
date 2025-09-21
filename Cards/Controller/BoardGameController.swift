
import UIKit

class BoardGameController: UIViewController {
	
	private var flippedCards = [UIView]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}
	
	override func loadView() {
		super.loadView()
		view.backgroundColor = .white
		view.addSubview(startButtonView)
		view.addSubview(boardGameView)
	}
	
	// количество пар уникальных карточек
	var cardsPairsCounts = 8
	// сущность "Игра"
	lazy var game: Game = getNewGame()
	
	private func getNewGame() -> Game {
		let game = Game()
		game.cardsCount = self.cardsPairsCounts
		game.generateCards()
		return game
	}
	
	// кнопка для запуска/перезапуска игры
	lazy var startButtonView = getStartButtonView()
	
	private func getStartButtonView() -> UIButton {
		let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
		button.center.x = view.center.x
		// получаем доступ к текущему окну
		let windowScene = UIApplication.shared.connectedScenes.first as! UIWindowScene
		let window = windowScene.windows[0]
		// определяем отступ сверху от границ окна до Safe Area
		let topPadding = window.safeAreaInsets.top
		// устанавливаем координату Y кнопки в соответствии с отступом
		button.frame.origin.y = topPadding
		button.layer.cornerRadius = 10
		button.setTitle("Начать игру", for: .normal)
		button.setTitleColor(.black, for: .normal)
		button.setTitleColor(.gray, for: .highlighted)
		button.backgroundColor = .lightGray
		
		// Подключаем обработчик нажатия
		button.addTarget(nil, action: #selector(startGame(_:)), for: .touchUpInside)
		return button
	}
	
	@objc func startGame(_ sender: UIButton) {
		let game = getNewGame()
		let cards = getCardsBy(modelData: game.cards)
		placeCardsOnBoard(cards)
	}
	
	lazy var boardGameView = getBoardGameView()
	
	private func getBoardGameView() -> UIView {
		let boardView = UIView()
		let margin: CGFloat = 10
		// Координата x
		boardView.frame.origin.x = margin
		// Координата y
		let windowScene = UIApplication.shared.connectedScenes.first as! UIWindowScene
		let window = windowScene.windows[0]
		let topPadding = window.safeAreaInsets.top
		boardView.frame.origin.y = topPadding + startButtonView.frame.height + margin
		boardView.frame.size.width = view.frame.width - margin * 2
		let bottomPadding = window.safeAreaInsets.bottom
		boardView.frame.size.height = UIScreen.main.bounds.height - boardView.frame.origin.y - bottomPadding
		boardView.backgroundColor = UIColor(red: 0.1, green: 0.9, blue: 0.1, alpha: 0.3)
		return boardView
	}
	
	// генерация массива карточек на основе данных Модели
	private func getCardsBy(modelData: [Card]) -> [UIView] {
		// хранилище для представлений карточек
		var cardViews = [UIView]()
		// фабрика карточек
		let cardViewFactory = CardViewFactory()
		// перебираем массив карточек в Модели
		for (index, modelCard) in modelData.enumerated() {
			// добавляем первый экземпляр карты
			let cardOne = cardViewFactory.get(modelCard.type, withSize: cardSize, andColor: modelCard.color)
			cardOne.tag = index
			cardViews.append(cardOne)
			// добавляем второй экземпляр карты
			let cardTwo = cardViewFactory.get(modelCard.type, withSize: cardSize, andColor: modelCard.color)
			cardTwo.tag = index
			cardViews.append(cardTwo)
		}
		// добавляем всем картам обработчик переворота
		for card in cardViews {
			(card as! FlippableView).flipCompletionHandler = { [self] flippedCard in
				// переносим карточку вверх иерархии
				flippedCard.superview?.bringSubviewToFront(flippedCard)
				
				// добавляем или удаляем карточку
				if flippedCard.isFlipped {
					self.flippedCards.append(flippedCard)
				} else {
					if let cardIndex = self.flippedCards.firstIndex(of: flippedCard) {
						self.flippedCards.remove(at: cardIndex)
					}
				}
				// если перевернуто 2 карточки
				if self.flippedCards.count == 2 {
					// получаем карточки из данных модели
					let firstCard = game.cards[self.flippedCards.first!.tag]
					let secondCard = game.cards[self.flippedCards.last!.tag]
					// если карточки одинаковые
					if game.checkCards(firstCard, secondCard) {
						// сперва анимировано скрываем их
						UIView.animate(withDuration: 0.3, animations: {
							self.flippedCards.first!.layer.opacity = 0
							self.flippedCards.last!.layer.opacity = 0
							// после чего удаляем из иерархии
						}, completion: {_ in
							self.flippedCards.first!.removeFromSuperview()
							self.flippedCards.last!.removeFromSuperview()
							self.flippedCards = []
						})
						// в ином случае
					} else {
						// переворачиваем карточки рубашкой вверх
						for card in self.flippedCards {
							(card as! FlippableView).flip()
						}
					}
				}
			}
		}
		return cardViews
	}
	
	// размеры карточек
	private var cardSize: CGSize {
		CGSize(width: 80, height: 120)
	}
	
	// предельные координаты размещения карточки
	private var cardMaxXCoordinate: Int {
		Int(boardGameView.frame.width - cardSize.width)
	}
	private var cardMaxYCoordinate: Int {
		Int(boardGameView.frame.height - cardSize.height)
	}
	
	// игральные карточки
	var cardViews = [UIView]()
	private func placeCardsOnBoard(_ cards: [UIView]) {
		// удаляем все имеющиеся на игровом поле карточки
		for card in cardViews {
			card.removeFromSuperview()
		}
		cardViews = cards
		// перебираем карточки
		for card in cardViews {
			// для каждой карточки генерируем случайные координаты
			let randomXCoordinate = Int.random(in: 0...cardMaxXCoordinate)
			let randomYCoordinate = Int.random(in: 0...cardMaxYCoordinate)
			card.frame.origin = CGPoint(x: randomXCoordinate, y:
											randomYCoordinate)
			// размещаем карточку на игровом поле
			boardGameView.addSubview(card)
		}
	}
}
