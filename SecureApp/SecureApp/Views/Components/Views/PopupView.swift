//
//  PopupView.swift
//  SecureApp
//
//  Created by Eduard Caziuc on 17.11.2022.
//

import SwiftUI
import Combine

public struct PopupView: View {
	
	// MARK: - Types
	
	public enum BannerAnimation {
		case slide, pop
	}
	
	/// Determine how the alert will be display
	public enum DisplayMode: Equatable {
		
		///Present at the center of the screen
		case alert
		
		///Drop from the top of the screen
		case notification
		
		///Banner from the bottom of the view
		case banner(_ transition: BannerAnimation)
	}
	
	/// Determine what the alert will display
	public enum AlertType: Equatable {
		
		///Animated checkmark
		case complete(_ color: Color = .green)
		
		///Animated xMark
		case error(_ color: Color = .red)
		
		///System image from `SFSymbols`
		case systemImage(_ name: String, _ color: Color = .secondary)
		
		///Image from Assets
		case image(_ name: String, _ color: Color = .secondary)
		
		///Loading indicator (Circular)
		case loading
		
		///Only text alert
		case regular
	}
	
	/// Customize Alert Appearance
	public enum AlertStyle: Equatable {
		case style(backgroundColor: Color? = nil,
					  titleColor: Color? = nil,
					  subTitleColor: Color? = nil,
					  titleFont: Font? = nil,
					  subTitleFont: Font? = nil)
		
		var backgroundColor: Color? {
			switch self{
			case .style(backgroundColor: let color, _, _, _, _):
				return color
			}
		}
		
		var titleColor: Color? {
			switch self{
			case .style(_,let color, _,_,_):
				return color
			}
		}
		
		var subtitleColor: Color? {
			switch self{
			case .style(_,_, let color, _,_):
				return color
			}
		}
		
		var titleFont: Font? {
			switch self {
			case .style(_, _, _, titleFont: let font, _):
				return font
			}
		}
		
		var subTitleFont: Font? {
			switch self {
			case .style(_, _, _, _, subTitleFont: let font):
				return font
			}
		}
	}
	
	// MARK: - Properties
	
	///The display mode
	/// - `alert`
	/// - `hud`
	/// - `banner`
	public var displayMode: DisplayMode = .alert
	
	///What the alert would show
	///`complete`, `error`, `systemImage`, `image`, `loading`, `regular`
	public var type: AlertType
	
	///The title of the alert (`Optional(String)`)
	public var title: String? = nil
	
	///The subtitle of the alert (`Optional(String)`)
	public var subTitle: String? = nil
	
	///Customize your alert appearance
	public var style: AlertStyle? = nil
	
	///Full init
	public init(displayMode: DisplayMode = .alert,
					type: AlertType,
					title: String? = nil,
					subTitle: String? = nil,
					style: AlertStyle? = nil) {
		
		self.displayMode = displayMode
		self.type = type
		self.title = title
		self.subTitle = subTitle
		self.style = style
	}
	
	///Short init with most used parameters
	public init(displayMode: DisplayMode,
					type: AlertType,
					title: String? = nil) {
		
		self.displayMode = displayMode
		self.type = type
		self.title = title
	}
	
	///Banner from the bottom of the view
	public var banner: some View {
		VStack {
			Spacer()
			
			VStack(alignment: .leading, spacing: 10) {
				HStack{
					switch type {
					case .complete(let color):
						Image(systemName: "checkmark")
							.foregroundColor(color)
					case .error(let color):
						Image(systemName: "xmark")
							.foregroundColor(color)
					case .systemImage(let name, let color):
						Image(systemName: name)
							.foregroundColor(color)
					case .image(let name, let color):
						Image(name)
							.foregroundColor(color)
					case .loading:
						LoadingView()
							.withFrame(true)
					case .regular:
						EmptyView()
					}
					
					Text(LocalizedStringKey(title ?? ""))
						.font(style?.titleFont ?? Font.headline.bold())
				}
				
				if subTitle != nil {
					Text(LocalizedStringKey(subTitle!))
						.font(style?.subTitleFont ?? Font.subheadline)
				}
			}
			.fixedSize(horizontal: true, vertical: false)
			.multilineTextAlignment(.leading)
			.textColor(style?.titleColor ?? nil)
			.padding()
			.frame(maxWidth: .infinity, alignment: .leading)
			.alertBackground(style?.backgroundColor ?? nil)
			.cornerRadius(10)
			.padding([.horizontal, .bottom])
		}
	}
	
