import UIKit

protocol ShapeLayerProtocol: CAShapeLayer {
	init(size: CGSize, fillColor: CGColor)
}

extension ShapeLayerProtocol {
	init() {
		fatalError("init() не может быть использован для создания экземпляра")
	}
}

class CircleShape: CAShapeLayer,ShapeLayerProtocol {
	
	required init(size: CGSize, fillColor: CGColor) {
		super.init()
		// Радиус круга считаем по минимальной стороне
		let radius: CGFloat = min(size.width, size.height) / 2
		// Центр круга - центры сторон
		let centerX = size.width / 2
		let centerY = size.height / 2
		// Рисуем круг через кривые Безье
		let bezierPath = UIBezierPath(arcCenter: CGPoint(x: centerX, y: centerY), radius: radius, startAngle: 0, endAngle: .pi*2, clockwise: true)
		bezierPath.close()
		self.path = bezierPath.cgPath
		self.fillColor = fillColor
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

class SquareShape: CAShapeLayer,ShapeLayerProtocol {
	required init(size: CGSize, fillColor: CGColor) {
		super.init()
		// Сторона квадрата как минимальная из введеных
		let side: CGFloat = min(size.width, size.height)
		let bezierPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: side, height: side))
		bezierPath.close()
		self.path = bezierPath.cgPath
		self.fillColor = fillColor
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

class CrossShape: CAShapeLayer,ShapeLayerProtocol {
	required init(size: CGSize, fillColor: CGColor) {
		super.init()
		let path = UIBezierPath()
		// Создаем крест через линии
		path.move(to: CGPoint(x: 0, y: 0))
		path.addLine(to: CGPoint(x: size.width, y: size.height))
		path.move(to: CGPoint(x: size.width, y: 0))
		path.addLine(to: CGPoint(x: 0, y: size.height))
		// Толщина прямой
		self.lineWidth = 5
		self.path = path.cgPath
		self.strokeColor = fillColor
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

class FillShape: CAShapeLayer,ShapeLayerProtocol {
	required init(size: CGSize, fillColor: CGColor) {
		super.init()
		let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: size.width, height: size.height))
		self.path = path.cgPath
		self.fillColor = fillColor
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

class BackSideCircle:CAShapeLayer, ShapeLayerProtocol {
	required init(size: CGSize, fillColor: CGColor) {
		super.init()
		let path = UIBezierPath()
		for _ in 1...15 {
			// Рандомно определяем центр в рамках карточки
			let centerX = CGFloat.random(in: 0...size.width)
			let centerY = CGFloat.random(in: 0...size.height)
			let radius = CGFloat.random(in: 5...15)
			path.move(to: CGPoint(x: centerX, y: centerY))
			// Рандомный радиус
			path.addArc(withCenter: CGPoint(x: centerX, y: centerY), radius: radius, startAngle: 0, endAngle: .pi*2, clockwise: true)
		}
		self.path = path.cgPath
		self.strokeColor = fillColor
		self.fillColor = fillColor
		self.lineWidth = 1
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

class BackSideLine: CAShapeLayer, ShapeLayerProtocol {
	required init(size: CGSize, fillColor: CGColor) {
		super.init()
		let path = UIBezierPath()
		// рисуем 15 линий
		for _ in 1...15 {
			// координаты начала очередной линии
			let randomXStart = Int.random(in: 0...Int(size.width))
			let randomYStart = Int.random(in: 0...Int(size.height))
			// координаты конца очередной линии
			let randomXEnd = Int.random(in: 0...Int(size.width))
			let randomYEnd = Int.random(in: 0...Int(size.height))
			// смещаем указатель к началу линии
			path.move(to: CGPoint(x: randomXStart, y: randomYStart))
			// рисуем линию
			path.addLine(to: CGPoint(x: randomXEnd, y: randomYEnd))
		}
		// инициализируем созданный путь
		self.path = path.cgPath
		// изменяем стиль линий
		self.strokeColor = fillColor
		self.lineWidth = 3
		self.lineCap = .round
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
