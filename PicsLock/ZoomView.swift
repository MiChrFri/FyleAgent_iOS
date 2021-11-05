import UIKit

final class ZoomView: UIScrollView {
    private enum ZoomMode {
        case fit, fill
    }
    
    private var oldSize: CGSize?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.allowsEdgeAntialiasing = true
        return imageView
    }()
    
    private var zoomMode: ZoomMode = .fit {
        didSet {
            updateImageView()
            scrollToCenter()
        }
    }
    
    var image: UIImage? {
        get { return imageView.image }
        set {
            let oldImage = imageView.image
            imageView.image = newValue
            
            if oldImage?.size != newValue?.size {
                oldSize = nil
                updateImageView()
            }
            scrollToCenter()
        }
    }
    
    
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    init(image: UIImage) {
        super.init(frame: CGRect.zero)
        self.image = image
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func scrollToCenter() {
        let centerOffset = CGPoint(
            x: contentSize.width > bounds.width ? (contentSize.width / 2) - (bounds.width / 2) : 0,
            y: contentSize.height > bounds.height ? (contentSize.height / 2) - (bounds.height / 2) : 0
        )
        
        contentOffset = centerOffset
    }
    
    private func setup() {
        contentInsetAdjustmentBehavior = .never
        
        backgroundColor = UIColor.clear
        delegate = self
        imageView.contentMode = .scaleAspectFill
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        addSubview(imageView)
        
        self.setupGestureRecognizer()
    }
    
    private func setupGestureRecognizer() {
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTapGesture)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if imageView.image != nil && oldSize != bounds.size {
            updateImageView()
            oldSize = bounds.size
        }
        
        if imageView.frame.width <= bounds.width {
            imageView.center.x = bounds.width * 0.5
        }
        
        if imageView.frame.height <= bounds.height {
            imageView.center.y = bounds.height * 0.5
        }
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        updateImageView()
    }
    
    private func fitSize(aspectRatio: CGSize, boundingSize: CGSize) -> CGSize {
        let widthRatio = (boundingSize.width / aspectRatio.width)
        let heightRatio = (boundingSize.height / aspectRatio.height)
        
        var boundingSize = boundingSize
        
        if widthRatio < heightRatio {
            boundingSize.height = boundingSize.width / aspectRatio.width * aspectRatio.height
        }
        else if (heightRatio < widthRatio) {
            boundingSize.width = boundingSize.height / aspectRatio.height * aspectRatio.width
        }
        return CGSize(width: ceil(boundingSize.width), height: ceil(boundingSize.height))
    }
    
    private func fillSize(aspectRatio: CGSize, minimumSize: CGSize) -> CGSize {
        let widthRatio = (minimumSize.width / aspectRatio.width)
        let heightRatio = (minimumSize.height / aspectRatio.height)
        
        var minimumSize = minimumSize
        
        if widthRatio > heightRatio {
            minimumSize.height = minimumSize.width / aspectRatio.width * aspectRatio.height
        }
        else if (heightRatio > widthRatio) {
            minimumSize.width = minimumSize.height / aspectRatio.height * aspectRatio.width
        }
        return CGSize(width: ceil(minimumSize.width), height: ceil(minimumSize.height))
    }
    
    func updateImageView() {
        guard let image = imageView.image else { return }
        
        var size: CGSize
        
        switch zoomMode {
        case .fit:
            size = fitSize(aspectRatio: image.size, boundingSize: bounds.size)
        case .fill:
            size = fillSize(aspectRatio: image.size, minimumSize: bounds.size)
        }
        
        size.height = round(size.height)
        size.width = round(size.width)
        
        zoomScale = 1
        maximumZoomScale = image.size.width / size.width
        imageView.bounds.size = size
        contentSize = size
        imageView.center = ZoomView.contentCenter(forBoundingSize: bounds.size, contentSize: contentSize)
    }
    
    @objc private func handleDoubleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        if self.zoomScale == 1 {
            zoom(
                to: zoomRect(
                    //          for: max(1, maximumZoomScale / 3),
                    for: max(1, 3),
                    with: gestureRecognizer.location(in: gestureRecognizer.view)),
                animated: true
            )
        } else {
            setZoomScale(1, animated: true)
        }
    }
    
    private func zoomRect(for scale: CGFloat, with center: CGPoint) -> CGRect {
        let center = imageView.convert(center, from: self)
        
        var zoomRect = CGRect()
        zoomRect.size.height = bounds.height / scale
        zoomRect.size.width = bounds.width / scale
        zoomRect.origin.x = center.x - zoomRect.width / 2.0
        zoomRect.origin.y = center.y - zoomRect.height / 2.0
        
        return zoomRect
    }
    
    private static func contentCenter(forBoundingSize boundingSize: CGSize, contentSize: CGSize) -> CGPoint {
        let horizontalOffest = (boundingSize.width > contentSize.width) ? ((boundingSize.width - contentSize.width) * 0.5): 0.0
        let verticalOffset = (boundingSize.height > contentSize.height) ? ((boundingSize.height - contentSize.height) * 0.5): 0.0
        
        return CGPoint(x: contentSize.width * 0.5 + horizontalOffest, y: contentSize.height * 0.5 + verticalOffset)
    }
}

extension ZoomView: UIScrollViewDelegate {
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        imageView.center = ZoomView.contentCenter(forBoundingSize: bounds.size, contentSize: contentSize)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
}