	///Notification from the top of the View
	public var notification: some View {
		Group {
			HStack(spacing: 16) {
				switch type {
				case .complete(let color):
					Image(systemName: "checkmark.circle.fill")
						.notificationModifier()
						.foregroundColor(color)
				case .error(let color):
					Image(systemName: "xmark")
						.notificationModifier()
						.foregroundColor(color)
				case .systemImage(let name, let color):
					Image(systemName: name)
						.notificationModifier()
						.foregroundColor(color)
				case .image(let name, let color):
					Image(name)
						.notificationModifier()
						.foregroundColor(color)
				case .loading:
					LoadingView()
				case .regular:
					EmptyView()
				}
				
				if title != nil || subTitle != nil {
					VStack(spacing: 2) {
						if title != nil {
							Text(LocalizedStringKey(title ?? ""))
								.lineLimit(2)
								.multilineTextAlignment(.center)
								.font(style?.titleFont ?? .headline.weight(.semibold))
								.textColor(style?.titleColor ?? .secondary)
						}
						if subTitle != nil {
							Text(LocalizedStringKey(subTitle ?? ""))
								.lineLimit(1)
								.font(style?.subTitleFont ?? .subheadline.weight(.semibold))
								.textColor(style?.subtitleColor ?? Color.lightGray)
								.opacity(0.8)
						}
					}
					.padding(.trailing)
					.padding(.vertical, 8)
				}
			}
			.padding(.horizontal)
			.frame(minWidth: 196, minHeight: 50)
			.alertBackground(style?.backgroundColor ?? nil)
			.clipShape(Capsule())
			.shadow(radius: 16, x: 2, y: 2)
		}
		.padding(.top, 12)
		.padding(.horizontal, 48)
	}
	
	///Alert View
	public var alert: some View {
		HStack(spacing: title != nil ? 16 : 0) {
			switch type {
			case .complete(let color):
				AnimatedCheckmark(color: color, size: title != nil ? 32 : 56)
				
			case .error(let color):
				AnimatedXMark(color: color, size: title != nil ? 32 : 56)

			case .systemImage(let name, let color):
				Image(systemName: name)
					.renderingMode(.template)
					.resizable()
					.aspectRatio(contentMode: .fit)
					.scaledToFit()
					.foregroundColor(color)
					.padding(.bottom)

			case .image(let name, let color):
				Image(name)
					.resizable()
					.aspectRatio(contentMode: .fit)
					.scaledToFit()
					.foregroundColor(color)
					.padding(.bottom)

			case .loading:
				LoadingView()

			case .regular:
				EmptyView()
			}
			
			VStack(spacing: type == .regular ? 8 : 2) {
				if title != nil {
					Text(LocalizedStringKey(title ?? ""))
						.font(style?.titleFont ?? Font.body.bold())
						.multilineTextAlignment(.center)
						.textColor(style?.titleColor ?? nil)
				}
				if subTitle != nil {
					Text(LocalizedStringKey(subTitle ?? ""))
						.font(style?.subTitleFont ?? Font.footnote)
						.opacity(0.7)
						.multilineTextAlignment(.center)
						.textColor(style?.subtitleColor ?? nil)
				}
			}
			
		}
		.padding(40)
		.withFrame(type != .regular && type != .loading && title == nil)
		.alertBackground(style?.backgroundColor ?? nil)
		.cornerRadius(12)
	}
	
	public var body: some View {
		switch displayMode {
		case .alert:
			alert
		case .notification:
			notification
		case .banner:
			banner
		}
	}
}

// MARK: - Modifiers

public struct PopupModifier: ViewModifier {
	@Binding var isPresenting: Bool
	@State var duration: Double = 2
	@State var tapToDismiss: Bool = true
	var offsetY: CGFloat = 0
	var alert: () -> PopupView
	var onTap: (() -> ())? = nil
	var completion: (() -> ())? = nil
	
