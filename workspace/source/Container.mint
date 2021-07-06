component Container {
  connect Breakpoints exposing { br }
  property children : Array(Html) = []

  style container {
    margin: auto;

    case (br) {
      Br::SM =>

      Br::MD =>
        max-width: #{ScreenSize:SM}px;

      Br::LG =>
        max-width: #{ScreenSize:MD}px;

      Br::XL =>
        max-width: #{ScreenSize:LG}px;

      Br::XL2 =>
        max-width: #{ScreenSize:XL}px;
    }
  }

  fun render {
    <div::container>
      <{ children }>
    </div>
  }
}
