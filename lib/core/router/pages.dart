/// Every route in the app. Path and name are required, so a page cannot
/// exist without both; switch over it without a `default:` so a new page is
/// a compile error until it is handled.
///
/// Navigate with `context.go(PAGES.x.screenPath)` / `context.push(...)`.
/// Never use raw path strings.
enum PAGES {
  home('/', 'HOME'),
  login('/login', 'LOGIN'),
  register('/register', 'REGISTER'),
  designSystem('/design-system', 'DESIGN_SYSTEM');

  const PAGES(this.screenPath, this.screenName);
  final String screenPath;
  final String screenName;
}