	@State private var workItem: DispatchWorkItem?
	@State private var hostRect: CGRect = .zero
	@State private var alertRect: CGRect = .zero
	
	private var screen: CGRect {
		return UIScreen.main.bounds
	}
	
	private var offset: CGFloat {
		return -hostRect.midY + alertRect.height
	}
	
	@ViewBuilder
	public func main() -> some View {
		if isPresenting {
			
			switch alert().displayMode {
			case .alert:
				ZStack {
					BlurView().opacity(0.8).ignoresSafeArea()
					
					alert()
						.onTapGesture {
							onTap?()
							if tapToDismiss {
								withAnimation(.spring()) {
									self.workItem?.cancel()
									isPresenting = false
									self.workItem = nil
								}
							}
						}
						.onDisappear(perform: {
							completion?()
						})
						.transition(.scale(scale: 0.8).combined(with: .opacity))
				}
				
			case .notification:
				alert()
					.overlay (
						GeometryReader { geo -> AnyView in
							let rect = geo.frame(in: .global)
							
							if rect.integral != alertRect.integral {
								DispatchQueue.main.async {
									self.alertRect = rect
								}
							}
							return AnyView(EmptyView())
						}
					)
					.onTapGesture {
						onTap?()
						if tapToDismiss {
							withAnimation(.spring()) {
								self.workItem?.cancel()
								isPresenting = false
								self.workItem = nil
							}
						}
					}
					.onDisappear(perform: {
						completion?()
					})
					.transition(.move(edge: .top).combined(with: .opacity))
				
			case .banner:
				alert()
					.onTapGesture {
						onTap?()
						if tapToDismiss {
							withAnimation(.spring()) {
								self.workItem?.cancel()
								isPresenting = false
								self.workItem = nil
							}
						}
					}
					.onDisappear(perform: {
						completion?()
					})
					.transition(alert().displayMode == .banner(.slide) ? .slide.combined(with: .opacity) : .move(edge: .bottom))
			}
		}
	}
	
	@ViewBuilder
	public func body(content: Content) -> some View {
		switch alert().displayMode {
		case .banner:
			content
				.overlay(
					ZStack {
						main()
							.offset(y: offsetY)
					}
						.animation(.spring(), value: isPresenting)
				)
				.onChange(of: isPresenting) { presented in
					if presented {
						onAppearAction()
					}
				}
		case .notification:
			content
				.background(
					GeometryReader { geo -> AnyView in
						let rect = geo.frame(in: .global)
						
						if rect.integral != hostRect.integral {
							DispatchQueue.main.async {
								self.hostRect = rect
							}
						}
						return AnyView(EmptyView())
					}
				)
				.overlay(
					ZStack {
						main()
							.offset(y: offsetY)
					}
						.frame(maxWidth: .infinity, maxHeight: .infinity)
						.offset(y: offset)
						.animation(.spring(), value: isPresenting))

				.onChange(of: isPresenting) { presented in
					if presented {
						onAppearAction()
					}
				}
		case .alert:
			content
				.overlay(
					ZStack {
						main()
							.offset(y: offsetY)
					}
						.frame(maxWidth: screen.width, maxHeight: screen.height)
						.ignoresSafeArea()
						.animation(.spring(), value: isPresenting))
			
				.onChange(of: isPresenting) { presented in
					if presented {
						onAppearAction()
					}
				}
		}
	}
	
	private func onAppearAction() {
		guard workItem == nil else {
			return
		}
		
		if alert().type == .loading {
			duration = 0
			tapToDismiss = false
		}
		if duration > 0 {
			workItem?.cancel()
			let task = DispatchWorkItem {
				withAnimation(.spring()) {
					isPresenting = false
					workItem = nil
				}
			}
			workItem = task
			DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: task)
		}
	}
}

///View Modifier for dynamic frame when alert type is `.regular` / `.loading`
fileprivate struct WithFrameModifier: ViewModifier {
	var withFrame: Bool
	var maxWidth: CGFloat = 175
	var maxHeight: CGFloat = 175
	
	@ViewBuilder
	func body(content: Content) -> some View {
		if withFrame {
			content
				.frame(maxWidth: maxWidth, maxHeight: maxHeight)
		}else {
			content
		}
	}
}

///View Modifier to change the alert background
fileprivate struct BackgroundModifier: ViewModifier {
	var color: Color?
	
	@ViewBuilder
	func body(content: Content) -> some View {
		if color != nil {
			content
				.background(color)
		} else {
			content
				.background(Color.gray6)
		}
	}
}

///View Modifier to change the text colors
fileprivate struct TextForegroundModifier: ViewModifier {
	var color: Color?
	
	@ViewBuilder
	func body(content: Content) -> some View {
		if color != nil {
			content
				.foregroundColor(color)
		} else {
			content
		}
	}
}

fileprivate extension Image {
	func notificationModifier() -> some View {
		self
			.renderingMode(.template)
			.resizable()
			.aspectRatio(contentMode: .fit)
			.frame(maxWidth: 20, maxHeight: 20)
	}
}

public extension View {
	/// Return some view w/o frame depends on the condition.
	/// This view modifier function is set by default to:
	/// - `maxWidth`: 175
	/// - `maxHeight`: 175
	fileprivate func withFrame(_ withFrame: Bool) -> some View {
		modifier(WithFrameModifier(withFrame: withFrame))
	}
	
	/// Present `PopupView`.
	/// - Parameters:
	///   - isPresenting: Binding<Bool>
	///   - alert: () -> PopupView
	/// - Returns: `PopupView`
	func popup(isPresenting: Binding<Bool>, duration: Double = 2, tapToDismiss: Bool = true, offsetY: CGFloat = 0, alert: @escaping () -> PopupView, onTap: (() -> ())? = nil, completion: (() -> ())? = nil) -> some View {
		modifier(PopupModifier(isPresenting: isPresenting, duration: duration, tapToDismiss: tapToDismiss, offsetY: offsetY, alert: alert, onTap: onTap, completion: completion))
	}
	
	/// Choose the alert background
	/// - Parameter color: Some Color, if `nil` return `VisualEffectBlur`
	/// - Returns: some View
	fileprivate func alertBackground(_ color: Color? = nil) -> some View {
		modifier(BackgroundModifier(color: color))
	}
	
	/// Choose the alert background
	/// - Parameter color: Some Color, if `nil` return `.black`/`.white` depends on system theme
	/// - Returns: some View
	fileprivate func textColor(_ color: Color? = nil) -> some View {
		modifier(TextForegroundModifier(color: color))
	}
}

// MARK: - Animated Marks

fileprivate struct AnimatedCheckmark: View {
	var color: Color = .black
	var size: Int = 50
	var height: CGFloat { return CGFloat(size) }
	var width: CGFloat { return CGFloat(size) }
	
	@State private var percentage: CGFloat = .zero
	
	var body: some View {
		Path { path in
			path.move(to: CGPoint(x: 0, y: height / 2))
			path.addLine(to: CGPoint(x: width / 2.5, y: height))
			path.addLine(to: CGPoint(x: width, y: 0))
		}
		.trim(from: 0, to: percentage)
		.stroke(color, style: StrokeStyle(lineWidth: CGFloat(size / 8), lineCap: .round, lineJoin: .round))
		.animation(Animation.spring().speed(0.75).delay(0.25), value: percentage)
		.frame(width: width, height: height, alignment: .center)
		
		.onAppear {
			percentage = 1.0
		}
	}
}

fileprivate struct AnimatedXMark: View {
	var color: Color = .black
	var size: Int = 50
	var height: CGFloat { return CGFloat(size) }
	var width: CGFloat { return CGFloat(size) }
	var rect: CGRect { return CGRect(x: 0, y: 0, width: size, height: size) }
	
	@State private var percentage: CGFloat = .zero
	
	var body: some View {
		Path { path in
			path.move(to: CGPoint(x: rect.minX, y: rect.minY))
			path.addLine(to: CGPoint(x: rect.maxY, y: rect.maxY))
			path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
			path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
		}
		.trim(from: 0, to: percentage)
		.stroke(color, style: StrokeStyle(lineWidth: CGFloat(size / 8), lineCap: .round, lineJoin: .round))
		.animation(Animation.spring().speed(0.75).delay(0.25), value: percentage)
		.frame(width: width, height: height, alignment: .center)
		
		.onAppear {
			percentage = 1.0
		}
	}
}
